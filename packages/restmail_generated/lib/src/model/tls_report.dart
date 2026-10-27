// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/domain.dart' as _i4;
import 'package:restmail_generated/src/model/tls_report_policy_type_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TlsReport extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TlsReport({
    required this.createdAt,
    required this.domainId,
    required this.endDate,
    required this.id,
    required this.policyDomain,
    required this.policyType,
    required this.receivedAt,
    required this.reportingOrg,
    required this.startDate,
    required this.totalFailure,
    required this.totalSuccessful,
    this.domain,
    this.failureDetails,
    this.rawReport,
  });

  factory TlsReport.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for TlsReport: contains complex types',
    );
  }

  factory TlsReport.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TlsReport');
    return TlsReport(
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'TlsReport.created_at',
      ),
      domain: _$map[r'domain'] == null
          ? null
          : _i4.Domain.fromJson(_$map[r'domain']),
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'TlsReport.domain_id',
      ),
      endDate: _$map[r'end_date'].decodeJsonDateTime(
        context: r'TlsReport.end_date',
      ),
      failureDetails: _$map[r'failure_details'],
      id: _$map[r'id'].decodeJsonInt(context: r'TlsReport.id'),
      policyDomain: _$map[r'policy_domain'].decodeJsonString(
        context: r'TlsReport.policy_domain',
      ),
      policyType: _i5.TlsReportPolicyTypeModel.fromJson(_$map[r'policy_type']),
      rawReport: _$map[r'raw_report'].decodeJsonNullableString(
        context: r'TlsReport.raw_report',
      ),
      receivedAt: _$map[r'received_at'].decodeJsonDateTime(
        context: r'TlsReport.received_at',
      ),
      reportingOrg: _$map[r'reporting_org'].decodeJsonString(
        context: r'TlsReport.reporting_org',
      ),
      startDate: _$map[r'start_date'].decodeJsonDateTime(
        context: r'TlsReport.start_date',
      ),
      totalFailure: _$map[r'total_failure'].decodeJsonInt(
        context: r'TlsReport.total_failure',
      ),
      totalSuccessful: _$map[r'total_successful'].decodeJsonInt(
        context: r'TlsReport.total_successful',
      ),
    );
  }

  factory TlsReport.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for TlsReport: contains complex types',
    );
  }

  final _i3.DateTime createdAt;

  final _i4.Domain? domain;

  final _i3.int domainId;

  final _i3.DateTime endDate;

  final _i3.Object? failureDetails;

  final _i3.int id;

  final _i3.String policyDomain;

  final _i5.TlsReportPolicyTypeModel policyType;

  final _i3.String? rawReport;

  final _i3.DateTime receivedAt;

  final _i3.String reportingOrg;

  final _i3.DateTime startDate;

  final _i3.int totalFailure;

  final _i3.int totalSuccessful;

  @_i3.override
  _i3.Object? toJson() => {
    r'created_at': createdAt.toTimeZonedIso8601String(),
    if (domain != null) r'domain': domain?.toJson(),
    r'domain_id': domainId,
    r'end_date': endDate.toTimeZonedIso8601String(),
    if (failureDetails != null)
      r'failure_details': _i1.encodeUnknownJson(
        failureDetails,
        context: r'TlsReport.failure_details',
      ),
    r'id': id,
    r'policy_domain': policyDomain,
    r'policy_type': policyType.toJson(),
    if (rawReport != null) r'raw_report': rawReport,
    r'received_at': receivedAt.toTimeZonedIso8601String(),
    r'reporting_org': reportingOrg,
    r'start_date': startDate.toTimeZonedIso8601String(),
    r'total_failure': totalFailure,
    r'total_successful': totalSuccessful,
  };

  $$TlsReportCopyWith<TlsReport> get copyWith => _TlsReportCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TlsReport &&
        other.createdAt == this.createdAt &&
        other.domain == this.domain &&
        other.domainId == this.domainId &&
        other.endDate == this.endDate &&
        other.failureDetails == this.failureDetails &&
        other.id == this.id &&
        other.policyDomain == this.policyDomain &&
        other.policyType == this.policyType &&
        other.rawReport == this.rawReport &&
        other.receivedAt == this.receivedAt &&
        other.reportingOrg == this.reportingOrg &&
        other.startDate == this.startDate &&
        other.totalFailure == this.totalFailure &&
        other.totalSuccessful == this.totalSuccessful;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      createdAt,
      domain,
      domainId,
      endDate,
      failureDetails,
      id,
      policyDomain,
      policyType,
      rawReport,
      receivedAt,
      reportingOrg,
      startDate,
      totalFailure,
      totalSuccessful,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for TlsReport: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode TlsReport: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TlsReportCopyWith<$Res> {
  factory $$TlsReportCopyWith(TlsReport value) = _TlsReportCopyWith<$Res>;

  $Res call({
    _i3.DateTime? createdAt,
    _i4.Domain? domain,
    _i3.int? domainId,
    _i3.DateTime? endDate,
    _i3.Object? failureDetails,
    _i3.int? id,
    _i3.String? policyDomain,
    _i5.TlsReportPolicyTypeModel? policyType,
    _i3.String? rawReport,
    _i3.DateTime? receivedAt,
    _i3.String? reportingOrg,
    _i3.DateTime? startDate,
    _i3.int? totalFailure,
    _i3.int? totalSuccessful,
  });
  _i3.DateTime get createdAt;
  _i4.Domain? get domain;
  _i3.int get domainId;
  _i3.DateTime get endDate;
  _i3.Object? get failureDetails;
  _i3.int get id;
  _i3.String get policyDomain;
  _i5.TlsReportPolicyTypeModel get policyType;
  _i3.String? get rawReport;
  _i3.DateTime get receivedAt;
  _i3.String get reportingOrg;
  _i3.DateTime get startDate;
  _i3.int get totalFailure;
  _i3.int get totalSuccessful;
}

