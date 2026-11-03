class QuietHoursSetting {
  const QuietHoursSetting({
    this.enabled = false,
    this.start = '',
    this.end = '',
    this.timeZone = '',
  });

  final bool enabled;
  final String start;
  final String end;
  final String timeZone;

  QuietHoursSetting copyWith({
    bool? enabled,
    String? start,
    String? end,
    String? timeZone,
  }) => QuietHoursSetting(
    enabled: enabled ?? this.enabled,
    start: start ?? this.start,
    end: end ?? this.end,
    timeZone: timeZone ?? this.timeZone,
  );
}
