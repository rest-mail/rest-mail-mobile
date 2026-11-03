// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/quiet_hours_body_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/quiet_hours_body_model2.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class QuietHoursBody implements _i1.ParameterEncodable, _i1.UriEncodable {
  const QuietHoursBody({this.quietHoursBodyModel, this.quietHoursBodyModel2});

  factory QuietHoursBody.fromJson(_i3.Object? json) {
    _i4.QuietHoursBodyModel? quietHoursBodyModel;

    try {
      quietHoursBodyModel = _i4.QuietHoursBodyModel.fromJson(json);
    } on _i3.Object catch (_) {
      quietHoursBodyModel = null;
    }

    _i5.QuietHoursBodyModel2? quietHoursBodyModel2;

    try {
      quietHoursBodyModel2 = _i5.QuietHoursBodyModel2.fromJson(json);
    } on _i3.Object catch (_) {
      quietHoursBodyModel2 = null;
    }

    if (quietHoursBodyModel == null && quietHoursBodyModel2 == null) {
      throw _i1.JsonDecodingException(
        r'Invalid JSON for QuietHoursBody: all variants failed to decode',
      );
    }
    return QuietHoursBody(
      quietHoursBodyModel: quietHoursBodyModel,
      quietHoursBodyModel2: quietHoursBodyModel2,
    );
  }

  factory QuietHoursBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.QuietHoursBodyModel? quietHoursBodyModel;

    try {
      quietHoursBodyModel = _i4.QuietHoursBodyModel.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      quietHoursBodyModel = null;
    }

    _i5.QuietHoursBodyModel2? quietHoursBodyModel2;

    try {
      quietHoursBodyModel2 = _i5.QuietHoursBodyModel2.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      quietHoursBodyModel2 = null;
    }

    if (quietHoursBodyModel == null && quietHoursBodyModel2 == null) {
      throw _i1.SimpleDecodingException(
        r'Invalid simple value for QuietHoursBody: all variants failed to decode',
      );
    }
    return QuietHoursBody(
      quietHoursBodyModel: quietHoursBodyModel,
      quietHoursBodyModel2: quietHoursBodyModel2,
    );
  }

  factory QuietHoursBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.QuietHoursBodyModel? quietHoursBodyModel;

    try {
      quietHoursBodyModel = _i4.QuietHoursBodyModel.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      quietHoursBodyModel = null;
    }

    _i5.QuietHoursBodyModel2? quietHoursBodyModel2;

    try {
      quietHoursBodyModel2 = _i5.QuietHoursBodyModel2.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      quietHoursBodyModel2 = null;
    }

    if (quietHoursBodyModel == null && quietHoursBodyModel2 == null) {
      throw _i1.FormDecodingException(
        r'Invalid form value for QuietHoursBody: all variants failed to decode',
      );
    }
    return QuietHoursBody(
      quietHoursBodyModel: quietHoursBodyModel,
      quietHoursBodyModel2: quietHoursBodyModel2,
    );
  }

  final _i4.QuietHoursBodyModel? quietHoursBodyModel;

  final _i5.QuietHoursBodyModel2? quietHoursBodyModel2;

  _i1.EncodingShape get currentEncodingShape {
    final _$shapes = <_i1.EncodingShape>{};
    if (quietHoursBodyModel != null) {
      _$shapes.add(quietHoursBodyModel!.currentEncodingShape);
    }
    if (quietHoursBodyModel2 != null) {
      _$shapes.add(quietHoursBodyModel2!.currentEncodingShape);
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
    if (quietHoursBodyModel != null) {
      final _i3.Object? _$quietHoursBodyModelJson = quietHoursBodyModel!
          .toJson();
      if (_$quietHoursBodyModelJson is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$quietHoursBodyModelJson);
      } else {
        _$values.add(_$quietHoursBodyModelJson);
      }
    }
    if (quietHoursBodyModel2 != null) {
      final _i3.Object? _$quietHoursBodyModel2Json = quietHoursBodyModel2!
          .toJson();
      if (_$quietHoursBodyModel2Json is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$quietHoursBodyModel2Json);
      } else {
        _$values.add(_$quietHoursBodyModel2Json);
      }
    }
    if (_$values.isEmpty && _$mapValues.isEmpty) return null;
    if (_$values.isNotEmpty && _$mapValues.isNotEmpty) {
      throw _i1.EncodingException(
        r'Mixed encoding not supported for QuietHoursBody: cannot encode both simple and complex values',
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
    if (quietHoursBodyModel != null) {
      _$mapValues.add(
        quietHoursBodyModel!.parameterProperties(allowEmpty: allowEmpty),
      );
    }
    if (quietHoursBodyModel2 != null) {
      _$mapValues.add(
        quietHoursBodyModel2!.parameterProperties(allowEmpty: allowEmpty),
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
    if (quietHoursBodyModel != null) {
      final _$quietHoursBodyModelSimple = quietHoursBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$quietHoursBodyModelSimple);
    }
    if (quietHoursBodyModel2 != null) {
      final _$quietHoursBodyModel2Simple = quietHoursBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$quietHoursBodyModel2Simple);
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
    if (quietHoursBodyModel != null) {
      final _$quietHoursBodyModelForm = quietHoursBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$quietHoursBodyModelForm);
    }
    if (quietHoursBodyModel2 != null) {
      final _$quietHoursBodyModel2Form = quietHoursBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$quietHoursBodyModel2Form);
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
    if (quietHoursBodyModel != null) {
      final _$quietHoursBodyModelLabel = quietHoursBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$quietHoursBodyModelLabel);
    }
    if (quietHoursBodyModel2 != null) {
      final _$quietHoursBodyModel2Label = quietHoursBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$quietHoursBodyModel2Label);
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
    if (quietHoursBodyModel != null) {
      final _$quietHoursBodyModelMatrix = quietHoursBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$quietHoursBodyModelMatrix);
    }
    if (quietHoursBodyModel2 != null) {
      final _$quietHoursBodyModel2Matrix = quietHoursBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$quietHoursBodyModel2Matrix);
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
    if (quietHoursBodyModel != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode QuietHoursBody: contains complex type',
      );
    }
    if (quietHoursBodyModel2 != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode QuietHoursBody: contains complex type',
      );
    }
    throw _i1.EncodingException(
      r'Cannot uriEncode QuietHoursBody: no value set',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is QuietHoursBody &&
        other.quietHoursBodyModel == this.quietHoursBodyModel &&
        other.quietHoursBodyModel2 == this.quietHoursBodyModel2;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([quietHoursBodyModel, quietHoursBodyModel2]);
  }

  $$QuietHoursBodyCopyWith<QuietHoursBody> get copyWith =>
      _QuietHoursBodyCopyWith(this);
}

