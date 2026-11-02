// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/set_vacation_body_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/set_vacation_body_model2.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetVacationBody implements _i1.ParameterEncodable, _i1.UriEncodable {
  const SetVacationBody({
    this.setVacationBodyModel2,
    this.setVacationBodyModel,
  });

  factory SetVacationBody.fromJson(_i3.Object? json) {
    _i4.SetVacationBodyModel? setVacationBodyModel;

    try {
      setVacationBodyModel = _i4.SetVacationBodyModel.fromJson(json);
    } on _i3.Object catch (_) {
      setVacationBodyModel = null;
    }

    _i5.SetVacationBodyModel2? setVacationBodyModel2;

    try {
      setVacationBodyModel2 = _i5.SetVacationBodyModel2.fromJson(json);
    } on _i3.Object catch (_) {
      setVacationBodyModel2 = null;
    }

    if (setVacationBodyModel == null && setVacationBodyModel2 == null) {
      throw _i1.JsonDecodingException(
        r'Invalid JSON for SetVacationBody: all variants failed to decode',
      );
    }
    return SetVacationBody(
      setVacationBodyModel: setVacationBodyModel,
      setVacationBodyModel2: setVacationBodyModel2,
    );
  }

  factory SetVacationBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.SetVacationBodyModel? setVacationBodyModel;

    try {
      setVacationBodyModel = _i4.SetVacationBodyModel.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      setVacationBodyModel = null;
    }

    _i5.SetVacationBodyModel2? setVacationBodyModel2;

    try {
      setVacationBodyModel2 = _i5.SetVacationBodyModel2.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      setVacationBodyModel2 = null;
    }

    if (setVacationBodyModel == null && setVacationBodyModel2 == null) {
      throw _i1.SimpleDecodingException(
        r'Invalid simple value for SetVacationBody: all variants failed to decode',
      );
    }
    return SetVacationBody(
      setVacationBodyModel: setVacationBodyModel,
      setVacationBodyModel2: setVacationBodyModel2,
    );
  }

  factory SetVacationBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.SetVacationBodyModel? setVacationBodyModel;

    try {
      setVacationBodyModel = _i4.SetVacationBodyModel.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      setVacationBodyModel = null;
    }

    _i5.SetVacationBodyModel2? setVacationBodyModel2;

    try {
      setVacationBodyModel2 = _i5.SetVacationBodyModel2.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      setVacationBodyModel2 = null;
    }

    if (setVacationBodyModel == null && setVacationBodyModel2 == null) {
      throw _i1.FormDecodingException(
        r'Invalid form value for SetVacationBody: all variants failed to decode',
      );
    }
    return SetVacationBody(
      setVacationBodyModel: setVacationBodyModel,
      setVacationBodyModel2: setVacationBodyModel2,
    );
  }

  final _i5.SetVacationBodyModel2? setVacationBodyModel2;

  final _i4.SetVacationBodyModel? setVacationBodyModel;

  _i1.EncodingShape get currentEncodingShape {
    final _$shapes = <_i1.EncodingShape>{};
    if (setVacationBodyModel != null) {
      _$shapes.add(setVacationBodyModel!.currentEncodingShape);
    }
    if (setVacationBodyModel2 != null) {
      _$shapes.add(setVacationBodyModel2!.currentEncodingShape);
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
    if (setVacationBodyModel != null) {
      final _i3.Object? _$setVacationBodyModelJson = setVacationBodyModel!
          .toJson();
      if (_$setVacationBodyModelJson is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$setVacationBodyModelJson);
      } else {
        _$values.add(_$setVacationBodyModelJson);
      }
    }
    if (setVacationBodyModel2 != null) {
      final _i3.Object? _$setVacationBodyModel2Json = setVacationBodyModel2!
          .toJson();
      if (_$setVacationBodyModel2Json is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$setVacationBodyModel2Json);
      } else {
        _$values.add(_$setVacationBodyModel2Json);
      }
    }
    if (_$values.isEmpty && _$mapValues.isEmpty) return null;
    if (_$values.isNotEmpty && _$mapValues.isNotEmpty) {
      throw _i1.EncodingException(
        r'Mixed encoding not supported for SetVacationBody: cannot encode both simple and complex values',
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
    if (setVacationBodyModel != null) {
      _$mapValues.add(
        setVacationBodyModel!.parameterProperties(allowEmpty: allowEmpty),
      );
    }
    if (setVacationBodyModel2 != null) {
      _$mapValues.add(
        setVacationBodyModel2!.parameterProperties(allowEmpty: allowEmpty),
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
    if (setVacationBodyModel != null) {
      final _$setVacationBodyModelSimple = setVacationBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$setVacationBodyModelSimple);
    }
    if (setVacationBodyModel2 != null) {
      final _$setVacationBodyModel2Simple = setVacationBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$setVacationBodyModel2Simple);
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
    if (setVacationBodyModel != null) {
      final _$setVacationBodyModelForm = setVacationBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$setVacationBodyModelForm);
    }
    if (setVacationBodyModel2 != null) {
      final _$setVacationBodyModel2Form = setVacationBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$setVacationBodyModel2Form);
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
    if (setVacationBodyModel != null) {
      final _$setVacationBodyModelLabel = setVacationBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$setVacationBodyModelLabel);
    }
    if (setVacationBodyModel2 != null) {
      final _$setVacationBodyModel2Label = setVacationBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$setVacationBodyModel2Label);
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
    if (setVacationBodyModel != null) {
      final _$setVacationBodyModelMatrix = setVacationBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$setVacationBodyModelMatrix);
    }
    if (setVacationBodyModel2 != null) {
      final _$setVacationBodyModel2Matrix = setVacationBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$setVacationBodyModel2Matrix);
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
    if (setVacationBodyModel != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode SetVacationBody: contains complex type',
      );
    }
    if (setVacationBodyModel2 != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode SetVacationBody: contains complex type',
      );
    }
    throw _i1.EncodingException(
      r'Cannot uriEncode SetVacationBody: no value set',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationBody &&
        other.setVacationBodyModel2 == this.setVacationBodyModel2 &&
        other.setVacationBodyModel == this.setVacationBodyModel;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([setVacationBodyModel2, setVacationBodyModel]);
  }

  $$SetVacationBodyCopyWith<SetVacationBody> get copyWith =>
      _SetVacationBodyCopyWith(this);
}

