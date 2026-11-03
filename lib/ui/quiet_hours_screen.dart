import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../state/quiet_hours_state.dart';
import 'widgets/common.dart';

class QuietHoursScreen extends StatefulWidget {
  const QuietHoursScreen({
    super.key,
    required this.client,
    required this.accountId,
  });

  final RestmailClient client;
  final int accountId;

  @override
  State<QuietHoursScreen> createState() => _QuietHoursScreenState();
}

class _QuietHoursScreenState extends State<QuietHoursScreen> {
  late final _state = QuietHoursState(
    client: widget.client,
    accountId: widget.accountId,
  );
  final _start = TextEditingController();
  final _end = TextEditingController();
  final _zone = TextEditingController();

  @override
  void initState() {
    super.initState();
    _state.addListener(_changed);
    unawaited(_state.load());
  }

  void _changed() {
    final setting = _state.setting;
    if (setting != null) {
      for (final (controller, value) in [
        (_start, setting.start),
        (_end, setting.end),
        (_zone, setting.timeZone),
      ]) {
        if (controller.text != value) controller.text = value;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _state.dispose();
    _start.dispose();
    _end.dispose();
    _zone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setting = _state.setting;
    final error = _state.error;
    final fields = error?.fields ?? const <String, String>{};
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'quietHours.title'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  Text(tr(context, 'quietHours.help')),
                  const SizedBox(height: 18),
                  RmGroup(
                    children: [
                      RmRow(
                        label: tr(context, 'quietHours.toggle'),
                        trailing: RmSwitch(
                          label: tr(context, 'quietHours.toggle'),
                          value: setting?.enabled ?? false,
                          onChanged: _state.editable
                              ? (enabled) => _state.edit(
                                  setting!.copyWith(enabled: enabled),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  if (fields['enabled'] case final message?) ErrorText(message),
                  const SizedBox(height: 18),
                  for (final (field, label, controller) in [
                    ('start', 'quietHours.start', _start),
                    ('end', 'quietHours.end', _end),
                    ('time_zone', 'quietHours.timeZone', _zone),
                  ]) ...[
                    TextField(
                      key: ValueKey('quietHours.$field'),
                      controller: controller,
                      enabled: _state.editable,
                      autocorrect: false,
                      keyboardType: field == 'time_zone'
                          ? TextInputType.text
                          : TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: tr(context, label),
                        errorText: fields[field],
                      ),
                      onChanged: (value) => _state.edit(switch (field) {
                        'start' => setting!.copyWith(start: value),
                        'end' => setting!.copyWith(end: value),
                        _ => setting!.copyWith(timeZone: value),
                      }),
                    ),
                    const SizedBox(height: 18),
                  ],
                  Text(tr(context, 'quietHours.scheduleHelp')),
                  const SizedBox(height: 22),
                  RmPrimaryButton(
                    label: tr(context, 'quietHours.save'),
                    onPressed: _state.editable
                        ? () => unawaited(_state.save())
                        : null,
                    busy: _state.saving,
                  ),
                  if (_state.loading || _state.saving || _state.saved) ...[
                    const SizedBox(height: 12),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        tr(
                          context,
                          _state.loading
                              ? 'quietHours.loading'
                              : _state.saving
                              ? 'quietHours.saving'
                              : 'quietHours.saved',
                        ),
                      ),
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    ErrorText(
                      tr(
                        context,
                        setting == null
                            ? 'quietHours.loadFailed'
                            : 'quietHours.saveFailed',
                      ),
                    ),
                    ErrorText(
                      describeError(
                        context,
                        error,
                        host: widget.client.server.host,
                      ),
                    ),
                    if (setting == null)
                      TextButton(
                        onPressed: () => unawaited(_state.load()),
                        child: Text(tr(context, 'quietHours.retry')),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
