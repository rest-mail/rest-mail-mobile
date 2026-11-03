// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/dmarc_received_policy.dart' as _i4;
import 'package:restmail_generated/src/model/dmarc_received_record.dart' as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DmarcReport extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DmarcReport({
    required this.domainId,
    required this.endDate,
    required this.id,
    required this.policyPublished,
    required this.receivedAt,
    required this.records,
    required this.reportId,
    required this.reporter,
    required this.reportingOrg,
    required this.startDate,
  });

  factory DmarcReport.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DmarcReport: contains complex types',
    );
  }

  factory DmarcReport.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DmarcReport');
    return DmarcReport(
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'DmarcReport.domain_id',
      ),
      endDate: _$map[r'end_date'].decodeJsonDateTime(
        context: r'DmarcReport.end_date',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'DmarcReport.id'),
      policyPublished: _i4.DmarcReceivedPolicy.fromJson(
        _$map[r'policy_published'],
      ),
      receivedAt: _$map[r'received_at'].decodeJsonDateTime(
        context: r'DmarcReport.received_at',
      ),
      records: _$map[r'records']
          .decodeJsonList<_i3.Object?>(context: r'DmarcReport.records')
          .map(_i5.DmarcReceivedRecord.fromJson)
          .toList(),
      reportId: _$map[r'report_id'].decodeJsonString(
        context: r'DmarcReport.report_id',
      ),
      reporter: _$map[r'reporter'].decodeJsonString(
        context: r'DmarcReport.reporter',
      ),
      reportingOrg: _$map[r'reporting_org'].decodeJsonString(
        context: r'DmarcReport.reporting_org',
      ),
      startDate: _$map[r'start_date'].decodeJsonDateTime(
        context: r'DmarcReport.start_date',
      ),
    );
  }

  factory DmarcReport.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DmarcReport: contains complex types',
    );
  }

  final _i3.int domainId;

  final _i3.DateTime endDate;

  final _i3.int id;

  final _i4.DmarcReceivedPolicy policyPublished;

  final _i3.DateTime receivedAt;

  final _i3.List<_i5.DmarcReceivedRecord> records;

  final _i3.String reportId;

  final _i3.String reporter;

  final _i3.String reportingOrg;

  final _i3.DateTime startDate;

  @_i3.override
  _i3.Object? toJson() => {
    r'domain_id': domainId,
    r'end_date': endDate.toTimeZonedIso8601String(),
    r'id': id,
    r'policy_published': policyPublished.toJson(),
    r'received_at': receivedAt.toTimeZonedIso8601String(),
    r'records': records.map((e) => e.toJson()).toList(),
    r'report_id': reportId,
    r'reporter': reporter,
    r'reporting_org': reportingOrg,
    r'start_date': startDate.toTimeZonedIso8601String(),
  };

  $$DmarcReportCopyWith<DmarcReport> get copyWith => _DmarcReportCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is DmarcReport &&
        other.domainId == this.domainId &&
        other.endDate == this.endDate &&
        other.id == this.id &&
        other.policyPublished == this.policyPublished &&
        other.receivedAt == this.receivedAt &&
        _$deepEquals.equals(other.records, this.records) &&
        other.reportId == this.reportId &&
        other.reporter == this.reporter &&
        other.reportingOrg == this.reportingOrg &&
        other.startDate == this.startDate;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      domainId,
      endDate,
      id,
      policyPublished,
      receivedAt,
      deepEquals.hash(records),
      reportId,
      reporter,
      reportingOrg,
      startDate,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DmarcReport: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DmarcReport: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DmarcReportCopyWith<$Res> {
  factory $$DmarcReportCopyWith(DmarcReport value) = _DmarcReportCopyWith<$Res>;

  $Res call({
    _i3.int? domainId,
    _i3.DateTime? endDate,
    _i3.int? id,
    _i4.DmarcReceivedPolicy? policyPublished,
    _i3.DateTime? receivedAt,
    _i3.List<_i5.DmarcReceivedRecord>? records,
    _i3.String? reportId,
    _i3.String? reporter,
    _i3.String? reportingOrg,
    _i3.DateTime? startDate,
  });
  _i3.int get domainId;
  _i3.DateTime get endDate;
  _i3.int get id;
  _i4.DmarcReceivedPolicy get policyPublished;
  _i3.DateTime get receivedAt;
  _i3.List<_i5.DmarcReceivedRecord> get records;
  _i3.String get reportId;
  _i3.String get reporter;
  _i3.String get reportingOrg;
  _i3.DateTime get startDate;
}

class _DmarcReportCopyWith<$Res> implements $$DmarcReportCopyWith<$Res> {
  _DmarcReportCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DmarcReport _value;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.DateTime get endDate => _value.endDate;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i4.DmarcReceivedPolicy get policyPublished => _value.policyPublished;

  @_i3.override
  _i3.DateTime get receivedAt => _value.receivedAt;

  @_i3.override
  _i3.List<_i5.DmarcReceivedRecord> get records => _value.records;

  @_i3.override
  _i3.String get reportId => _value.reportId;

  @_i3.override
  _i3.String get reporter => _value.reporter;

  @_i3.override
  _i3.String get reportingOrg => _value.reportingOrg;

  @_i3.override
  _i3.DateTime get startDate => _value.startDate;

  @_i3.override
  $Res call({
    _i3.Object? domainId = _sentinel,
    _i3.Object? endDate = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? policyPublished = _sentinel,
    _i3.Object? receivedAt = _sentinel,
    _i3.Object? records = _sentinel,
    _i3.Object? reportId = _sentinel,
    _i3.Object? reporter = _sentinel,
    _i3.Object? reportingOrg = _sentinel,
    _i3.Object? startDate = _sentinel,
  }) {
    return (DmarcReport(
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      endDate: _i3.identical(endDate, _sentinel)
          ? this.endDate
          : (endDate as _i3.DateTime),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      policyPublished: _i3.identical(policyPublished, _sentinel)
          ? this.policyPublished
          : (policyPublished as _i4.DmarcReceivedPolicy),
      receivedAt: _i3.identical(receivedAt, _sentinel)
          ? this.receivedAt
          : (receivedAt as _i3.DateTime),
      records: _i3.identical(records, _sentinel)
          ? this.records
          : (records as _i3.List<_i5.DmarcReceivedRecord>),
      reportId: _i3.identical(reportId, _sentinel)
          ? this.reportId
          : (reportId as _i3.String),
      reporter: _i3.identical(reporter, _sentinel)
          ? this.reporter
          : (reporter as _i3.String),
      reportingOrg: _i3.identical(reportingOrg, _sentinel)
          ? this.reportingOrg
          : (reportingOrg as _i3.String),
      startDate: _i3.identical(startDate, _sentinel)
          ? this.startDate
          : (startDate as _i3.DateTime),
    ) as $Res);
  }
}
