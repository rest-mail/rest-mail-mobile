// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TlsrptPolicyDesc extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TlsrptPolicyDesc({
    this.mxHost,
    this.policyDomain,
    this.policyString,
    this.policyType,
  });

  factory TlsrptPolicyDesc.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'mx-host',
        r'policy-domain',
        r'policy-string',
        r'policy-type',
      },
      listKeys: {r'mx-host', r'policy-string'},
      context: r'TlsrptPolicyDesc',
    );
    return TlsrptPolicyDesc(
      mxHost: _$values[r'mx-host'].decodeSimpleNullableStringList(
        context: r'TlsrptPolicyDesc.mx-host',
      ),
      policyDomain: _$values[r'policy-domain'].decodeSimpleNullableString(
        context: r'TlsrptPolicyDesc.policy-domain',
      ),
      policyString: _$values[r'policy-string'].decodeSimpleNullableStringList(
        context: r'TlsrptPolicyDesc.policy-string',
      ),
      policyType: _$values[r'policy-type'].decodeSimpleNullableString(
        context: r'TlsrptPolicyDesc.policy-type',
      ),
    );
  }

  factory TlsrptPolicyDesc.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TlsrptPolicyDesc');
    return TlsrptPolicyDesc(
      mxHost: _$map[r'mx-host'].decodeJsonNullableList<_i3.String>(
        context: r'TlsrptPolicyDesc.mx-host',
      ),
      policyDomain: _$map[r'policy-domain'].decodeJsonNullableString(
        context: r'TlsrptPolicyDesc.policy-domain',
      ),
      policyString: _$map[r'policy-string'].decodeJsonNullableList<_i3.String>(
        context: r'TlsrptPolicyDesc.policy-string',
      ),
      policyType: _$map[r'policy-type'].decodeJsonNullableString(
        context: r'TlsrptPolicyDesc.policy-type',
      ),
    );
  }

  factory TlsrptPolicyDesc.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'mx-host',
        r'policy-domain',
        r'policy-string',
        r'policy-type',
      },
      listKeys: {r'mx-host', r'policy-string'},
      context: r'TlsrptPolicyDesc',
    );
    return TlsrptPolicyDesc(
      mxHost: _$values[r'mx-host'].decodeFormNullableStringList(
        context: r'TlsrptPolicyDesc.mx-host',
      ),
      policyDomain: _$values[r'policy-domain'].decodeFormNullableString(
        context: r'TlsrptPolicyDesc.policy-domain',
      ),
      policyString: _$values[r'policy-string'].decodeFormNullableStringList(
        context: r'TlsrptPolicyDesc.policy-string',
      ),
      policyType: _$values[r'policy-type'].decodeFormNullableString(
        context: r'TlsrptPolicyDesc.policy-type',
      ),
    );
  }

  final _i3.List<_i3.String>? mxHost;

  final _i3.String? policyDomain;

  final _i3.List<_i3.String>? policyString;

  final _i3.String? policyType;

  @_i3.override
  _i3.Object? toJson() => {
    if (mxHost != null) r'mx-host': mxHost,
    if (policyDomain != null) r'policy-domain': policyDomain,
    if (policyString != null) r'policy-string': policyString,
    if (policyType != null) r'policy-type': policyType,
  };

  $$TlsrptPolicyDescCopyWith<TlsrptPolicyDesc> get copyWith =>
      _TlsrptPolicyDescCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is TlsrptPolicyDesc &&
        _$deepEquals.equals(other.mxHost, this.mxHost) &&
        other.policyDomain == this.policyDomain &&
        _$deepEquals.equals(other.policyString, this.policyString) &&
        other.policyType == this.policyType;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(mxHost),
      policyDomain,
      deepEquals.hash(policyString),
      policyType,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (mxHost != null) {
      _$result[r'mx-host'] = _i1.PropertyValue.array(mxHost!);
    }
    if (policyDomain != null) {
      _$result[r'policy-domain'] = _i1.PropertyValue.scalar(policyDomain!);
    }
    if (policyString != null) {
      _$result[r'policy-string'] = _i1.PropertyValue.array(policyString!);
    }
    if (policyType != null) {
      _$result[r'policy-type'] = _i1.PropertyValue.scalar(policyType!);
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode TlsrptPolicyDesc: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TlsrptPolicyDescCopyWith<$Res> {
  factory $$TlsrptPolicyDescCopyWith(TlsrptPolicyDesc value) =
      _TlsrptPolicyDescCopyWith<$Res>;

  $Res call({
    _i3.List<_i3.String>? mxHost,
    _i3.String? policyDomain,
    _i3.List<_i3.String>? policyString,
    _i3.String? policyType,
  });
  _i3.List<_i3.String>? get mxHost;
  _i3.String? get policyDomain;
  _i3.List<_i3.String>? get policyString;
  _i3.String? get policyType;
}

class _TlsrptPolicyDescCopyWith<$Res>
    implements $$TlsrptPolicyDescCopyWith<$Res> {
  _TlsrptPolicyDescCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TlsrptPolicyDesc _value;

  @_i3.override
  _i3.List<_i3.String>? get mxHost => _value.mxHost;

  @_i3.override
  _i3.String? get policyDomain => _value.policyDomain;

  @_i3.override
  _i3.List<_i3.String>? get policyString => _value.policyString;

  @_i3.override
  _i3.String? get policyType => _value.policyType;

  @_i3.override
  $Res call({
    _i3.Object? mxHost = _sentinel,
    _i3.Object? policyDomain = _sentinel,
    _i3.Object? policyString = _sentinel,
    _i3.Object? policyType = _sentinel,
  }) {
    return (TlsrptPolicyDesc(
      mxHost: _i3.identical(mxHost, _sentinel)
          ? this.mxHost
          : (mxHost as _i3.List<_i3.String>?),
      policyDomain: _i3.identical(policyDomain, _sentinel)
          ? this.policyDomain
          : (policyDomain as _i3.String?),
      policyString: _i3.identical(policyString, _sentinel)
          ? this.policyString
          : (policyString as _i3.List<_i3.String>?),
      policyType: _i3.identical(policyType, _sentinel)
          ? this.policyType
          : (policyType as _i3.String?),
    ) as $Res);
  }
}
