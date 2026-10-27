// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/tlsrpt_policy.dart' as _i5;
import 'package:restmail_generated/src/model/tlsrpt_range.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TlsrptReport extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TlsrptReport({
    required this.dateRange,
    required this.organizationName,
    required this.policies,
    this.contactInfo,
    this.reportId,
  });

  factory TlsrptReport.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for TlsrptReport: contains complex types',
    );
  }

  factory TlsrptReport.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TlsrptReport');
    return TlsrptReport(
      contactInfo: _$map[r'contact-info'].decodeJsonNullableString(
        context: r'TlsrptReport.contact-info',
      ),
      dateRange: _i4.TlsrptRange.fromJson(_$map[r'date-range']),
      organizationName: _$map[r'organization-name'].decodeJsonString(
        context: r'TlsrptReport.organization-name',
      ),
      policies: _$map[r'policies']
          .decodeJsonList<_i3.Object?>(context: r'TlsrptReport.policies')
          .map(_i5.TlsrptPolicy.fromJson)
          .toList(),
      reportId: _$map[r'report-id'].decodeJsonNullableString(
        context: r'TlsrptReport.report-id',
      ),
    );
  }

  factory TlsrptReport.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for TlsrptReport: contains complex types',
    );
  }

  final _i3.String? contactInfo;

  final _i4.TlsrptRange dateRange;

  final _i3.String organizationName;

  final _i3.List<_i5.TlsrptPolicy> policies;

  final _i3.String? reportId;

  @_i3.override
  _i3.Object? toJson() => {
    if (contactInfo != null) r'contact-info': contactInfo,
    r'date-range': dateRange.toJson(),
    r'organization-name': organizationName,
    r'policies': policies.map((e) => e.toJson()).toList(),
    if (reportId != null) r'report-id': reportId,
  };

  $$TlsrptReportCopyWith<TlsrptReport> get copyWith =>
      _TlsrptReportCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is TlsrptReport &&
        other.contactInfo == this.contactInfo &&
        other.dateRange == this.dateRange &&
        other.organizationName == this.organizationName &&
        _$deepEquals.equals(other.policies, this.policies) &&
        other.reportId == this.reportId;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      contactInfo,
      dateRange,
      organizationName,
      deepEquals.hash(policies),
      reportId,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for TlsrptReport: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode TlsrptReport: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TlsrptReportCopyWith<$Res> {
  factory $$TlsrptReportCopyWith(TlsrptReport value) =
      _TlsrptReportCopyWith<$Res>;

  $Res call({
    _i3.String? contactInfo,
    _i4.TlsrptRange? dateRange,
    _i3.String? organizationName,
    _i3.List<_i5.TlsrptPolicy>? policies,
    _i3.String? reportId,
  });
  _i3.String? get contactInfo;
  _i4.TlsrptRange get dateRange;
  _i3.String get organizationName;
  _i3.List<_i5.TlsrptPolicy> get policies;
  _i3.String? get reportId;
}

class _TlsrptReportCopyWith<$Res> implements $$TlsrptReportCopyWith<$Res> {
  _TlsrptReportCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TlsrptReport _value;

  @_i3.override
  _i3.String? get contactInfo => _value.contactInfo;

  @_i3.override
  _i4.TlsrptRange get dateRange => _value.dateRange;

  @_i3.override
  _i3.String get organizationName => _value.organizationName;

  @_i3.override
  _i3.List<_i5.TlsrptPolicy> get policies => _value.policies;

  @_i3.override
  _i3.String? get reportId => _value.reportId;

  @_i3.override
  $Res call({
    _i3.Object? contactInfo = _sentinel,
    _i3.Object? dateRange = _sentinel,
    _i3.Object? organizationName = _sentinel,
    _i3.Object? policies = _sentinel,
    _i3.Object? reportId = _sentinel,
  }) {
    return (TlsrptReport(
      contactInfo: _i3.identical(contactInfo, _sentinel)
          ? this.contactInfo
          : (contactInfo as _i3.String?),
      dateRange: _i3.identical(dateRange, _sentinel)
          ? this.dateRange
          : (dateRange as _i4.TlsrptRange),
      organizationName: _i3.identical(organizationName, _sentinel)
          ? this.organizationName
          : (organizationName as _i3.String),
      policies: _i3.identical(policies, _sentinel)
          ? this.policies
          : (policies as _i3.List<_i5.TlsrptPolicy>),
      reportId: _i3.identical(reportId, _sentinel)
          ? this.reportId
          : (reportId as _i3.String?),
    ) as $Res);
  }
}
