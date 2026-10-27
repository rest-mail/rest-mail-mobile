// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TestCustomFilterRequestBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TestCustomFilterRequestBody({this.email});

  factory TestCustomFilterRequestBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'email'},
      listKeys: {},
      context: r'TestCustomFilterRequestBody',
    );
    return TestCustomFilterRequestBody(email: _$values[r'email']);
  }

  factory TestCustomFilterRequestBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TestCustomFilterRequestBody');
    return TestCustomFilterRequestBody(email: _$map[r'email']);
  }

  factory TestCustomFilterRequestBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'email'},
      listKeys: {},
      context: r'TestCustomFilterRequestBody',
    );
    return TestCustomFilterRequestBody(
      email: _$values[r'email'].decodeFormNullableString(
        context: r'TestCustomFilterRequestBody.email',
      ),
    );
  }

  final _i3.Object? email;

  @_i3.override
  _i3.Object? toJson() => {
    if (email != null)
      r'email': _i1.encodeUnknownJson(
        email,
        context: r'TestCustomFilterRequestBody.email',
      ),
  };

  $$TestCustomFilterRequestBodyCopyWith<TestCustomFilterRequestBody>
  get copyWith => _TestCustomFilterRequestBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestCustomFilterRequestBody && other.email == this.email;
  }

  @_i3.override
  _i3.int get hashCode => email.hashCode;

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
          context: r'TestCustomFilterRequestBody.email',
        ),
      );
    }
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
      r'Cannot uriEncode TestCustomFilterRequestBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TestCustomFilterRequestBodyCopyWith<$Res> {
  factory $$TestCustomFilterRequestBodyCopyWith(
    TestCustomFilterRequestBody value,
  ) = _TestCustomFilterRequestBodyCopyWith<$Res>;

  $Res call({_i3.Object? email});
  _i3.Object? get email;
}

class _TestCustomFilterRequestBodyCopyWith<$Res>
    implements $$TestCustomFilterRequestBodyCopyWith<$Res> {
  _TestCustomFilterRequestBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TestCustomFilterRequestBody _value;

  @_i3.override
  _i3.Object? get email => _value.email;

  @_i3.override
  $Res call({_i3.Object? email = _sentinel}) {
    return (TestCustomFilterRequestBody(
      email: _i3.identical(email, _sentinel) ? this.email : email,
    ) as $Res);
  }
}