abstract class $$QuietHoursBodyCopyWith<$Res> {
  factory $$QuietHoursBodyCopyWith(QuietHoursBody value) =
      _QuietHoursBodyCopyWith<$Res>;

  $Res call({
    _i4.QuietHoursBodyModel? quietHoursBodyModel,
    _i5.QuietHoursBodyModel2? quietHoursBodyModel2,
  });
  _i4.QuietHoursBodyModel? get quietHoursBodyModel;
  _i5.QuietHoursBodyModel2? get quietHoursBodyModel2;
}

class _QuietHoursBodyCopyWith<$Res> implements $$QuietHoursBodyCopyWith<$Res> {
  _QuietHoursBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final QuietHoursBody _value;

  @_i3.override
  _i4.QuietHoursBodyModel? get quietHoursBodyModel =>
      _value.quietHoursBodyModel;

  @_i3.override
  _i5.QuietHoursBodyModel2? get quietHoursBodyModel2 =>
      _value.quietHoursBodyModel2;

  @_i3.override
  $Res call({
    _i3.Object? quietHoursBodyModel = _sentinel,
    _i3.Object? quietHoursBodyModel2 = _sentinel,
  }) {
    return (QuietHoursBody(
      quietHoursBodyModel: _i3.identical(quietHoursBodyModel, _sentinel)
          ? this.quietHoursBodyModel
          : (quietHoursBodyModel as _i4.QuietHoursBodyModel?),
      quietHoursBodyModel2: _i3.identical(quietHoursBodyModel2, _sentinel)
          ? this.quietHoursBodyModel2
          : (quietHoursBodyModel2 as _i5.QuietHoursBodyModel2?),
    ) as $Res);
  }
}
