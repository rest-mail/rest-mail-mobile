// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/refresh_request.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
sealed class $RawApiV1AuthRefreshPostBodyBodyOneOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const $RawApiV1AuthRefreshPostBodyBodyOneOfModel();

  factory $RawApiV1AuthRefreshPostBodyBodyOneOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    try {
      return $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest(
        _i4.RefreshRequest.fromSimple(value, explode: explode),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid simple value for $RawApiV1AuthRefreshPostBodyBodyOneOfModel',
    );
  }

  factory $RawApiV1AuthRefreshPostBodyBodyOneOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    try {
      return $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest(
        _i4.RefreshRequest.fromForm(value, explode: explode),
      );
    } on _i1.DecodingException catch (_) {
    } on _i3.FormatException catch (_) {}
    throw _i1.SimpleDecodingException(
      r'Invalid form value for $RawApiV1AuthRefreshPostBodyBodyOneOfModel',
    );
  }

  factory $RawApiV1AuthRefreshPostBodyBodyOneOfModel.fromJson(
    _i3.Object? json,
  ) {
    try {
      return $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest(
        _i4.RefreshRequest.fromJson(json),
      );
    } on _i3.Object catch (_) {}
    throw _i1.JsonDecodingException(
      r'Invalid JSON for $RawApiV1AuthRefreshPostBodyBodyOneOfModel',
    );
  }

  _i1.EncodingShape get currentEncodingShape {
    return switch (this) {
      $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest(:final value) =>
        value.currentEncodingShape,
    };
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    return switch (this) {
      $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest(:final value) =>
        value.parameterProperties(allowEmpty: allowEmpty),
    };
  }

  @_i3.override
  _i3.String toSimple({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    _i3.bool literal = false,
  }) {
    return switch (this) {
      $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest(:final value) =>
        value.toSimple(
          explode: explode,
          allowEmpty: allowEmpty,
          literal: literal,
        ),
    };
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toForm(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
    _i3.Map<_i3.String, _i1.FormFieldEncoding> fieldEncodings = const {},
  }) {
    return switch (this) {
      $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest(:final value) =>
        value.toForm(
          paramName,
          explode: explode,
          allowEmpty: allowEmpty,
          useQueryComponent: useQueryComponent,
          allowReserved: allowReserved,
          textEncoding: textEncoding,
        ),
    };
  }

  @_i3.override
  _i3.String toLabel({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    return switch (this) {
      $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest(:final value) =>
        value.toLabel(explode: explode, allowEmpty: allowEmpty),
    };
  }

  @_i3.override
  _i3.String toMatrix(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    return switch (this) {
      $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest(:final value) =>
        value.toMatrix(paramName, explode: explode, allowEmpty: allowEmpty),
    };
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toDeepObject(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toDeepObject(
      paramName,
      explode: explode,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toPipeDelimited(
    _i3.String paramName, {
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toPipeDelimited(
      paramName,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toSpaceDelimited(
    _i3.String paramName, {
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toSpaceDelimited(
      paramName,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    return switch (this) {
      $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest() =>
        throw _i1.EncodingException(
          r'Cannot uriEncode $RawApiV1AuthRefreshPostBodyBodyOneOfModel: variant contains complex type',
        ),
    };
  }

  @_i3.override
  _i3.Object? toJson() {
    final (_i3.dynamic _$json, _i3.String? _$discriminator) = switch (this) {
      $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest(:final value) =>
        (value.toJson(), null),
    };
    return _$json;
  }
}

@_i2.immutable
class $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest
    extends $RawApiV1AuthRefreshPostBodyBodyOneOfModel {
  const $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest(this.value);

  final _i4.RefreshRequest value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is $RawApiV1AuthRefreshPostBodyBodyOneOfModelRefreshRequest &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => value.hashCode;
}

typedef ApiV1AuthRefreshPostBodyBodyOneOfModel =
    $RawApiV1AuthRefreshPostBodyBodyOneOfModel?;
