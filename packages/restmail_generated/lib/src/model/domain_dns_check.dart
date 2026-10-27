// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/dns_record_check.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DomainDnsCheck extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DomainDnsCheck({
    required this.domain,
    required this.records,
    required this.summary,
  });

  factory DomainDnsCheck.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DomainDnsCheck: contains complex types',
    );
  }

  factory DomainDnsCheck.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DomainDnsCheck');
    return DomainDnsCheck(
      domain: _$map[r'domain'].decodeJsonString(
        context: r'DomainDnsCheck.domain',
      ),
      records: _$map[r'records']
          .decodeJsonList<_i3.Object?>(context: r'DomainDnsCheck.records')
          .map(_i4.DnsRecordCheck.fromJson)
          .toList(),
      summary: _$map[r'summary'].decodeJsonString(
        context: r'DomainDnsCheck.summary',
      ),
    );
  }

  factory DomainDnsCheck.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DomainDnsCheck: contains complex types',
    );
  }

  final _i3.String domain;

  final _i3.List<_i4.DnsRecordCheck> records;

  final _i3.String summary;

  @_i3.override
  _i3.Object? toJson() => {
    r'domain': domain,
    r'records': records.map((e) => e.toJson()).toList(),
    r'summary': summary,
  };

  $$DomainDnsCheckCopyWith<DomainDnsCheck> get copyWith =>
      _DomainDnsCheckCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is DomainDnsCheck &&
        other.domain == this.domain &&
        _$deepEquals.equals(other.records, this.records) &&
        other.summary == this.summary;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([domain, deepEquals.hash(records), summary]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DomainDnsCheck: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DomainDnsCheck: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DomainDnsCheckCopyWith<$Res> {
  factory $$DomainDnsCheckCopyWith(DomainDnsCheck value) =
      _DomainDnsCheckCopyWith<$Res>;

  $Res call({
    _i3.String? domain,
    _i3.List<_i4.DnsRecordCheck>? records,
    _i3.String? summary,
  });
  _i3.String get domain;
  _i3.List<_i4.DnsRecordCheck> get records;
  _i3.String get summary;
}

class _DomainDnsCheckCopyWith<$Res> implements $$DomainDnsCheckCopyWith<$Res> {
  _DomainDnsCheckCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DomainDnsCheck _value;

  @_i3.override
  _i3.String get domain => _value.domain;

  @_i3.override
  _i3.List<_i4.DnsRecordCheck> get records => _value.records;

  @_i3.override
  _i3.String get summary => _value.summary;

  @_i3.override
  $Res call({
    _i3.Object? domain = _sentinel,
    _i3.Object? records = _sentinel,
    _i3.Object? summary = _sentinel,
  }) {
    return (DomainDnsCheck(
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i3.String),
      records: _i3.identical(records, _sentinel)
          ? this.records
          : (records as _i3.List<_i4.DnsRecordCheck>),
      summary: _i3.identical(summary, _sentinel)
          ? this.summary
          : (summary as _i3.String),
    ) as $Res);
  }
}
