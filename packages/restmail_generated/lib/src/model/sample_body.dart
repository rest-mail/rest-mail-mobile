// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/sample_body.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SampleBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SampleBody({this.content, this.contentType, this.parts});

  factory SampleBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for SampleBody: contains complex types',
    );
  }

  factory SampleBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SampleBody');
    return SampleBody(
      content: _$map[r'content'].decodeJsonNullableString(
        context: r'SampleBody.content',
      ),
      contentType: _$map[r'content_type'].decodeJsonNullableString(
        context: r'SampleBody.content_type',
      ),
      parts: _$map[r'parts']
          .decodeJsonNullableList<_i3.Object?>(context: r'SampleBody.parts')
          ?.map(_i4.SampleBody.fromJson)
          .toList(),
    );
  }

  factory SampleBody.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for SampleBody: contains complex types',
    );
  }

  final _i3.String? content;

  final _i3.String? contentType;

  final _i3.List<_i4.SampleBody>? parts;

  @_i3.override
  _i3.Object? toJson() => {
    r'content': content,
    r'content_type': contentType,
    r'parts': parts?.map((e) => e.toJson()).toList(),
  };

  $$SampleBodyCopyWith<SampleBody> get copyWith => _SampleBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is SampleBody &&
        other.content == this.content &&
        other.contentType == this.contentType &&
        _$deepEquals.equals(other.parts, this.parts);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([content, contentType, deepEquals.hash(parts)]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for SampleBody: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SampleBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SampleBodyCopyWith<$Res> {
  factory $$SampleBodyCopyWith(SampleBody value) = _SampleBodyCopyWith<$Res>;

  $Res call({
    _i3.String? content,
    _i3.String? contentType,
    _i3.List<_i4.SampleBody>? parts,
  });
  _i3.String? get content;
  _i3.String? get contentType;
  _i3.List<_i4.SampleBody>? get parts;
}

class _SampleBodyCopyWith<$Res> implements $$SampleBodyCopyWith<$Res> {
  _SampleBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SampleBody _value;

  @_i3.override
  _i3.String? get content => _value.content;

  @_i3.override
  _i3.String? get contentType => _value.contentType;

  @_i3.override
  _i3.List<_i4.SampleBody>? get parts => _value.parts;

  @_i3.override
  $Res call({
    _i3.Object? content = _sentinel,
    _i3.Object? contentType = _sentinel,
    _i3.Object? parts = _sentinel,
  }) {
    return (SampleBody(
      content: _i3.identical(content, _sentinel)
          ? this.content
          : (content as _i3.String?),
      contentType: _i3.identical(contentType, _sentinel)
          ? this.contentType
          : (contentType as _i3.String?),
      parts: _i3.identical(parts, _sentinel)
          ? this.parts
          : (parts as _i3.List<_i4.SampleBody>?),
    ) as $Res);
  }
}
