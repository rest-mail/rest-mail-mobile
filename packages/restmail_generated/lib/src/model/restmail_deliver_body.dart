// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/restmail_deliver_body_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/restmail_deliver_body_model2.dart'
    as _i5;
import 'package:restmail_generated/src/model/restmail_deliver_body_model3.dart'
    as _i6;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RestmailDeliverBody implements _i1.ParameterEncodable, _i1.UriEncodable {
  const RestmailDeliverBody({
    this.restmailDeliverBodyModel3,
    this.restmailDeliverBodyModel2,
    this.restmailDeliverBodyModel,
  });

  factory RestmailDeliverBody.fromJson(_i3.Object? json) {
    _i4.RestmailDeliverBodyModel? restmailDeliverBodyModel;

    try {
      restmailDeliverBodyModel = _i4.RestmailDeliverBodyModel.fromJson(json);
    } on _i3.Object catch (_) {
      restmailDeliverBodyModel = null;
    }

    _i5.RestmailDeliverBodyModel2? restmailDeliverBodyModel2;

    try {
      restmailDeliverBodyModel2 = _i5.RestmailDeliverBodyModel2.fromJson(json);
    } on _i3.Object catch (_) {
      restmailDeliverBodyModel2 = null;
    }

    _i6.RestmailDeliverBodyModel3? restmailDeliverBodyModel3;

    try {
      restmailDeliverBodyModel3 = _i6.RestmailDeliverBodyModel3.fromJson(json);
    } on _i3.Object catch (_) {
      restmailDeliverBodyModel3 = null;
    }

    if (restmailDeliverBodyModel == null &&
        restmailDeliverBodyModel2 == null &&
        restmailDeliverBodyModel3 == null) {
      throw _i1.JsonDecodingException(
        r'Invalid JSON for RestmailDeliverBody: all variants failed to decode',
      );
    }
    return RestmailDeliverBody(
      restmailDeliverBodyModel: restmailDeliverBodyModel,
      restmailDeliverBodyModel2: restmailDeliverBodyModel2,
      restmailDeliverBodyModel3: restmailDeliverBodyModel3,
    );
  }

  factory RestmailDeliverBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.RestmailDeliverBodyModel? restmailDeliverBodyModel;

    try {
      restmailDeliverBodyModel = _i4.RestmailDeliverBodyModel.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      restmailDeliverBodyModel = null;
    }

    _i5.RestmailDeliverBodyModel2? restmailDeliverBodyModel2;

    try {
      restmailDeliverBodyModel2 = _i5.RestmailDeliverBodyModel2.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      restmailDeliverBodyModel2 = null;
    }

    _i6.RestmailDeliverBodyModel3? restmailDeliverBodyModel3;

    try {
      restmailDeliverBodyModel3 = _i6.RestmailDeliverBodyModel3.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      restmailDeliverBodyModel3 = null;
    }

    if (restmailDeliverBodyModel == null &&
        restmailDeliverBodyModel2 == null &&
        restmailDeliverBodyModel3 == null) {
      throw _i1.SimpleDecodingException(
        r'Invalid simple value for RestmailDeliverBody: all variants failed to decode',
      );
    }
    return RestmailDeliverBody(
      restmailDeliverBodyModel: restmailDeliverBodyModel,
      restmailDeliverBodyModel2: restmailDeliverBodyModel2,
      restmailDeliverBodyModel3: restmailDeliverBodyModel3,
    );
  }

  factory RestmailDeliverBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.RestmailDeliverBodyModel? restmailDeliverBodyModel;

    try {
      restmailDeliverBodyModel = _i4.RestmailDeliverBodyModel.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      restmailDeliverBodyModel = null;
    }

    _i5.RestmailDeliverBodyModel2? restmailDeliverBodyModel2;

    try {
      restmailDeliverBodyModel2 = _i5.RestmailDeliverBodyModel2.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      restmailDeliverBodyModel2 = null;
    }

    _i6.RestmailDeliverBodyModel3? restmailDeliverBodyModel3;

    try {
      restmailDeliverBodyModel3 = _i6.RestmailDeliverBodyModel3.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      restmailDeliverBodyModel3 = null;
    }

    if (restmailDeliverBodyModel == null &&
        restmailDeliverBodyModel2 == null &&
        restmailDeliverBodyModel3 == null) {
      throw _i1.FormDecodingException(
        r'Invalid form value for RestmailDeliverBody: all variants failed to decode',
      );
    }
    return RestmailDeliverBody(
      restmailDeliverBodyModel: restmailDeliverBodyModel,
      restmailDeliverBodyModel2: restmailDeliverBodyModel2,
      restmailDeliverBodyModel3: restmailDeliverBodyModel3,
    );
  }

  final _i6.RestmailDeliverBodyModel3? restmailDeliverBodyModel3;

  final _i5.RestmailDeliverBodyModel2? restmailDeliverBodyModel2;

  final _i4.RestmailDeliverBodyModel? restmailDeliverBodyModel;

  _i1.EncodingShape get currentEncodingShape {
    final _$shapes = <_i1.EncodingShape>{};
    if (restmailDeliverBodyModel != null) {
      _$shapes.add(restmailDeliverBodyModel!.currentEncodingShape);
    }
    if (restmailDeliverBodyModel2 != null) {
      _$shapes.add(restmailDeliverBodyModel2!.currentEncodingShape);
    }
    if (restmailDeliverBodyModel3 != null) {
      _$shapes.add(restmailDeliverBodyModel3!.currentEncodingShape);
    }
    if (_$shapes.isEmpty) {
      throw _i3.StateError('At least one field must be non-null in anyOf');
    }
    if (_$shapes.length > 1) return _i1.EncodingShape.mixed;
    return _$shapes.first;
  }

  @_i3.override
  _i3.Object? toJson() {
    final _$values = <_i3.Object?>{};
    final _$mapValues = <_i3.Map<_i3.String, _i3.Object?>>[];
    if (restmailDeliverBodyModel != null) {
      final _i3.Object? _$restmailDeliverBodyModelJson =
          restmailDeliverBodyModel!.toJson();
      if (_$restmailDeliverBodyModelJson is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$restmailDeliverBodyModelJson);
      } else {
        _$values.add(_$restmailDeliverBodyModelJson);
      }
    }
    if (restmailDeliverBodyModel2 != null) {
      final _i3.Object? _$restmailDeliverBodyModel2Json =
          restmailDeliverBodyModel2!.toJson();
      if (_$restmailDeliverBodyModel2Json is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$restmailDeliverBodyModel2Json);
      } else {
        _$values.add(_$restmailDeliverBodyModel2Json);
      }
    }
    if (restmailDeliverBodyModel3 != null) {
      final _i3.Object? _$restmailDeliverBodyModel3Json =
          restmailDeliverBodyModel3!.toJson();
      if (_$restmailDeliverBodyModel3Json is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$restmailDeliverBodyModel3Json);
      } else {
        _$values.add(_$restmailDeliverBodyModel3Json);
      }
    }
    if (_$values.isEmpty && _$mapValues.isEmpty) return null;
    if (_$values.isNotEmpty && _$mapValues.isNotEmpty) {
      throw _i1.EncodingException(
        r'Mixed encoding not supported for RestmailDeliverBody: cannot encode both simple and complex values',
      );
    }
    if (_$values.isNotEmpty) {
      return _$values.first;
    }
    if (_$mapValues.isNotEmpty) {
      final _$map = <_i3.String, _i3.Object?>{};
      for (final _$m in _$mapValues) {
        _$map.addAll(_$m);
      }
      return _$map;
    }
    return null;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mapValues = <_i3.Map<_i3.String, _i1.PropertyValue>>[];
    if (restmailDeliverBodyModel != null) {
      _$mapValues.add(
        restmailDeliverBodyModel!.parameterProperties(allowEmpty: allowEmpty),
      );
    }
    if (restmailDeliverBodyModel2 != null) {
      _$mapValues.add(
        restmailDeliverBodyModel2!.parameterProperties(allowEmpty: allowEmpty),
      );
    }
    if (restmailDeliverBodyModel3 != null) {
      _$mapValues.add(
        restmailDeliverBodyModel3!.parameterProperties(allowEmpty: allowEmpty),
      );
    }
    final _$map = <_i3.String, _i1.PropertyValue>{};
    for (final _$m in _$mapValues) {
      _$map.addAll(_$m);
    }
    return _$map;
  }

  @_i3.override
  _i3.String toSimple({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    _i3.bool literal = false,
  }) {
    final _$mapValues = <_i3.Map<_i3.String, _i1.PropertyValue>>[];
    if (restmailDeliverBodyModel != null) {
      final _$restmailDeliverBodyModelSimple = restmailDeliverBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModelSimple);
    }
    if (restmailDeliverBodyModel2 != null) {
      final _$restmailDeliverBodyModel2Simple = restmailDeliverBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModel2Simple);
    }
    if (restmailDeliverBodyModel3 != null) {
      final _$restmailDeliverBodyModel3Simple = restmailDeliverBodyModel3!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModel3Simple);
    }
    final _$map = <_i3.String, _i1.PropertyValue>{};
    for (final _$m in _$mapValues) {
      _$map.addAll(_$m);
    }
    return _$map.toSimple(
      explode: explode,
      allowEmpty: allowEmpty,
      literal: literal,
    );
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toForm(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
    _i3.Map<_i3.String, _i1.FormFieldEncoding> fieldEncodings = const {},
  }) {
    final _$mapValues = <_i3.Map<_i3.String, _i1.PropertyValue>>[];
    if (restmailDeliverBodyModel != null) {
      final _$restmailDeliverBodyModelForm = restmailDeliverBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModelForm);
    }
    if (restmailDeliverBodyModel2 != null) {
      final _$restmailDeliverBodyModel2Form = restmailDeliverBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModel2Form);
    }
    if (restmailDeliverBodyModel3 != null) {
      final _$restmailDeliverBodyModel3Form = restmailDeliverBodyModel3!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModel3Form);
    }
    final _$map = <_i3.String, _i1.PropertyValue>{};
    for (final _$m in _$mapValues) {
      _$map.addAll(_$m);
    }
    return _$map.toForm(
      paramName,
      explode: explode,
      allowEmpty: allowEmpty,
      useQueryComponent: useQueryComponent,
      allowReserved: allowReserved,
      fieldEncodings: fieldEncodings,
      textEncoding: textEncoding,
    );
  }

  @_i3.override
  _i3.String toLabel({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    final _$mapValues = <_i3.Map<_i3.String, _i1.PropertyValue>>[];
    if (restmailDeliverBodyModel != null) {
      final _$restmailDeliverBodyModelLabel = restmailDeliverBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModelLabel);
    }
    if (restmailDeliverBodyModel2 != null) {
      final _$restmailDeliverBodyModel2Label = restmailDeliverBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModel2Label);
    }
    if (restmailDeliverBodyModel3 != null) {
      final _$restmailDeliverBodyModel3Label = restmailDeliverBodyModel3!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModel3Label);
    }
    final _$map = <_i3.String, _i1.PropertyValue>{};
    for (final _$m in _$mapValues) {
      _$map.addAll(_$m);
    }
    return _$map.toLabel(explode: explode, allowEmpty: allowEmpty);
  }

  @_i3.override
  _i3.String toMatrix(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    final _$mapValues = <_i3.Map<_i3.String, _i1.PropertyValue>>[];
    if (restmailDeliverBodyModel != null) {
      final _$restmailDeliverBodyModelMatrix = restmailDeliverBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModelMatrix);
    }
    if (restmailDeliverBodyModel2 != null) {
      final _$restmailDeliverBodyModel2Matrix = restmailDeliverBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModel2Matrix);
    }
    if (restmailDeliverBodyModel3 != null) {
      final _$restmailDeliverBodyModel3Matrix = restmailDeliverBodyModel3!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$restmailDeliverBodyModel3Matrix);
    }
    final _$map = <_i3.String, _i1.PropertyValue>{};
    for (final _$m in _$mapValues) {
      _$map.addAll(_$m);
    }
    return _$map.toMatrix(paramName, explode: explode, allowEmpty: allowEmpty);
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
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    if (restmailDeliverBodyModel != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode RestmailDeliverBody: contains complex type',
      );
    }
    if (restmailDeliverBodyModel2 != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode RestmailDeliverBody: contains complex type',
      );
    }
    if (restmailDeliverBodyModel3 != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode RestmailDeliverBody: contains complex type',
      );
    }
    throw _i1.EncodingException(
      r'Cannot uriEncode RestmailDeliverBody: no value set',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDeliverBody &&
        other.restmailDeliverBodyModel3 == this.restmailDeliverBodyModel3 &&
        other.restmailDeliverBodyModel2 == this.restmailDeliverBodyModel2 &&
        other.restmailDeliverBodyModel == this.restmailDeliverBodyModel;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      restmailDeliverBodyModel3,
      restmailDeliverBodyModel2,
      restmailDeliverBodyModel,
    ]);
  }

  $$RestmailDeliverBodyCopyWith<RestmailDeliverBody> get copyWith =>
      _RestmailDeliverBodyCopyWith(this);
}

