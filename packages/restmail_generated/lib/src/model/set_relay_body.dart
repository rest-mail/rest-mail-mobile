// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/set_relay_body_model.dart' as _i4;
import 'package:restmail_generated/src/model/set_relay_body_model2.dart' as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetRelayBody implements _i1.ParameterEncodable, _i1.UriEncodable {
  const SetRelayBody({this.setRelayBodyModel2, this.setRelayBodyModel});

  factory SetRelayBody.fromJson(_i3.Object? json) {
    _i4.SetRelayBodyModel? setRelayBodyModel;

    try {
      setRelayBodyModel = _i4.SetRelayBodyModel.fromJson(json);
    } on _i3.Object catch (_) {
      setRelayBodyModel = null;
    }

    _i5.SetRelayBodyModel2? setRelayBodyModel2;

    try {
      setRelayBodyModel2 = _i5.SetRelayBodyModel2.fromJson(json);
    } on _i3.Object catch (_) {
      setRelayBodyModel2 = null;
    }

    if (setRelayBodyModel == null && setRelayBodyModel2 == null) {
      throw _i1.JsonDecodingException(
        r'Invalid JSON for SetRelayBody: all variants failed to decode',
      );
    }
    return SetRelayBody(
      setRelayBodyModel: setRelayBodyModel,
      setRelayBodyModel2: setRelayBodyModel2,
    );
  }

  factory SetRelayBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.SetRelayBodyModel? setRelayBodyModel;

    try {
      setRelayBodyModel = _i4.SetRelayBodyModel.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      setRelayBodyModel = null;
    }

    _i5.SetRelayBodyModel2? setRelayBodyModel2;

    try {
      setRelayBodyModel2 = _i5.SetRelayBodyModel2.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      setRelayBodyModel2 = null;
    }

    if (setRelayBodyModel == null && setRelayBodyModel2 == null) {
      throw _i1.SimpleDecodingException(
        r'Invalid simple value for SetRelayBody: all variants failed to decode',
      );
    }
    return SetRelayBody(
      setRelayBodyModel: setRelayBodyModel,
      setRelayBodyModel2: setRelayBodyModel2,
    );
  }

  factory SetRelayBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.SetRelayBodyModel? setRelayBodyModel;

    try {
      setRelayBodyModel = _i4.SetRelayBodyModel.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      setRelayBodyModel = null;
    }

    _i5.SetRelayBodyModel2? setRelayBodyModel2;

    try {
      setRelayBodyModel2 = _i5.SetRelayBodyModel2.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      setRelayBodyModel2 = null;
    }

    if (setRelayBodyModel == null && setRelayBodyModel2 == null) {
      throw _i1.FormDecodingException(
        r'Invalid form value for SetRelayBody: all variants failed to decode',
      );
    }
    return SetRelayBody(
      setRelayBodyModel: setRelayBodyModel,
      setRelayBodyModel2: setRelayBodyModel2,
    );
  }

  final _i5.SetRelayBodyModel2? setRelayBodyModel2;

  final _i4.SetRelayBodyModel? setRelayBodyModel;

  _i1.EncodingShape get currentEncodingShape {
    final _$shapes = <_i1.EncodingShape>{};
    if (setRelayBodyModel != null) {
      _$shapes.add(setRelayBodyModel!.currentEncodingShape);
    }
    if (setRelayBodyModel2 != null) {
      _$shapes.add(setRelayBodyModel2!.currentEncodingShape);
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
    if (setRelayBodyModel != null) {
      final _i3.Object? _$setRelayBodyModelJson = setRelayBodyModel!.toJson();
      if (_$setRelayBodyModelJson is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$setRelayBodyModelJson);
      } else {
        _$values.add(_$setRelayBodyModelJson);
      }
    }
    if (setRelayBodyModel2 != null) {
      final _i3.Object? _$setRelayBodyModel2Json = setRelayBodyModel2!.toJson();
      if (_$setRelayBodyModel2Json is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$setRelayBodyModel2Json);
      } else {
        _$values.add(_$setRelayBodyModel2Json);
      }
    }
    if (_$values.isEmpty && _$mapValues.isEmpty) return null;
    if (_$values.isNotEmpty && _$mapValues.isNotEmpty) {
      throw _i1.EncodingException(
        r'Mixed encoding not supported for SetRelayBody: cannot encode both simple and complex values',
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
    if (setRelayBodyModel != null) {
      _$mapValues.add(
        setRelayBodyModel!.parameterProperties(allowEmpty: allowEmpty),
      );
    }
    if (setRelayBodyModel2 != null) {
      _$mapValues.add(
        setRelayBodyModel2!.parameterProperties(allowEmpty: allowEmpty),
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
    if (setRelayBodyModel != null) {
      final _$setRelayBodyModelSimple = setRelayBodyModel!.parameterProperties(
        allowEmpty: allowEmpty,
      );
      _$mapValues.add(_$setRelayBodyModelSimple);
    }
    if (setRelayBodyModel2 != null) {
      final _$setRelayBodyModel2Simple = setRelayBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$setRelayBodyModel2Simple);
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
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
    _i3.Map<_i3.String, _i1.FormFieldEncoding> fieldEncodings = const {},
  }) {
    final _$mapValues = <_i3.Map<_i3.String, _i1.PropertyValue>>[];
    if (setRelayBodyModel != null) {
      final _$setRelayBodyModelForm = setRelayBodyModel!.parameterProperties(
        allowEmpty: allowEmpty,
      );
      _$mapValues.add(_$setRelayBodyModelForm);
    }
    if (setRelayBodyModel2 != null) {
      final _$setRelayBodyModel2Form = setRelayBodyModel2!.parameterProperties(
        allowEmpty: allowEmpty,
      );
      _$mapValues.add(_$setRelayBodyModel2Form);
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
    if (setRelayBodyModel != null) {
      final _$setRelayBodyModelLabel = setRelayBodyModel!.parameterProperties(
        allowEmpty: allowEmpty,
      );
      _$mapValues.add(_$setRelayBodyModelLabel);
    }
    if (setRelayBodyModel2 != null) {
      final _$setRelayBodyModel2Label = setRelayBodyModel2!.parameterProperties(
        allowEmpty: allowEmpty,
      );
      _$mapValues.add(_$setRelayBodyModel2Label);
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
    if (setRelayBodyModel != null) {
      final _$setRelayBodyModelMatrix = setRelayBodyModel!.parameterProperties(
        allowEmpty: allowEmpty,
      );
      _$mapValues.add(_$setRelayBodyModelMatrix);
    }
    if (setRelayBodyModel2 != null) {
      final _$setRelayBodyModel2Matrix = setRelayBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$setRelayBodyModel2Matrix);
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
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    if (setRelayBodyModel != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode SetRelayBody: contains complex type',
      );
    }
    if (setRelayBodyModel2 != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode SetRelayBody: contains complex type',
      );
    }
    throw _i1.EncodingException(r'Cannot uriEncode SetRelayBody: no value set');
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetRelayBody &&
        other.setRelayBodyModel2 == this.setRelayBodyModel2 &&
        other.setRelayBodyModel == this.setRelayBodyModel;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([setRelayBodyModel2, setRelayBodyModel]);
  }

  $$SetRelayBodyCopyWith<SetRelayBody> get copyWith =>
      _SetRelayBodyCopyWith(this);
}

abstract class $$SetRelayBodyCopyWith<$Res> {
  factory $$SetRelayBodyCopyWith(SetRelayBody value) =
      _SetRelayBodyCopyWith<$Res>;

  $Res call({
    _i5.SetRelayBodyModel2? setRelayBodyModel2,
    _i4.SetRelayBodyModel? setRelayBodyModel,
  });
  _i5.SetRelayBodyModel2? get setRelayBodyModel2;
  _i4.SetRelayBodyModel? get setRelayBodyModel;
}

class _SetRelayBodyCopyWith<$Res> implements $$SetRelayBodyCopyWith<$Res> {
  _SetRelayBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SetRelayBody _value;

  @_i3.override
  _i5.SetRelayBodyModel2? get setRelayBodyModel2 => _value.setRelayBodyModel2;

  @_i3.override
  _i4.SetRelayBodyModel? get setRelayBodyModel => _value.setRelayBodyModel;

  @_i3.override
  $Res call({
    _i3.Object? setRelayBodyModel2 = _sentinel,
    _i3.Object? setRelayBodyModel = _sentinel,
  }) {
    return (SetRelayBody(
      setRelayBodyModel2: _i3.identical(setRelayBodyModel2, _sentinel)
          ? this.setRelayBodyModel2
          : (setRelayBodyModel2 as _i5.SetRelayBodyModel2?),
      setRelayBodyModel: _i3.identical(setRelayBodyModel, _sentinel)
          ? this.setRelayBodyModel
          : (setRelayBodyModel as _i4.SetRelayBodyModel?),
    ) as $Res);
  }
}
