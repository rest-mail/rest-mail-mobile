import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/add_account_screen.dart';
import 'package:restmail/ui/api_keys_screen.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail/util/secret_clipboard.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

const _token = 'rmk_ABCDEFGHIJKL_AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';

/// A fixture for the new server contract. Ordinary requests still reach the
/// fake, so these tests exercise the real sign-in and Settings navigation.
class _Keys {
  Map<String, dynamic>? request;
  String? refusal;
  bool exists = false;
  int revoked = 0;
  String? scope;

  Map<String, Object?> get metadata => {
    'id': 77,
    'name': 'Provisioning',
    'kind': 'api_key',
    'public_id': 'ABCDEFGHIJKL',
    'created_at': '2026-10-22T12:00:00Z',
    'last_used_at': null,
    'expires_at': '2027-01-20T12:00:00Z',
    'permissions': [
      {
        'capability': 'mail:read',
        'scope': scope ?? 'mailbox:${FakeAccounts.adminEmail}',
      },
    ],
  };
}

class _KeyClient extends http.BaseClient {
  _KeyClient(this.inner, this.keys);
  final http.Client inner;
  final _Keys keys;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!request.url.path.contains('/api-keys')) return inner.send(request);
    final raw = await request.finalize().toBytes();
    Object? body;
    var status = 200;
    switch (request.method) {
      case 'GET':
        body = {
          'data': [if (keys.exists) keys.metadata],
        };
      case 'POST':
        keys.request = jsonDecode(utf8.decode(raw)) as Map<String, dynamic>;
        if (keys.refusal case final code?) {
          status = code == 'validation_failed'
              ? 422
              : code == 'http_404'
              ? 404
              : 403;
          body = {
            'error': {
              'code': code,
              'message': 'The request was refused',
              if (code == 'validation_failed')
                'details': {
                  'fields': {'permissions': 'scope invalid'},
                },
            },
          };
        } else {
          keys.exists = true;
          status = 201;
          body = {
            'data': {...keys.metadata, 'token': _token},
          };
        }
      case 'DELETE':
        keys.revoked++;
        keys.exists = false;
        status = 204;
    }
    return http.StreamedResponse(
      Stream.value(body == null ? <int>[] : utf8.encode(jsonEncode(body))),
      status,
      headers: {'content-type': 'application/json'},
    );
  }

  @override
  void close() => inner.close();
}

