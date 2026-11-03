import 'package:restmail_generated/restmail_generated.dart' as wire;

/// An aggregate DMARC report another server sent to one of this server's
/// domains, as the server stored it from the mail that carried it. Dates are
/// in UTC, as the reporter's date range is.
class DmarcReport {
  const DmarcReport({
    required this.id,
    required this.domainId,
    required this.reporter,
    required this.reportingOrg,
    required this.reportId,
    required this.startDate,
    required this.endDate,
    required this.policy,
    required this.records,
    required this.receivedAt,
  });

  /// UI projection of the generated, already validated wire model.
  factory DmarcReport.fromWire(wire.DmarcReport value) => DmarcReport(
    id: value.id,
    domainId: value.domainId,
    reporter: value.reporter,
    reportingOrg: value.reportingOrg,
    reportId: value.reportId,
    startDate: value.startDate.toUtc(),
    endDate: value.endDate.toUtc(),
    policy: DmarcPolicy.fromWire(value.policyPublished),
    records: value.records.map(DmarcRecord.fromWire).toList(),
    receivedAt: value.receivedAt.toUtc(),
  );

  final int id;
  final int domainId;

  /// The domain the report's mail authenticated for.
  final String reporter;

  /// Who says they sent it: `Google Inc.` and the like.
  final String reportingOrg;

  /// The reporter's own number for the report.
  final String reportId;
  final DateTime startDate;
  final DateTime endDate;
  final DmarcPolicy policy;
  final List<DmarcRecord> records;
  final DateTime receivedAt;

  /// How many messages the reporter says passed DMARC.
  int get passed => records
      .where((record) => record.passed)
      .fold(0, (sum, record) => sum + record.count);

  /// How many messages the reporter says failed DMARC.
  int get failed => records
      .where((record) => !record.passed)
      .fold(0, (sum, record) => sum + record.count);
}

/// The DMARC record the reporter found published for the domain. What the
/// reporter left out stays null.
class DmarcPolicy {
  const DmarcPolicy({
    required this.domain,
    required this.policy,
    this.subdomainPolicy,
    this.nonexistentDomainPolicy,
    this.dkimAlignment,
    this.spfAlignment,
    this.percentage,
    this.failureOptions,
    this.testing,
    this.discoveryMethod,
  });

  factory DmarcPolicy.fromWire(wire.DmarcReceivedPolicy value) => DmarcPolicy(
    domain: value.domain,
    policy: value.p.toJson(),
    subdomainPolicy: value.sp,
    nonexistentDomainPolicy: value.np,
    dkimAlignment: value.adkim,
    spfAlignment: value.aspf,
    percentage: value.pct,
    failureOptions: value.fo,
    testing: value.testing,
    discoveryMethod: value.discoveryMethod,
  );

  final String domain;

  /// `none`, `quarantine` or `reject`.
  final String policy;
  final String? subdomainPolicy;
  final String? nonexistentDomainPolicy;
  final String? dkimAlignment;
  final String? spfAlignment;
  final int? percentage;
  final String? failureOptions;
  final String? testing;
  final String? discoveryMethod;
}

/// One row of a report: how many messages came from one source with one
/// outcome.
class DmarcRecord {
  const DmarcRecord({
    required this.sourceIp,
    required this.count,
    required this.disposition,
    required this.dkim,
    required this.spf,
    required this.headerFrom,
    this.envelopeFrom,
    this.envelopeTo,
    this.reasons = const [],
    this.dkimResults = const [],
    this.spfResults = const [],
  });

  factory DmarcRecord.fromWire(wire.DmarcReceivedRecord value) => DmarcRecord(
    sourceIp: value.row.sourceIp,
    count: value.row.count,
    disposition: value.row.policyEvaluated.disposition.toJson(),
    dkim: value.row.policyEvaluated.dkim.toJson(),
    spf: value.row.policyEvaluated.spf.toJson(),
    headerFrom: value.identifiers.headerFrom,
    envelopeFrom: value.identifiers.envelopeFrom,
    envelopeTo: value.identifiers.envelopeTo,
    reasons: [
      for (final reason
          in value.row.policyEvaluated.reasons ??
              const <wire.DmarcReceivedReason>[])
        DmarcReason(type: reason.$type, comment: reason.comment),
    ],
    dkimResults: [
      for (final result
          in value.authResults.dkim ?? const <wire.DmarcReceivedDkim>[])
        DmarcAuthResult(
          domain: result.domain,
          result: result.result,
          selector: result.selector,
          humanResult: result.humanResult,
        ),
    ],
    spfResults: [
      for (final result
          in value.authResults.spf ?? const <wire.DmarcReceivedSpf>[])
        DmarcAuthResult(
          domain: result.domain,
          result: result.result,
          scope: result.scope,
          humanResult: result.humanResult,
        ),
    ],
  );

  final String sourceIp;

  /// How many messages this row stands for.
  final int count;

  /// `none`, `pass`, `quarantine` or `reject`.
  final String disposition;

  /// The evaluated, aligned result: `pass` or `fail`.
  final String dkim;

  /// The evaluated, aligned result: `pass` or `fail`.
  final String spf;
  final String headerFrom;
  final String? envelopeFrom;
  final String? envelopeTo;
  final List<DmarcReason> reasons;
  final List<DmarcAuthResult> dkimResults;
  final List<DmarcAuthResult> spfResults;

  /// DMARC passes when either aligned result does.
  bool get passed => dkim == 'pass' || spf == 'pass';
}

/// Why the reporter applied something other than the published policy.
class DmarcReason {
  const DmarcReason({required this.type, this.comment});

  final String type;
  final String? comment;
}

/// One raw DKIM or SPF check behind a record: [selector] is DKIM's, [scope]
/// is SPF's.
class DmarcAuthResult {
  const DmarcAuthResult({
    required this.domain,
    required this.result,
    this.selector,
    this.scope,
    this.humanResult,
  });

  final String domain;
  final String result;
  final String? selector;
  final String? scope;
  final String? humanResult;
}