abstract class $$SetVacationBodyCopyWith<$Res> {
  factory $$SetVacationBodyCopyWith(SetVacationBody value) =
      _SetVacationBodyCopyWith<$Res>;

  $Res call({
    _i5.SetVacationBodyModel2? setVacationBodyModel2,
    _i4.SetVacationBodyModel? setVacationBodyModel,
  });
  _i5.SetVacationBodyModel2? get setVacationBodyModel2;
  _i4.SetVacationBodyModel? get setVacationBodyModel;
}

class _SetVacationBodyCopyWith<$Res>
    implements $$SetVacationBodyCopyWith<$Res> {
  _SetVacationBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SetVacationBody _value;

  @_i3.override
  _i5.SetVacationBodyModel2? get setVacationBodyModel2 =>
      _value.setVacationBodyModel2;

  @_i3.override
  _i4.SetVacationBodyModel? get setVacationBodyModel =>
      _value.setVacationBodyModel;

  @_i3.override
  $Res call({
    _i3.Object? setVacationBodyModel2 = _sentinel,
    _i3.Object? setVacationBodyModel = _sentinel,
  }) {
    return (SetVacationBody(
      setVacationBodyModel2: _i3.identical(setVacationBodyModel2, _sentinel)
          ? this.setVacationBodyModel2
          : (setVacationBodyModel2 as _i5.SetVacationBodyModel2?),
      setVacationBodyModel: _i3.identical(setVacationBodyModel, _sentinel)
          ? this.setVacationBodyModel
          : (setVacationBodyModel as _i4.SetVacationBodyModel?),
    ) as $Res);
  }
}
