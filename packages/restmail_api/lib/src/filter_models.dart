/// Preview responses retain the complete JSON, including canonical email
/// envelopes, MIME bodies, attachments, calendars and future filter metadata.
/// The common decisions are also exposed as typed properties.
class PipelineTestResult {
  PipelineTestResult.fromJson(Map<String, dynamic> json)
    : json = Map.unmodifiable(json),
      finalAction = json['final_action'] as String? ?? '',
      rejectMessage = json['reject_message'] as String? ?? '',
      finalEmail = json['final_email'] as Map<String, dynamic>?,
      steps = [
        for (final step in json['steps'] as List<dynamic>? ?? const [])
          PipelineTestStep.fromJson(step as Map<String, dynamic>),
      ],
      authResults = [
        for (final value in json['auth_results'] as List<dynamic>? ?? const [])
          value as Map<String, dynamic>,
      ],
      durationMs = (json['duration_ms'] as num?)?.toInt() ?? 0;

  final Map<String, dynamic> json;
  final String finalAction;
  final String rejectMessage;
  final Map<String, dynamic>? finalEmail;
  final List<PipelineTestStep> steps;
  final List<Map<String, dynamic>> authResults;

  /// How long the whole run took, in whole milliseconds.
  final int durationMs;
}

class PipelineTestStep {
  PipelineTestStep.fromJson(Map<String, dynamic> json)
    : json = Map.unmodifiable(json),
      filterName = json['filter_name'] as String? ?? '',
      filterType = json['filter_type'] as String? ?? '',
      action = json['action'] as String? ?? '',
      skipped = json['skipped'] as bool? ?? false,
      skipReason = json['skip_reason'] as String? ?? '',
      error = json['error'] as String? ?? '',
      log = json['log'] as Map<String, dynamic>? ?? const {},
      durationMs = (json['duration_ms'] as num?)?.toInt() ?? 0;

  final Map<String, dynamic> json;
  final String filterName;
  final String filterType;
  final String action;
  final bool skipped;
  final String skipReason;
  final String error;
  final Map<String, dynamic> log;

  /// How long the step took, in whole milliseconds.
  final int durationMs;
}

class FilterTestResult {
  FilterTestResult.fromJson(Map<String, dynamic> json)
    : json = Map.unmodifiable(json),
      type = json['type'] as String? ?? '',
      action = json['action'] as String? ?? '',
      message = json['message'] as Map<String, dynamic>?,
      skipFilters = (json['skip_filters'] as List<dynamic>? ?? const [])
          .cast<String>(),
      rejectMessage = json['reject_message'] as String? ?? '',
      log = json['log'] as Map<String, dynamic>? ?? const {};

  final Map<String, dynamic> json;
  final String type;
  final String action;
  final Map<String, dynamic>? message;
  final List<String> skipFilters;
  final String rejectMessage;
  final Map<String, dynamic> log;
}

/// The script can return any JSON value, not just a filter verdict.
class ScriptTestResult {
  ScriptTestResult.fromJson(Map<String, dynamic> json)
    : json = Map.unmodifiable(json),
      result = json['result'],
      error = json['error'] as String?,
      logs = (json['logs'] as List<dynamic>? ?? const []).cast<String>();

  final Map<String, dynamic> json;
  final Object? result;
  final String? error;
  final List<String> logs;
}

/// Syntax can be valid while an optional dry run fails during execution.
class FilterValidation {
  FilterValidation.fromJson(Map<String, dynamic> json)
    : json = Map.unmodifiable(json),
      valid = json['valid'] as bool? ?? false,
      error = json['error'] as String?,
      phase = json['phase'] as String?,
      dryRun = json['dry_run'] is Map<String, dynamic>
          ? ScriptTestResult.fromJson(json['dry_run'] as Map<String, dynamic>)
          : null;

  final Map<String, dynamic> json;
  final bool valid;
  final String? error;
  final String? phase;
  final ScriptTestResult? dryRun;
}
