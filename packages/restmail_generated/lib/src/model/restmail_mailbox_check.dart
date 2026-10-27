// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RestmailMailboxCheck extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RestmailMailboxCheck({required this.exists, this.address});

  factory RestmailMailboxCheck.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'address', r'exists'},
      listKeys: {},
      context: r'RestmailMailboxCheck',
    );
    return RestmailMailboxCheck(
      address: _$values[r'address'].decodeSimpleNullableString(
        context: r'RestmailMailboxCheck.address',
      ),
      exists: _$values[r'exists'].decodeSimpleBool(
        context: r'RestmailMailboxCheck.exists',
      ),
    );
  }

  factory RestmailMailboxCheck.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RestmailMailboxCheck');
    return RestmailMailboxCheck(
      address: _$map[r'address'].decodeJsonNullableString(
        context: r'RestmailMailboxCheck.address',
      ),
      exists: _$map[r'exists'].decodeJsonBool(
        context: r'RestmailMailboxCheck.exists',
      ),
    );
  }

  factory RestmailMailboxCheck.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'address', r'exists'},
      listKeys: {},
      context: r'RestmailMailboxCheck',
    );
    return RestmailMailboxCheck(
      address: _$values[r'address'].decodeFormNullableString(
        context: r'RestmailMailboxCheck.address',
      ),
      exists: _$values[r'exists'].decodeFormBool(
        context: r'RestmailMailboxCheck.exists',
      ),
    );
  }

  final _i3.String? address;

  final _i3.bool exists;

  @_i3.override
  _i3.Object? toJson() => {
    if (address != null) r'address': address,
    r'exists': exists,
  };

  $$RestmailMailboxCheckCopyWith<RestmailMailboxCheck> get copyWith =>
      _RestmailMailboxCheckCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailMailboxCheck &&
        other.address == this.address &&
        other.exists == this.exists;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([address, exists]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (address != null) {
      _$result[r'address'] = _i1.PropertyValue.scalar(address!);
    }
    _$result[r'exists'] = _i1.PropertyValue.scalar(exists.toString());
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode RestmailMailboxCheck: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RestmailMailboxCheckCopyWith<$Res> {
  factory $$RestmailMailboxCheckCopyWith(RestmailMailboxCheck value) =
      _RestmailMailboxCheckCopyWith<$Res>;

  $Res call({_i3.String? address, _i3.bool? exists});
  _i3.String? get address;
  _i3.bool get exists;
}

class _RestmailMailboxCheckCopyWith<$Res>
    implements $$RestmailMailboxCheckCopyWith<$Res> {
  _RestmailMailboxCheckCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RestmailMailboxCheck _value;

  @_i3.override
  _i3.String? get address => _value.address;

  @_i3.override
  _i3.bool get exists => _value.exists;

  @_i3.override
  $Res call({_i3.Object? address = _sentinel, _i3.Object? exists = _sentinel}) {
    return (RestmailMailboxCheck(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String?),
      exists: _i3.identical(exists, _sentinel)
          ? this.exists
          : (exists as _i3.bool),
    ) as $Res);
  }
}