abstract class $$RestmailDeliverBodyCopyWith<$Res> {
  factory $$RestmailDeliverBodyCopyWith(RestmailDeliverBody value) =
      _RestmailDeliverBodyCopyWith<$Res>;

  $Res call({
    _i6.RestmailDeliverBodyModel3? restmailDeliverBodyModel3,
    _i5.RestmailDeliverBodyModel2? restmailDeliverBodyModel2,
    _i4.RestmailDeliverBodyModel? restmailDeliverBodyModel,
  });
  _i6.RestmailDeliverBodyModel3? get restmailDeliverBodyModel3;
  _i5.RestmailDeliverBodyModel2? get restmailDeliverBodyModel2;
  _i4.RestmailDeliverBodyModel? get restmailDeliverBodyModel;
}

class _RestmailDeliverBodyCopyWith<$Res>
    implements $$RestmailDeliverBodyCopyWith<$Res> {
  _RestmailDeliverBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RestmailDeliverBody _value;

  @_i3.override
  _i6.RestmailDeliverBodyModel3? get restmailDeliverBodyModel3 =>
      _value.restmailDeliverBodyModel3;

  @_i3.override
  _i5.RestmailDeliverBodyModel2? get restmailDeliverBodyModel2 =>
      _value.restmailDeliverBodyModel2;

  @_i3.override
  _i4.RestmailDeliverBodyModel? get restmailDeliverBodyModel =>
      _value.restmailDeliverBodyModel;

  @_i3.override
  $Res call({
    _i3.Object? restmailDeliverBodyModel3 = _sentinel,
    _i3.Object? restmailDeliverBodyModel2 = _sentinel,
    _i3.Object? restmailDeliverBodyModel = _sentinel,
  }) {
    return (RestmailDeliverBody(
      restmailDeliverBodyModel3:
          _i3.identical(restmailDeliverBodyModel3, _sentinel)
          ? this.restmailDeliverBodyModel3
          : (restmailDeliverBodyModel3 as _i6.RestmailDeliverBodyModel3?),
      restmailDeliverBodyModel2:
          _i3.identical(restmailDeliverBodyModel2, _sentinel)
          ? this.restmailDeliverBodyModel2
          : (restmailDeliverBodyModel2 as _i5.RestmailDeliverBodyModel2?),
      restmailDeliverBodyModel:
          _i3.identical(restmailDeliverBodyModel, _sentinel)
          ? this.restmailDeliverBodyModel
          : (restmailDeliverBodyModel as _i4.RestmailDeliverBodyModel?),
    ) as $Res);
  }
}
