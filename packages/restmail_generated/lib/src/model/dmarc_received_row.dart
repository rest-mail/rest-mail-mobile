// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/dmarc_received_evaluation.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DmarcReceivedRow extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DmarcReceivedRow({
    required this.count,
    required this.policyEvaluated,
    required this.sourceIp,
  });

  factory DmarcReceivedRow.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DmarcReceivedRow: contains complex types',
    );
  }

  factory DmarcReceivedRow.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DmarcReceivedRow');
    return DmarcReceivedRow(
      count: _$map[r'count'].decodeJsonInt(context: r'DmarcReceivedRow.count'),
      policyEvaluated: _i4.DmarcReceivedEvaluation.fromJson(
        _$map[r'policy_evaluated'],
      ),
      sourceIp: _$map[r'source_ip'].decodeJsonString(
        context: r'DmarcReceivedRow.source_ip',
      ),
    );
  }

  factory DmarcReceivedRow.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DmarcReceivedRow: contains complex types',
    );
  }

  final _i3.int count;

  final _i4.DmarcReceivedEvaluation policyEvaluated;

  final _i3.String sourceIp;

  @_i3.override
  _i3.Object? toJson() => {
    r'count': count,
    r'policy_evaluated': policyEvaluated.toJson(),
    r'source_ip': sourceIp,
  };

  $$DmarcReceivedRowCopyWith<DmarcReceivedRow> get copyWith =>
      _DmarcReceivedRowCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DmarcReceivedRow &&
        other.count == this.count &&
        other.policyEvaluated == this.policyEvaluated &&
        other.sourceIp == this.sourceIp;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([count, policyEvaluated, sourceIp]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DmarcReceivedRow: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DmarcReceivedRow: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DmarcReceivedRowCopyWith<$Res> {
  factory $$DmarcReceivedRowCopyWith(DmarcReceivedRow value) =
      _DmarcReceivedRowCopyWith<$Res>;

  $Res call({
    _i3.int? count,
    _i4.DmarcReceivedEvaluation? policyEvaluated,
    _i3.String? sourceIp,
  });
  _i3.int get count;
  _i4.DmarcReceivedEvaluation get policyEvaluated;
  _i3.String get sourceIp;
}

class _DmarcReceivedRowCopyWith<$Res>
    implements $$DmarcReceivedRowCopyWith<$Res> {
  _DmarcReceivedRowCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DmarcReceivedRow _value;

  @_i3.override
  _i3.int get count => _value.count;

  @_i3.override
  _i4.DmarcReceivedEvaluation get policyEvaluated => _value.policyEvaluated;

  @_i3.override
  _i3.String get sourceIp => _value.sourceIp;

  @_i3.override
  $Res call({
    _i3.Object? count = _sentinel,
    _i3.Object? policyEvaluated = _sentinel,
    _i3.Object? sourceIp = _sentinel,
  }) {
    return (DmarcReceivedRow(
      count: _i3.identical(count, _sentinel) ? this.count : (count as _i3.int),
      policyEvaluated: _i3.identical(policyEvaluated, _sentinel)
          ? this.policyEvaluated
          : (policyEvaluated as _i4.DmarcReceivedEvaluation),
      sourceIp: _i3.identical(sourceIp, _sentinel)
          ? this.sourceIp
          : (sourceIp as _i3.String),
    ) as $Res);
  }
}
