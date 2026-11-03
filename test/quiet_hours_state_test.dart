import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/state/quiet_hours_state.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

import 'quiet_hours_fixture.dart';

void main() {
  late QuietHoursFixture fixture;
  late QuietHoursState state;
  const enabled = QuietHoursSetting(
    enabled: true,
    start: '22:00',
    end: '08:00',
    timeZone: 'Europe/Berlin',
  );

  setUp(() async {
    fixture = QuietHoursFixture();
    await fixture.start();
    state = QuietHoursState(
      client: fixture.client,
      accountId: fixture.accountId,
      localTimeZone: () async => 'Asia/Kathmandu',
    );
  });
  tearDown(() {
    state.dispose();
    fixture.close();
  });

  test(
    'load defaults off with device IANA zone and never writes on load',
    () async {
      await state.load();
      expect(state.setting!.enabled, isFalse);
      expect(state.setting!.timeZone, 'Asia/Kathmandu');
      expect(state.setting!.start, isEmpty);
      expect(state.setting!.end, isEmpty);
      expect(state.editable, isTrue);
      expect(fixture.gate.puts, 0);
      expect(
        (await fixture.client.quietHours(fixture.accountId)).timeZone,
        isEmpty,
      );
    },
  );

  test('load preserves a configured zone instead of the device zone', () async {
    await fixture.client.setQuietHours(fixture.accountId, enabled);
    await state.load();
    expect(state.setting!.timeZone, 'Europe/Berlin');
    expect(state.setting!.enabled, isTrue);
  });

  test(
    'enable, edit, save, edit saved schedule and disable persist per account',
    () async {
      await state.load();
      state.edit(enabled);
      expect(fixture.gate.puts, 0);
      await state.save();
      expect(state.saved, isTrue);
      expect(
        (await fixture.client.quietHours(fixture.accountId)).start,
        '22:00',
      );
      state.edit(
        state.setting!.copyWith(start: '23:30', timeZone: 'America/New_York'),
      );
      expect(state.saved, isFalse);
      await state.save();
      expect(
        (await fixture.client.quietHours(fixture.accountId)).timeZone,
        'America/New_York',
      );
      state.edit(state.setting!.copyWith(enabled: false));
      await state.save();
      final disabled = await fixture.client.quietHours(fixture.accountId);
      expect(disabled.enabled, isFalse);
      expect(disabled.start, '23:30');
      expect(disabled.end, '08:00');
      expect(disabled.timeZone, 'America/New_York');
    },
  );

  test('validation refusal keeps draft and previous server setting', () async {
    await state.load();
    state.edit(enabled.copyWith(end: '22:00', timeZone: 'Mars/Olympus'));
    await state.save();
    expect(state.error!.statusCode, 422);
    expect(state.error!.fields['end'], 'must differ from start');
    expect(state.error!.fields['time_zone'], 'must be an IANA time zone name');
    expect(state.setting!.enabled, isTrue);
    expect(state.saved, isFalse);
    expect(
      (await fixture.client.quietHours(fixture.accountId)).enabled,
      isFalse,
    );
    state.edit(enabled);
    await state.save();
    expect(state.error, isNull);
    expect(state.saved, isTrue);
  });

  test('load failure locks editing and retry recovers', () async {
    fixture.fake.online = false;
    await state.load();
    expect(state.error!.isNetworkError, isTrue);
    expect(state.editable, isFalse);
    state.edit(enabled);
    await state.save();
    expect(fixture.gate.puts, 0);
    fixture.fake.online = true;
    await state.load();
    expect(state.editable, isTrue);
    expect(state.error, isNull);
  });

  test('permission refusal does not save or end the session', () async {
    fixture.fake.grant(FakeAccounts.email, {'mail:read'});
    final readonly = QuietHoursState(
      client: fixture.client,
      accountId: fixture.otherId,
      localTimeZone: () async => 'Europe/Berlin',
    );
    addTearDown(readonly.dispose);
    await readonly.load();
    readonly.edit(enabled);
    await readonly.save();
    expect(readonly.error!.statusCode, 403);
    expect(readonly.error!.message, 'Access denied');
    expect(readonly.saved, isFalse);
    expect((await fixture.client.quietHours(fixture.otherId)).enabled, isFalse);
    expect(fixture.client.tokens, isNotNull);
  });

  test('pending loads and saves cannot double-submit or edit', () async {
    fixture.gate.hold = Completer<void>();
    final loading = state.load();
    expect(state.loading, isTrue);
    expect(state.editable, isFalse);
    await state.save();
    fixture.gate.hold!.complete();
    await loading;
    state.edit(enabled);
    fixture.gate.hold = Completer<void>();
    final saving = state.save();
    expect(state.saving, isTrue);
    state.edit(enabled.copyWith(start: '01:00'));
    await state.save();
    fixture.gate.hold!.complete();
    await saving;
    expect(state.setting!.start, '22:00');
    expect(fixture.gate.puts, 1);
  });

  test('late response after dispose does not notify', () async {
    final temporary = QuietHoursState(
      client: fixture.client,
      accountId: fixture.accountId,
      localTimeZone: () async => '',
    );
    fixture.gate.hold = Completer<void>();
    final loading = temporary.load();
    temporary.dispose();
    fixture.gate.hold!.complete();
    await loading;
  });
}
