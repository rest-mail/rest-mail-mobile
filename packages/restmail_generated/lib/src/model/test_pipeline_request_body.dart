// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/test_pipeline_request_body_email_one_of_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TestPipelineRequestBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TestPipelineRequestBody({required this.email, this.pipelineId});

  factory TestPipelineRequestBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for TestPipelineRequestBody: contains complex types',
    );
  }

  factory TestPipelineRequestBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TestPipelineRequestBody');
    return TestPipelineRequestBody(
      email: _$map[r'email'] == null
          ? null
          : _i4.TestPipelineRequestBodyEmailOneOfModel.fromJson(
              _$map[r'email'],
            ),
      pipelineId: _$map[r'pipeline_id'].decodeJsonNullableInt(
        context: r'TestPipelineRequestBody.pipeline_id',
      ),
    );
  }

  factory TestPipelineRequestBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for TestPipelineRequestBody: contains complex types',
    );
  }

  final _i4.TestPipelineRequestBodyEmailOneOfModel email;

  final _i3.int? pipelineId;

  @_i3.override
  _i3.Object? toJson() => {
    r'email': email?.toJson(),
    if (pipelineId != null) r'pipeline_id': pipelineId,
  };

  $$TestPipelineRequestBodyCopyWith<TestPipelineRequestBody> get copyWith =>
      _TestPipelineRequestBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestPipelineRequestBody &&
        other.email == this.email &&
        other.pipelineId == this.pipelineId;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([email, pipelineId]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for TestPipelineRequestBody: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode TestPipelineRequestBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TestPipelineRequestBodyCopyWith<$Res> {
  factory $$TestPipelineRequestBodyCopyWith(TestPipelineRequestBody value) =
      _TestPipelineRequestBodyCopyWith<$Res>;

  $Res call({
    _i4.TestPipelineRequestBodyEmailOneOfModel? email,
    _i3.int? pipelineId,
  });
  _i4.TestPipelineRequestBodyEmailOneOfModel get email;
  _i3.int? get pipelineId;
}

class _TestPipelineRequestBodyCopyWith<$Res>
    implements $$TestPipelineRequestBodyCopyWith<$Res> {
  _TestPipelineRequestBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TestPipelineRequestBody _value;

  @_i3.override
  _i4.TestPipelineRequestBodyEmailOneOfModel get email => _value.email;

  @_i3.override
  _i3.int? get pipelineId => _value.pipelineId;

  @_i3.override
  $Res call({
    _i3.Object? email = _sentinel,
    _i3.Object? pipelineId = _sentinel,
  }) {
    return (TestPipelineRequestBody(
      email: _i3.identical(email, _sentinel)
          ? this.email
          : (email as _i4.TestPipelineRequestBodyEmailOneOfModel),
      pipelineId: _i3.identical(pipelineId, _sentinel)
          ? this.pipelineId
          : (pipelineId as _i3.int?),
    ) as $Res);
  }
}
