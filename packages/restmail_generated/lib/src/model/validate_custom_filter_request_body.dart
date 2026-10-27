// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ValidateCustomFilterRequestBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ValidateCustomFilterRequestBody({required this.script, this.email});

  factory ValidateCustomFilterRequestBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'email', r'script'},
      listKeys: {},
      context: r'ValidateCustomFilterRequestBody',
    );
    return ValidateCustomFilterRequestBody(
      email: _$values[r'email'],
      script: _$values[r'script'].decodeSimpleString(
        context: r'ValidateCustomFilterRequestBody.script',
      ),
    );
  }

  factory ValidateCustomFilterRequestBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ValidateCustomFilterRequestBody');
    return ValidateCustomFilterRequestBody(
      email: _$map[r'email'],
      script: _$map[r'script'].decodeJsonString(
        context: r'ValidateCustomFilterRequestBody.script',
      ),
    );
  }

  factory ValidateCustomFilterRequestBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'email', r'script'},
      listKeys: {},
      context: r'ValidateCustomFilterRequestBody',
    );
    return ValidateCustomFilterRequestBody(
      email: _$values[r'email'].decodeFormNullableString(
        context: r'ValidateCustomFilterRequestBody.email',
      ),
      script: _$values[r'script'].decodeFormString(
        context: r'ValidateCustomFilterRequestBody.script',
      ),
    );
  }

  final _i3.Object? email;

  final _i3.String script;

  @_i3.override
  _i3.Object? toJson() => {
    if (email != null)
      r'email': _i1.encodeUnknownJson(
        email,
        context: r'ValidateCustomFilterRequestBody.email',
      ),
    r'script': script,
  };

  $$ValidateCustomFilterRequestBodyCopyWith<ValidateCustomFilterRequestBody>
  get copyWith => _ValidateCustomFilterRequestBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateCustomFilterRequestBody &&
        other.email == this.email &&
        other.script == this.script;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([email, script]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (email != null) {
      _$result[r'email'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          email!,
          context: r'ValidateCustomFilterRequestBody.email',
        ),
      );
    }
    _$result[r'script'] = _i1.PropertyValue.scalar(script);
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
      r'Cannot uriEncode ValidateCustomFilterRequestBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ValidateCustomFilterRequestBodyCopyWith<$Res> {
  factory $$ValidateCustomFilterRequestBodyCopyWith(
    ValidateCustomFilterRequestBody value,
  ) = _ValidateCustomFilterRequestBodyCopyWith<$Res>;

  $Res call({_i3.Object? email, _i3.String? script});
  _i3.Object? get email;
  _i3.String get script;
}

class _ValidateCustomFilterRequestBodyCopyWith<$Res>
    implements $$ValidateCustomFilterRequestBodyCopyWith<$Res> {
  _ValidateCustomFilterRequestBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ValidateCustomFilterRequestBody _value;

  @_i3.override
  _i3.Object? get email => _value.email;

  @_i3.override
  _i3.String get script => _value.script;

  @_i3.override
  $Res call({_i3.Object? email = _sentinel, _i3.Object? script = _sentinel}) {
    return (ValidateCustomFilterRequestBody(
      email: _i3.identical(email, _sentinel) ? this.email : email,
      script: _i3.identical(script, _sentinel)
          ? this.script
          : (script as _i3.String),
    ) as $Res);
  }
}
