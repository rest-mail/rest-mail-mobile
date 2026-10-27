// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/tlsrpt_policy_desc.dart' as _i4;
import 'package:restmail_generated/src/model/tlsrpt_summary.dart' as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TlsrptPolicy extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TlsrptPolicy({this.failureDetails, this.policy, this.summary});

  factory TlsrptPolicy.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for TlsrptPolicy: contains complex types',
    );
  }

  factory TlsrptPolicy.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TlsrptPolicy');
    return TlsrptPolicy(
      failureDetails: _$map[r'failure-details']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'TlsrptPolicy.failure-details',
          )
          ?.map(
            (e) => e.decodeJsonMap(
              (v) => v,
              context: r'TlsrptPolicy.failure-details',
            ),
          )
          .toList(),
      policy: _$map[r'policy'] == null
          ? null
          : _i4.TlsrptPolicyDesc.fromJson(_$map[r'policy']),
      summary: _$map[r'summary'] == null
          ? null
          : _i5.TlsrptSummary.fromJson(_$map[r'summary']),
    );
  }

  factory TlsrptPolicy.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for TlsrptPolicy: contains complex types',
    );
  }

  final _i3.List<_i3.Map<_i3.String, _i3.Object?>>? failureDetails;

  final _i4.TlsrptPolicyDesc? policy;

  final _i5.TlsrptSummary? summary;

  @_i3.override
  _i3.Object? toJson() => {
    if (failureDetails != null)
      r'failure-details': failureDetails
          ?.map(
            (e) => e.map(
              (k, v) => _i3.MapEntry(
                k,
                _i1.encodeUnknownJson(
                  v,
                  context: r'TlsrptPolicy.failure-details',
                ),
              ),
            ),
          )
          .toList(),
    if (policy != null) r'policy': policy?.toJson(),
    if (summary != null) r'summary': summary?.toJson(),
  };

  $$TlsrptPolicyCopyWith<TlsrptPolicy> get copyWith =>
      _TlsrptPolicyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is TlsrptPolicy &&
        _$deepEquals.equals(other.failureDetails, this.failureDetails) &&
        other.policy == this.policy &&
        other.summary == this.summary;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(failureDetails),
      policy,
      summary,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for TlsrptPolicy: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode TlsrptPolicy: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TlsrptPolicyCopyWith<$Res> {
  factory $$TlsrptPolicyCopyWith(TlsrptPolicy value) =
      _TlsrptPolicyCopyWith<$Res>;

  $Res call({
    _i3.List<_i3.Map<_i3.String, _i3.Object?>>? failureDetails,
    _i4.TlsrptPolicyDesc? policy,
    _i5.TlsrptSummary? summary,
  });
  _i3.List<_i3.Map<_i3.String, _i3.Object?>>? get failureDetails;
  _i4.TlsrptPolicyDesc? get policy;
  _i5.TlsrptSummary? get summary;
}

class _TlsrptPolicyCopyWith<$Res> implements $$TlsrptPolicyCopyWith<$Res> {
  _TlsrptPolicyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TlsrptPolicy _value;

  @_i3.override
  _i3.List<_i3.Map<_i3.String, _i3.Object?>>? get failureDetails =>
      _value.failureDetails;

  @_i3.override
  _i4.TlsrptPolicyDesc? get policy => _value.policy;

  @_i3.override
  _i5.TlsrptSummary? get summary => _value.summary;

  @_i3.override
  $Res call({
    _i3.Object? failureDetails = _sentinel,
    _i3.Object? policy = _sentinel,
    _i3.Object? summary = _sentinel,
  }) {
    return (TlsrptPolicy(
      failureDetails: _i3.identical(failureDetails, _sentinel)
          ? this.failureDetails
          : (failureDetails as _i3.List<_i3.Map<_i3.String, _i3.Object?>>?),
      policy: _i3.identical(policy, _sentinel)
          ? this.policy
          : (policy as _i4.TlsrptPolicyDesc?),
      summary: _i3.identical(summary, _sentinel)
          ? this.summary
          : (summary as _i5.TlsrptSummary?),
    ) as $Res);
  }
}
