// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class OpenApiDescription extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const OpenApiDescription({
    required this.info,
    required this.openapi,
    required this.paths,
  });

  factory OpenApiDescription.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for OpenApiDescription: contains complex types',
    );
  }

  factory OpenApiDescription.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'OpenApiDescription');
    return OpenApiDescription(
      info: _$map[r'info'].decodeJsonMap(
        (v) => v,
        context: r'OpenApiDescription.info',
      ),
      openapi: _$map[r'openapi'].decodeJsonString(
        context: r'OpenApiDescription.openapi',
      ),
      paths: _$map[r'paths'].decodeJsonMap(
        (v) => v,
        context: r'OpenApiDescription.paths',
      ),
    );
  }

  factory OpenApiDescription.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for OpenApiDescription: contains complex types',
    );
  }

  final _i3.Map<_i3.String, _i3.Object?> info;

  final _i3.String openapi;

  final _i3.Map<_i3.String, _i3.Object?> paths;

  @_i3.override
  _i3.Object? toJson() => {
    r'info': info.map(
      (k, v) => _i3.MapEntry(
        k,
        _i1.encodeUnknownJson(v, context: r'OpenApiDescription.info'),
      ),
    ),
    r'openapi': openapi,
    r'paths': paths.map(
      (k, v) => _i3.MapEntry(
        k,
        _i1.encodeUnknownJson(v, context: r'OpenApiDescription.paths'),
      ),
    ),
  };

  $$OpenApiDescriptionCopyWith<OpenApiDescription> get copyWith =>
      _OpenApiDescriptionCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is OpenApiDescription &&
        _$deepEquals.equals(other.info, this.info) &&
        other.openapi == this.openapi &&
        _$deepEquals.equals(other.paths, this.paths);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(info),
      openapi,
      deepEquals.hash(paths),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for OpenApiDescription: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode OpenApiDescription: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$OpenApiDescriptionCopyWith<$Res> {
  factory $$OpenApiDescriptionCopyWith(OpenApiDescription value) =
      _OpenApiDescriptionCopyWith<$Res>;

  $Res call({
    _i3.Map<_i3.String, _i3.Object?>? info,
    _i3.String? openapi,
    _i3.Map<_i3.String, _i3.Object?>? paths,
  });
  _i3.Map<_i3.String, _i3.Object?> get info;
  _i3.String get openapi;
  _i3.Map<_i3.String, _i3.Object?> get paths;
}

class _OpenApiDescriptionCopyWith<$Res>
    implements $$OpenApiDescriptionCopyWith<$Res> {
  _OpenApiDescriptionCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final OpenApiDescription _value;

  @_i3.override
  _i3.Map<_i3.String, _i3.Object?> get info => _value.info;

  @_i3.override
  _i3.String get openapi => _value.openapi;

  @_i3.override
  _i3.Map<_i3.String, _i3.Object?> get paths => _value.paths;

  @_i3.override
  $Res call({
    _i3.Object? info = _sentinel,
    _i3.Object? openapi = _sentinel,
    _i3.Object? paths = _sentinel,
  }) {
    return (OpenApiDescription(
      info: _i3.identical(info, _sentinel)
          ? this.info
          : (info as _i3.Map<_i3.String, _i3.Object?>),
      openapi: _i3.identical(openapi, _sentinel)
          ? this.openapi
          : (openapi as _i3.String),
      paths: _i3.identical(paths, _sentinel)
          ? this.paths
          : (paths as _i3.Map<_i3.String, _i3.Object?>),
    ) as $Res);
  }
}