class _TlsReportCopyWith<$Res> implements $$TlsReportCopyWith<$Res> {
  _TlsReportCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TlsReport _value;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i4.Domain? get domain => _value.domain;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.DateTime get endDate => _value.endDate;

  @_i3.override
  _i3.Object? get failureDetails => _value.failureDetails;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get policyDomain => _value.policyDomain;

  @_i3.override
  _i5.TlsReportPolicyTypeModel get policyType => _value.policyType;

  @_i3.override
  _i3.String? get rawReport => _value.rawReport;

  @_i3.override
  _i3.DateTime get receivedAt => _value.receivedAt;

  @_i3.override
  _i3.String get reportingOrg => _value.reportingOrg;

  @_i3.override
  _i3.DateTime get startDate => _value.startDate;

  @_i3.override
  _i3.int get totalFailure => _value.totalFailure;

  @_i3.override
  _i3.int get totalSuccessful => _value.totalSuccessful;

  @_i3.override
  $Res call({
    _i3.Object? createdAt = _sentinel,
    _i3.Object? domain = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? endDate = _sentinel,
    _i3.Object? failureDetails = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? policyDomain = _sentinel,
    _i3.Object? policyType = _sentinel,
    _i3.Object? rawReport = _sentinel,
    _i3.Object? receivedAt = _sentinel,
    _i3.Object? reportingOrg = _sentinel,
    _i3.Object? startDate = _sentinel,
    _i3.Object? totalFailure = _sentinel,
    _i3.Object? totalSuccessful = _sentinel,
  }) {
    return (TlsReport(
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i4.Domain?),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      endDate: _i3.identical(endDate, _sentinel)
          ? this.endDate
          : (endDate as _i3.DateTime),
      failureDetails: _i3.identical(failureDetails, _sentinel)
          ? this.failureDetails
          : failureDetails,
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      policyDomain: _i3.identical(policyDomain, _sentinel)
          ? this.policyDomain
          : (policyDomain as _i3.String),
      policyType: _i3.identical(policyType, _sentinel)
          ? this.policyType
          : (policyType as _i5.TlsReportPolicyTypeModel),
      rawReport: _i3.identical(rawReport, _sentinel)
          ? this.rawReport
          : (rawReport as _i3.String?),
      receivedAt: _i3.identical(receivedAt, _sentinel)
          ? this.receivedAt
          : (receivedAt as _i3.DateTime),
      reportingOrg: _i3.identical(reportingOrg, _sentinel)
          ? this.reportingOrg
          : (reportingOrg as _i3.String),
      startDate: _i3.identical(startDate, _sentinel)
          ? this.startDate
          : (startDate as _i3.DateTime),
      totalFailure: _i3.identical(totalFailure, _sentinel)
          ? this.totalFailure
          : (totalFailure as _i3.int),
      totalSuccessful: _i3.identical(totalSuccessful, _sentinel)
          ? this.totalSuccessful
          : (totalSuccessful as _i3.int),
    ) as $Res);
  }
}
