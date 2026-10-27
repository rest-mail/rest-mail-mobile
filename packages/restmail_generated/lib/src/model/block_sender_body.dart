// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class BlockSenderBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const BlockSenderBody({required this.email});

  factory BlockSenderBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'email'},
      listKeys: {},
      context: r'BlockSenderBody',
    );
    return BlockSenderBody(
      email: _$values[r'email'].decodeSimpleString(
        context: r'BlockSenderBody.email',
      ),
    );
  }

  factory BlockSenderBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'BlockSenderBody');
    return BlockSenderBody(
      email: _$map[r'email'].decodeJsonString(
        context: r'BlockSenderBody.email',
      ),
    );
  }

  factory BlockSenderBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'email'},
      listKeys: {},
      context: r'BlockSenderBody',
    );
    return BlockSenderBody(
      email: _$values[r'email'].decodeFormString(
        context: r'BlockSenderBody.email',
      ),
    );
  }

  final _i3.String email;

  @_i3.override
  _i3.Object? toJson() => {r'email': email};

  $$BlockSenderBodyCopyWith<BlockSenderBody> get copyWith =>
      _BlockSenderBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BlockSenderBody && other.email == this.email;
  }

  @_i3.override
  _i3.int get hashCode => email.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'email'] = _i1.PropertyValue.scalar(email);
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
      r'Cannot uriEncode BlockSenderBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$BlockSenderBodyCopyWith<$Res> {
  factory $$BlockSenderBodyCopyWith(BlockSenderBody value) =
      _BlockSenderBodyCopyWith<$Res>;

  $Res call({_i3.String? email});
  _i3.String get email;
}

class _BlockSenderBodyCopyWith<$Res>
    implements $$BlockSenderBodyCopyWith<$Res> {
  _BlockSenderBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final BlockSenderBody _value;

  @_i3.override
  _i3.String get email => _value.email;

  @_i3.override
  $Res call({_i3.Object? email = _sentinel}) {
    return (BlockSenderBody(
      email: _i3.identical(email, _sentinel)
          ? this.email
          : (email as _i3.String),
    ) as $Res);
  }
}