/// The fake, watched: what an edit sent and was answered, and on request a
/// list answer held back or a refusal the fake cannot reach by itself.
class _Wire extends http.BaseClient {
  _Wire(this.inner);
  final http.Client inner;
  final patches = <Map<String, dynamic>>[];
  final answers = <String>[];
  Completer<void>? holdList;
  bool failList = false;
  String? refusal;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!request.url.path.contains('/api-keys')) return inner.send(request);
    if (request.method == 'PATCH') {
      final raw = await request.finalize().toBytes();
      patches.add(jsonDecode(utf8.decode(raw)) as Map<String, dynamic>);
      final code = refusal;
      if (code != null) {
        return http.StreamedResponse(
          Stream.value(
            utf8.encode(
              jsonEncode({
                'error': {'code': code, 'message': 'Refused'},
              }),
            ),
          ),
          403,
          headers: {'content-type': 'application/json'},
        );
      }
      final forwarded = http.Request('PATCH', request.url)
        ..headers.addAll(request.headers)
        ..bodyBytes = raw;
      final answer = await inner.send(forwarded);
      final bytes = await answer.stream.toBytes();
      answers.add(utf8.decode(bytes));
      return http.StreamedResponse(
        Stream.value(bytes),
        answer.statusCode,
        headers: answer.headers,
      );
    }
    if (request.method == 'GET' && failList) {
      return http.StreamedResponse(
        Stream.value(
          utf8.encode(
            jsonEncode({
              'error': {'code': 'unavailable', 'message': 'List is down'},
            }),
          ),
        ),
        503,
        headers: {'content-type': 'application/json'},
      );
    }
    final answer = await inner.send(request);
    // Read now, so a held answer is what the server said when it was asked.
    final bytes = await answer.stream.toBytes();
    final hold = holdList;
    if (request.method == 'GET' && hold != null) {
      holdList = null;
      await hold.future;
    }
    return http.StreamedResponse(
      Stream.value(bytes),
      answer.statusCode,
      headers: answer.headers,
    );
  }

  @override
  void close() => inner.close();
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState, MemoryKeyValueStore)> open(
    WidgetTester tester,
    _Keys keys,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final store = MemoryKeyValueStore();
    final state = AppState(
      store: store,
      httpClientFactory: () => _KeyClient(fake.client, keys),
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state, store);
  }

  Future<void> reveal(WidgetTester tester, Finder target) async {
    for (final delta in [-250.0, 250.0]) {
      for (var i = 0; i < 25 && target.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(ListView).last, Offset(0, delta));
        await tester.pumpAndSettle();
      }
    }
    expect(target, findsWidgets);
    await tester.ensureVisible(target.last);
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder target) async {
    await reveal(tester, target);
    await tester.tap(target.last);
    await tester.pumpAndSettle();
  }

  Future<void> text(WidgetTester tester, String value) =>
      tap(tester, find.text(value));

  Finder field(String label) => find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.labelText == label,
  );

  Future<void> createForm(WidgetTester tester) async {
    await tap(tester, find.byTooltip('Mailboxes'));
    await tap(tester, find.byTooltip('Mailbox settings'));
    await text(tester, FakeAccounts.adminEmail);
    await text(tester, 'API keys');
    await text(tester, 'Create an API key');
    await tester.enterText(field('Name'), 'Provisioning');
    await tester.enterText(
      field('Current password'),
      FakeAccounts.adminPassword,
    );
    await tester.pump();
  }

  Future<void> close(
    WidgetTester tester,
    FakeRestmail fake,
    AppState state,
  ) async {
    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  }

  testWidgets('create a scoped key, copy it once, then list and revoke it', (
    tester,
  ) async {
    final keys = _Keys();
    final (fake, state, store) = await open(tester, keys);
    final copies = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SecretClipboard.channel,
      (call) async {
        copies.add(call);
        return true;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SecretClipboard.channel,
        null,
      ),
    );

    await createForm(tester);
    await text(tester, 'Create API key');
    expect(keys.request, {
      'name': 'Provisioning',
      'password': FakeAccounts.adminPassword,
      'permissions': [
        {
          'capability': 'mail:read',
          'scope': 'mailbox:${FakeAccounts.adminEmail}',
        },
      ],
    });
    expect(find.text('API key created'), findsOneWidget);
    expect(
      tester.widget<SelectableText>(find.byType(SelectableText)).data,
      _token,
    );
    await text(tester, 'Copy API key');
    expect((copies.single.arguments as Map<Object?, Object?>)['text'], _token);
    expect(store.values.values.any((value) => value.contains(_token)), isFalse);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.byType(SelectableText), findsNothing);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.byType(SelectableText), findsOneWidget);

    await text(tester, 'Done');
    expect(find.text('Provisioning'), findsOneWidget);
    expect(find.byType(SelectableText), findsNothing);
    await text(tester, 'Revoke');
    await text(tester, 'Cancel');
    expect(keys.revoked, 0);
    await text(tester, 'Revoke');
    await text(tester, 'Revoke');
    expect(keys.revoked, 1);
    expect(find.text('No API keys yet.'), findsOneWidget);
    expect((state.current! as RestAccount).client.tokens, isNotNull);
    await close(tester, fake, state);
  });

  for (final code in [
    'two_factor_required',
    'invalid_password',
    'validation_failed',
    'http_404',
  ]) {
    testWidgets('$code keeps the form and signed-in session', (tester) async {
      final keys = _Keys()..refusal = code;
      final (fake, state, _) = await open(tester, keys);
      await createForm(tester);
      await text(tester, 'Create API key');
      expect(find.text('New API key'), findsOneWidget);
      expect(
        tester.widget<TextField>(field('Current password')).controller!.text,
        isEmpty,
      );
      expect((state.current! as RestAccount).client.tokens, isNotNull);
      if (code == 'two_factor_required') {
        await reveal(tester, find.text('Sign in with a code'));
        expect(find.text('Sign in with a code'), findsOneWidget);
      } else if (code == 'validation_failed') {
        expect(find.text('permissions: scope invalid'), findsOneWidget);
      } else if (code == 'http_404') {
        expect(
          find.text(
            'API keys are not available for this mailbox on this server.',
          ),
          findsOneWidget,
        );
      } else {
        expect(
          find.textContaining('current password of the account'),
          findsOneWidget,
        );
      }
      await close(tester, fake, state);
    });
  }

  group('changing a key', () {
    const mailRead = 'mail:read';
    final mailboxScope = 'mailbox:${FakeAccounts.adminEmail}';
    final domainScope = 'domain:${FakeAccounts.host}';

    /// Signed in, on the API keys screen, with [permissions] on one key.
    Future<(FakeRestmail, AppState, _Wire, RestAccount, Account, APIKey)>
    openKeys(
      WidgetTester tester, {
      List<APIKeyPermission>? permissions,
      void Function(FakeRestmail fake)? prepare,
      String email = FakeAccounts.adminEmail,
    }) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final fake = FakeRestmail();
      prepare?.call(fake);
      final wire = _Wire(fake.client);
      final state = AppState(
        store: MemoryKeyValueStore(),
        httpClientFactory: () => wire,
      );
      await state.start();
      await state.signIn(
        server: Uri.parse('https://${FakeAccounts.host}'),
        email: email,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );
      final account = state.current! as RestAccount;
      final mailbox = (await account.client.accounts()).first;
      final made = await account.client.createAPIKey(
        mailbox.id,
        name: 'Provisioning',
        password: FakeAccounts.adminPassword,
        permissions:
            permissions ??
            [APIKeyPermission(capability: mailRead, scope: mailboxScope)],
      );
      await tester.pumpWidget(RestmailApp(state: state));
      await tester.pumpAndSettle();
      await tap(tester, find.byTooltip('Mailboxes'));
      await tap(tester, find.byTooltip('Mailbox settings'));
      await text(tester, email);
      await text(tester, 'API keys');
      return (fake, state, wire, account, mailbox, made.key);
    }

    Future<void> password(WidgetTester tester, String value) async {
      await reveal(tester, field('Current password'));
      await tester.enterText(field('Current password'), value);
      await tester.pump();
    }

    bool saveEnabled(WidgetTester tester) =>
        tester
            .widget<RmPrimaryButton>(
              find.widgetWithText(RmPrimaryButton, 'Save'),
            )
            .onPressed !=
        null;

    testWidgets('open a key, see its permissions, change them, and the list '
        'shows what the server stored', (tester) async {
      final (fake, state, wire, _, _, made) = await openKeys(
        tester,
        permissions: [
          APIKeyPermission(capability: mailRead, scope: mailboxScope),
          APIKeyPermission(capability: 'mail:send', scope: domainScope),
          // Not one the form offers: a key can still hold it, and keep it.
          const APIKeyPermission(capability: 'messages:send_bulk', scope: '*'),
        ],
      );

      await text(tester, 'Edit');
      expect(find.text('Permissions of “Provisioning”'), findsOneWidget);
      expect(find.text('Owner: ${FakeAccounts.adminEmail}'), findsOneWidget);
      expect(find.textContaining('name and expiry stay'), findsOneWidget);
      await reveal(tester, find.text('messages:send_bulk'));
      await reveal(tester, find.text(mailRead));
      await reveal(tester, field('Mailbox address'));
      expect(
        tester.widget<TextField>(field('Mailbox address')).controller!.text,
        FakeAccounts.adminEmail,
      );
      await reveal(tester, find.text('mail:send'));
      await reveal(tester, field('Domain name'));
      expect(
        tester.widget<TextField>(field('Domain name')).controller!.text,
        FakeAccounts.host,
      );
      // Nothing on this form holds or asks for the secret.
      expect(find.byType(SelectableText), findsNothing);

      // The new row starts as the first one, so the server stores one of them.
      await text(tester, 'Add permission');
      await password(tester, FakeAccounts.adminPassword);
      await text(tester, 'Save');

      expect(wire.patches.single, {
        'password': FakeAccounts.adminPassword,
        'permissions': [
          {'capability': mailRead, 'scope': mailboxScope},
          {'capability': 'mail:send', 'scope': domainScope},
          {'capability': 'messages:send_bulk', 'scope': '*'},
          {'capability': mailRead, 'scope': mailboxScope},
        ],
      });
      expect(wire.answers.single, isNot(contains('token')));
      expect(wire.answers.single, isNot(contains('secret')));
      expect(find.text('API keys'), findsOneWidget);
      expect(
        find.text(
          'Saved the permissions of “Provisioning”. Its secret has not '
          'changed.',
        ),
        findsOneWidget,
      );
      final row = tester.widget<RmRow>(find.byType(RmRow));
      expect(row.label, made.name);
      expect(row.subtitle, contains('ID ${made.publicId}'));
      expect(row.subtitle, contains('$mailRead · $mailboxScope'));
      expect(row.subtitle, contains('mail:send · $domainScope'));
      expect(row.subtitle, contains('messages:send_bulk · *'));
      expect('$mailRead · '.allMatches(row.subtitle!), hasLength(1));
      await close(tester, fake, state);
    });

    testWidgets('a scope the form does not know is never shown as everywhere', (
      tester,
    ) async {
      final keys = _Keys()
        ..exists = true
        ..scope = 'team:ops';
      final (fake, state, _) = await open(tester, keys);
      await tap(tester, find.byTooltip('Mailboxes'));
      await tap(tester, find.byTooltip('Mailbox settings'));
      await text(tester, FakeAccounts.adminEmail);
      await text(tester, 'API keys');
      await text(tester, 'Edit');
      await reveal(tester, field('Mailbox address'));
      expect(
        tester.widget<TextField>(field('Mailbox address')).controller!.text,
        'team:ops',
      );
      expect(find.text('Everywhere'), findsNothing);
      await close(tester, fake, state);
    });

    for (final (language, edit, save) in [
      ('de', 'Bearbeiten', 'Speichern'),
      ('ar', null, null),
    ]) {
      testWidgets('the list and the form fit a small phone in $language', (
        tester,
      ) async {
        final (fake, state, _, _, _, _) = await openKeys(tester);
        await state.updateSettings(
          state.settings.copyWith(languageCode: language),
        );
        tester.view.physicalSize = const Size(960, 1704);
        await tester.pumpAndSettle();
        final buttons = find.descendant(
          of: find.byType(RmRow),
          matching: find.byType(TextButton),
        );
        expect(buttons, findsNWidgets(2));
        if (edit != null) expect(find.text(edit), findsOneWidget);
        await tester.ensureVisible(buttons.first);
        await tester.pumpAndSettle();
        await tester.tap(buttons.first);
        await tester.pumpAndSettle();
        expect(find.byType(EditAPIKeyScreen), findsOneWidget);
        await reveal(tester, find.byType(RmPrimaryButton));
        if (save != null) expect(find.text(save), findsOneWidget);
        await close(tester, fake, state);
      });
    }

    testWidgets('a permission can be removed, down to the last one', (
      tester,
    ) async {
      final (fake, state, wire, _, _, _) = await openKeys(
        tester,
        permissions: [
          APIKeyPermission(capability: mailRead, scope: mailboxScope),
          APIKeyPermission(capability: 'mail:send', scope: domainScope),
        ],
      );
      await text(tester, 'Edit');
      await text(tester, 'Remove permission');
      expect(find.text('Remove permission'), findsNothing);
      await password(tester, FakeAccounts.adminPassword);
      await text(tester, 'Save');

      expect(wire.patches.single['permissions'], hasLength(1));
      final row = tester.widget<RmRow>(find.byType(RmRow));
      expect('·'.allMatches(row.subtitle!), hasLength(1));
      await close(tester, fake, state);
    });

    testWidgets('Save waits for the password; leaving saves nothing', (
      tester,
    ) async {
      final (fake, state, wire, _, _, _) = await openKeys(tester);
      await text(tester, 'Edit');
      await reveal(tester, find.text('Save'));
      expect(saveEnabled(tester), isFalse);
      await password(tester, FakeAccounts.adminPassword);
      expect(saveEnabled(tester), isTrue);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('API keys'), findsOneWidget);
      expect(wire.patches, isEmpty);
      expect(find.textContaining('Saved the permissions'), findsNothing);
      await close(tester, fake, state);
    });

    testWidgets('a wrong password is its own message and empties the field', (
      tester,
    ) async {
      final (fake, state, wire, account, mailbox, _) = await openKeys(tester);
      await text(tester, 'Edit');
      await password(tester, 'not it');
      await text(tester, 'Save');

      await reveal(tester, find.textContaining('not your current password'));
      expect(
        find.text(
          'That is not your current password. Enter the password you sign in '
          'with, not the key owner\'s.',
        ),
        findsOneWidget,
      );
      expect(find.text('Sign in again'), findsNothing);
      expect(
        tester.widget<TextField>(field('Current password')).controller!.text,
        isEmpty,
      );
      expect(find.text('Permissions of “Provisioning”'), findsOneWidget);
      expect(account.client.tokens, isNotNull);
      expect((await account.client.apiKeys(mailbox.id)).single.permissions, [
        APIKeyPermission(capability: mailRead, scope: mailboxScope),
      ]);
      expect(wire.patches, hasLength(1));
      await close(tester, fake, state);
    });

    testWidgets('a stale two-factor session is explained and offers a new '
        'sign-in, and the session stays', (tester) async {
      final (fake, state, _, account, _, _) = await openKeys(tester);
      await text(tester, 'Edit');
      fake.ageTwoFactorProofs();
      await password(tester, FakeAccounts.adminPassword);
      await text(tester, 'Save');

      await reveal(tester, find.textContaining('no longer recent enough'));
      expect(
        find.text(
          'Your two-factor sign-in is no longer recent enough for this change. '
          'Sign in again with your code, then make the change again.',
        ),
        findsOneWidget,
      );
      expect(account.client.tokens, isNotNull);
      await text(tester, 'Sign in again');
      expect(find.byType(AddAccountScreen), findsOneWidget);
      expect(find.text(FakeAccounts.adminEmail), findsWidgets);

      // A new sign-in is a new proof. It lands on the mailbox, as any sign-in
      // does, so the unsaved edit is gone and the change is made again.
      final passwordField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.obscureText,
      );
      await tester.enterText(passwordField, FakeAccounts.adminPassword);
      await tester.pump();
      await text(tester, 'Continue');
      await tester.enterText(
        find.byType(TextField).last,
        FakeAccounts.totpCode,
      );
      await tester.pump();
      await text(tester, 'Continue');
      expect(find.byType(AddAccountScreen), findsNothing);
      expect(find.byType(EditAPIKeyScreen), findsNothing);

      await tap(tester, find.byTooltip('Mailboxes'));
      await tap(tester, find.byTooltip('Mailbox settings'));
      await text(tester, FakeAccounts.adminEmail);
      await text(tester, 'API keys');
      await text(tester, 'Edit');
      await password(tester, FakeAccounts.adminPassword);
      await text(tester, 'Save');
      expect(find.textContaining('Saved the permissions'), findsOneWidget);
      await close(tester, fake, state);
    });

    testWidgets('a session without a second factor is explained the same way', (
      tester,
    ) async {
      final (fake, state, wire, _, _, _) = await openKeys(tester);
      wire.refusal = 'two_factor_required';
      await text(tester, 'Edit');
      await password(tester, FakeAccounts.adminPassword);
      await text(tester, 'Save');

      await reveal(tester, find.textContaining('This change needs a session'));
      expect(
        find.text(
          'This change needs a session signed in with two-factor '
          'authentication. Sign in again with your code, then make the change '
          'again.',
        ),
        findsOneWidget,
      );
      await reveal(tester, find.text('Sign in again'));
      await close(tester, fake, state);
    });

    testWidgets('a missing password from the server has its own wording', (
      tester,
    ) async {
      final (fake, state, wire, _, _, _) = await openKeys(tester);
      wire.refusal = 'reauth_required';
      await text(tester, 'Edit');
      await password(tester, FakeAccounts.adminPassword);
      await text(tester, 'Save');
      await reveal(
        tester,
        find.text(
          "Enter your current password to change this key's permissions.",
        ),
      );
      expect(find.text('Sign in again'), findsNothing);
      await close(tester, fake, state);
    });

    testWidgets('permissions over the ceiling show the server\'s message, and '
        'the form explains the ceiling', (tester) async {
      final watcher = 'watcher@${FakeAccounts.host}';
      final (fake, state, _, account, mailbox, _) = await openKeys(
        tester,
        email: watcher,
        prepare: (fake) =>
            fake.addAccount(watcher, capabilities: {'queue:read'}),
        permissions: [
          const APIKeyPermission(capability: 'queue:read', scope: '*'),
        ],
      );
      await text(tester, 'Edit');
      await reveal(
        tester,
        find.textContaining('hold only what both you and its owner'),
      );
      await tap(tester, find.text('queue:read'));
      await tester.tap(find.text('queue:manage').last);
      await tester.pumpAndSettle();
      await password(tester, FakeAccounts.adminPassword);
      await text(tester, 'Save');

      await reveal(
        tester,
        find.text(
          "API key permissions must be within the account's and your current "
          'grants',
        ),
      );
      expect(find.text('Sign in again'), findsNothing);
      expect((await account.client.apiKeys(mailbox.id)).single.permissions, [
        const APIKeyPermission(capability: 'queue:read', scope: '*'),
      ]);
      await close(tester, fake, state);
    });

    testWidgets('a scope the server will not take shows its reason', (
      tester,
    ) async {
      final (fake, state, _, _, _, _) = await openKeys(tester);
      await text(tester, 'Edit');
      await reveal(tester, field('Mailbox address'));
      await tester.enterText(field('Mailbox address'), 'nobody');
      await password(tester, FakeAccounts.adminPassword);
      await text(tester, 'Save');
      await reveal(
        tester,
        find.text(
          'permissions: each permission needs a named capability and a valid '
          'scope',
        ),
      );
      await close(tester, fake, state);
    });

    testWidgets('a key gone meanwhile says nothing changed, and leaves the '
        'list without it', (tester) async {
      final (fake, state, _, account, mailbox, made) = await openKeys(tester);
      await text(tester, 'Edit');
      await account.client.revokeAPIKey(mailbox.id, made.id);
      await password(tester, FakeAccounts.adminPassword);
      await text(tester, 'Save');

      await reveal(
        tester,
        find.text(
          'This API key no longer exists, or you may not manage its account. '
          'Nothing was changed.',
        ),
      );
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('No API keys yet.'), findsOneWidget);
      await close(tester, fake, state);
    });

    testWidgets('a throttled save shows the server\'s message', (tester) async {
      final (fake, state, _, _, _, _) = await openKeys(tester);
      await text(tester, 'Edit');
      fake.throttleSignIns(const Duration(minutes: 1));
      await password(tester, FakeAccounts.adminPassword);
      await text(tester, 'Save');
      await reveal(tester, find.text('Too many requests; please slow down'));
      await close(tester, fake, state);
    });

    testWidgets('a list that fails to reload after a save still shows what '
        'was stored', (tester) async {
      final (fake, state, wire, _, _, _) = await openKeys(tester);
      await text(tester, 'Edit');
      await reveal(tester, field('Mailbox address'));
      await tester.enterText(
        field('Mailbox address'),
        FakeAccounts.adminEmail.toUpperCase(),
      );
      await tap(tester, find.text(mailRead));
      await tester.tap(find.text('mail:send').last);
      await tester.pumpAndSettle();
      await password(tester, FakeAccounts.adminPassword);
      wire.failList = true;
      await text(tester, 'Save');

      expect(find.text('List is down'), findsOneWidget);
      final row = tester.widget<RmRow>(find.byType(RmRow));
      expect(row.subtitle, contains('mail:send · $mailboxScope'));
      expect(row.subtitle, isNot(contains('$mailRead · ')));
      await close(tester, fake, state);
    });

    testWidgets('an answer asked for before a save does not put the old '
        'permissions back', (tester) async {
      final (fake, state, wire, _, _, _) = await openKeys(tester);
      // Leaving the form reads the list again; this answer is kept waiting.
      await text(tester, 'Edit');
      final held = wire.holdList = Completer<void>();
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      await text(tester, 'Edit');
      await tap(tester, find.text(mailRead));
      await tester.tap(find.text('mail:send').last);
      await tester.pumpAndSettle();
      await password(tester, FakeAccounts.adminPassword);
      await text(tester, 'Save');

      held.complete();
      await tester.pumpAndSettle();
      final row = tester.widget<RmRow>(find.byType(RmRow));
      expect(row.subtitle, contains('mail:send · $mailboxScope'));
      expect(row.subtitle, isNot(contains('$mailRead · ')));
      await close(tester, fake, state);
    });
  });
}
