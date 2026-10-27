// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/test_filter_request_body_email_one_of_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TestFilterRequestBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TestFilterRequestBody({this.config, this.email, this.filterName});

  factory TestFilterRequestBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for TestFilterRequestBody: contains complex types',
    );
  }

  factory TestFilterRequestBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TestFilterRequestBody');
    return TestFilterRequestBody(
      config: _$map[r'config'],
      email: _$map[r'email'] == null
          ? null
          : _i4.TestFilterRequestBodyEmailOneOfModel.fromJson(_$map[r'email']),
      filterName: _$map[r'filter_name'].decodeJsonNullableString(
        context: r'TestFilterRequestBody.filter_name',
      ),
    );
  }

  factory TestFilterRequestBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for TestFilterRequestBody: contains complex types',
    );
  }

  final _i3.Object? config;

  final _i4.TestFilterRequestBodyEmailOneOfModel? email;

  final _i3.String? filterName;

  @_i3.override
  _i3.Object? toJson() => {
    if (config != null)
      r'config': _i1.encodeUnknownJson(
        config,
        context: r'TestFilterRequestBody.config',
      ),
    if (email != null) r'email': email?.toJson(),
    if (filterName != null) r'filter_name': filterName,
  };

  $$TestFilterRequestBodyCopyWith<TestFilterRequestBody> get copyWith =>
      _TestFilterRequestBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestFilterRequestBody &&
        other.config == this.config &&
        other.email == this.email &&
        other.filterName == this.filterName;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([config, email, filterName]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for TestFilterRequestBody: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode TestFilterRequestBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TestFilterRequestBodyCopyWith<$Res> {
  factory $$TestFilterRequestBodyCopyWith(TestFilterRequestBody value) =
      _TestFilterRequestBodyCopyWith<$Res>;

  $Res call({
    _i3.Object? config,
    _i4.TestFilterRequestBodyEmailOneOfModel? email,
    _i3.String? filterName,
  });
  _i3.Object? get config;
  _i4.TestFilterRequestBodyEmailOneOfModel? get email;
  _i3.String? get filterName;
}

class _TestFilterRequestBodyCopyWith<$Res>
    implements $$TestFilterRequestBodyCopyWith<$Res> {
  _TestFilterRequestBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TestFilterRequestBody _value;

  @_i3.override
  _i3.Object? get config => _value.config;

  @_i3.override
  _i4.TestFilterRequestBodyEmailOneOfModel? get email => _value.email;

  @_i3.override
  _i3.String? get filterName => _value.filterName;

  @_i3.override
  $Res call({
    _i3.Object? config = _sentinel,
    _i3.Object? email = _sentinel,
    _i3.Object? filterName = _sentinel,
  }) {
    return (TestFilterRequestBody(
      config: _i3.identical(config, _sentinel) ? this.config : config,
      email: _i3.identical(email, _sentinel)
          ? this.email
          : (email as _i4.TestFilterRequestBodyEmailOneOfModel?),
      filterName: _i3.identical(filterName, _sentinel)
          ? this.filterName
          : (filterName as _i3.String?),
    ) as $Res);
  }
}
