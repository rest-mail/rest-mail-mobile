import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../widgets/common.dart';
import 'admin_widgets.dart';

/// Named server filters, kept separate from each list's paging position.
class ReportField {
  const ReportField(
    this.key,
    this.label, {
    this.choices,
    this.number = false,
    this.date = false,
    this.positive = false,
    this.max,
    this.hint,
    this.validate,
  });
  final String key;
  final String label;
  final List<(String, String)>? choices;
  final bool number;
  final bool date;
  final bool positive;
  final int? max;
  final String? hint;
  final String? Function(String)? validate;
}

const reportPageSize = ReportField(
  'limit',
  'Page size',
  number: true,
  positive: true,
  max: 200,
  hint: '50 (up to 200)',
);
const reportSince = ReportField('since', 'From', date: true);
const reportUntil = ReportField('until', 'Through', date: true);

DateTime? reportDate(Map<String, String> values, String key) =>
    DateTime.tryParse(values[key] ?? '');
int? reportInt(Map<String, String> values, String key) =>
    int.tryParse(values[key] ?? '');

/// Filters remain visible, can be cleared together, and apply from page one.
class ReportFiltersBar extends StatelessWidget {
  const ReportFiltersBar({
    super.key,
    required this.host,
    required this.fields,
    required this.values,
    required this.onChanged,
    this.title = 'Filters',
    this.intro,
  });
  final String host;
  final String title;
  final String? intro;
  final List<ReportField> fields;
  final Map<String, String> values;
  final ValueChanged<Map<String, String>> onChanged;

  Future<void> _open(BuildContext context) async {
    Map<String, String>? next;
    final saved = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: title,
        host: host,
        action: 'Apply filters',
        intro:
            intro ??
            'Leave a field empty to include everything. Times include a timezone, '
                'for example 2026-10-23T07:00:00+01:00.',
        fields: [
          for (final f in fields)
            AdminField(
              f.label,
              initial: values[f.key] ?? '',
              optional: true,
              choices: f.choices,
              number: f.number,
              hint: f.date ? '2026-10-23T06:00:00Z' : f.hint,
            ),
        ],
        submit: (input) async {
          final invalid = <String, String>{};
          final result = <String, String>{};
          for (var i = 0; i < fields.length; i++) {
            final f = fields[i], value = input[i];
            if (value.isEmpty) continue;
            result[f.key] = value;
            if (f.number) {
              final number = int.tryParse(value);
              if (number == null ||
                  number < (f.positive ? 1 : 0) ||
                  (f.max != null && number > f.max!)) {
                invalid[f.key] = f.max == null
                    ? 'must be a ${f.positive ? 'positive' : 'non-negative'} whole number'
                    : 'must be between ${f.positive ? 1 : 0} and ${f.max}';
              }
            }
            if (f.date && !_validReportTime(value)) {
              invalid[f.key] = 'must be a date and time with a timezone';
            }
            if (f.validate?.call(value) case final error?) {
              invalid[f.key] = error;
            }
          }
          final since = reportDate(result, 'since'),
              until = reportDate(result, 'until');
          if (since != null && until != null && since.isAfter(until)) {
            invalid['until'] = 'must not be before From';
          }
          if (invalid.isNotEmpty) {
            throw ApiException(
              422,
              'validation_failed',
              'Check the filters',
              fields: invalid,
            );
          }
          next = result;
        },
      ),
    );
    if (context.mounted && saved && next != null) onChanged(next!);
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          RmOutlineButton(
            label: values.isEmpty ? title : '$title (${values.length})',
            onPressed: () => unawaited(_open(context)),
          ),
          if (values.isNotEmpty)
            RmOutlineButton(
              label: 'Clear filters',
              onPressed: () => onChanged({}),
            ),
        ],
      ),
      if (values.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            [
              for (final f in fields)
                if (values[f.key] case final value?)
                  '${f.label}: ${f.choices?.where((c) => c.$1 == value).firstOrNull?.$2 ?? value}',
            ].join(' · '),
          ),
        ),
      const SizedBox(height: 14),
    ],
  );
}

/// Go time.ParseDuration syntax, including compound and subsecond durations.
String? positiveGoDuration(String value) {
  final text = value.startsWith('+') ? value.substring(1) : value;
  final parts = RegExp(r'(\d+(?:\.\d*)?|\.\d+)(ns|us|µs|μs|ms|s|m|h)')
      .allMatches(text);
  if (parts.map((p) => p[0]).join() != text) {
    return 'must be a duration such as 90m or 1h30m';
  }
  const units = {
    'ns': 1.0,
    'us': 1000.0,
    'µs': 1000.0,
    'μs': 1000.0,
    'ms': 1000000.0,
    's': 1000000000.0,
    'm': 60000000000.0,
    'h': 3600000000000.0,
  };
  final nanos = parts.fold<double>(
    0,
    (n, p) => n + double.parse(p[1]!) * units[p[2]]!,
  );
  return nanos >= 1 && nanos < 9223372036854775808.0
      ? null
      : 'must be positive and fit within the server duration range';
}

// DateTime.parse otherwise normalizes dates such as February 31 into March.
bool _validReportTime(String value) {
  final match = RegExp(
    r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-](\d{2}):(\d{2}))$',
  ).firstMatch(value);
  if (match == null || DateTime.tryParse(value) == null) return false;
  if (match[1] != null &&
      (int.parse(match[1]!) > 23 || int.parse(match[2]!) > 59)) {
    return false;
  }
  final wall = DateTime.tryParse('${value.substring(0, 19)}Z');
  return wall != null &&
      wall.toIso8601String().startsWith(value.substring(0, 19));
}
