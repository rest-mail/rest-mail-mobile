// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/deliver_message_body_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/deliver_message_body_model2.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DeliverMessageBody implements _i1.ParameterEncodable, _i1.UriEncodable {
  const DeliverMessageBody({
    this.deliverMessageBodyModel2,
    this.deliverMessageBodyModel,
  });

  factory DeliverMessageBody.fromJson(_i3.Object? json) {
    _i4.DeliverMessageBodyModel? deliverMessageBodyModel;

    try {
      deliverMessageBodyModel = _i4.DeliverMessageBodyModel.fromJson(json);
    } on _i3.Object catch (_) {
      deliverMessageBodyModel = null;
    }

    _i5.DeliverMessageBodyModel2? deliverMessageBodyModel2;

    try {
      deliverMessageBodyModel2 = _i5.DeliverMessageBodyModel2.fromJson(json);
    } on _i3.Object catch (_) {
      deliverMessageBodyModel2 = null;
    }

    if (deliverMessageBodyModel == null && deliverMessageBodyModel2 == null) {
      throw _i1.JsonDecodingException(
        r'Invalid JSON for DeliverMessageBody: all variants failed to decode',
      );
    }
    return DeliverMessageBody(
      deliverMessageBodyModel: deliverMessageBodyModel,
      deliverMessageBodyModel2: deliverMessageBodyModel2,
    );
  }

  factory DeliverMessageBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.DeliverMessageBodyModel? deliverMessageBodyModel;

    try {
      deliverMessageBodyModel = _i4.DeliverMessageBodyModel.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      deliverMessageBodyModel = null;
    }

    _i5.DeliverMessageBodyModel2? deliverMessageBodyModel2;

    try {
      deliverMessageBodyModel2 = _i5.DeliverMessageBodyModel2.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      deliverMessageBodyModel2 = null;
    }

    if (deliverMessageBodyModel == null && deliverMessageBodyModel2 == null) {
      throw _i1.SimpleDecodingException(
        r'Invalid simple value for DeliverMessageBody: all variants failed to decode',
      );
    }
    return DeliverMessageBody(
      deliverMessageBodyModel: deliverMessageBodyModel,
      deliverMessageBodyModel2: deliverMessageBodyModel2,
    );
  }

  factory DeliverMessageBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.DeliverMessageBodyModel? deliverMessageBodyModel;

    try {
      deliverMessageBodyModel = _i4.DeliverMessageBodyModel.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      deliverMessageBodyModel = null;
    }

    _i5.DeliverMessageBodyModel2? deliverMessageBodyModel2;

    try {
      deliverMessageBodyModel2 = _i5.DeliverMessageBodyModel2.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      deliverMessageBodyModel2 = null;
    }

    if (deliverMessageBodyModel == null && deliverMessageBodyModel2 == null) {
      throw _i1.FormDecodingException(
        r'Invalid form value for DeliverMessageBody: all variants failed to decode',
      );
    }
    return DeliverMessageBody(
      deliverMessageBodyModel: deliverMessageBodyModel,
      deliverMessageBodyModel2: deliverMessageBodyModel2,
    );
  }

  final _i5.DeliverMessageBodyModel2? deliverMessageBodyModel2;

  final _i4.DeliverMessageBodyModel? deliverMessageBodyModel;

  _i1.EncodingShape get currentEncodingShape {
    final _$shapes = <_i1.EncodingShape>{};
    if (deliverMessageBodyModel != null) {
      _$shapes.add(deliverMessageBodyModel!.currentEncodingShape);
    }
    if (deliverMessageBodyModel2 != null) {
      _$shapes.add(deliverMessageBodyModel2!.currentEncodingShape);
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
    if (deliverMessageBodyModel != null) {
      final _i3.Object? _$deliverMessageBodyModelJson = deliverMessageBodyModel!
          .toJson();
      if (_$deliverMessageBodyModelJson is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$deliverMessageBodyModelJson);
      } else {
        _$values.add(_$deliverMessageBodyModelJson);
      }
    }
    if (deliverMessageBodyModel2 != null) {
      final _i3.Object? _$deliverMessageBodyModel2Json =
          deliverMessageBodyModel2!.toJson();
      if (_$deliverMessageBodyModel2Json is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$deliverMessageBodyModel2Json);
      } else {
        _$values.add(_$deliverMessageBodyModel2Json);
      }
    }
    if (_$values.isEmpty && _$mapValues.isEmpty) return null;
    if (_$values.isNotEmpty && _$mapValues.isNotEmpty) {
      throw _i1.EncodingException(
        r'Mixed encoding not supported for DeliverMessageBody: cannot encode both simple and complex values',
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
    if (deliverMessageBodyModel != null) {
      _$mapValues.add(
        deliverMessageBodyModel!.parameterProperties(allowEmpty: allowEmpty),
      );
    }
    if (deliverMessageBodyModel2 != null) {
      _$mapValues.add(
        deliverMessageBodyModel2!.parameterProperties(allowEmpty: allowEmpty),
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
    if (deliverMessageBodyModel != null) {
      final _$deliverMessageBodyModelSimple = deliverMessageBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$deliverMessageBodyModelSimple);
    }
    if (deliverMessageBodyModel2 != null) {
      final _$deliverMessageBodyModel2Simple = deliverMessageBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$deliverMessageBodyModel2Simple);
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
    if (deliverMessageBodyModel != null) {
      final _$deliverMessageBodyModelForm = deliverMessageBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$deliverMessageBodyModelForm);
    }
    if (deliverMessageBodyModel2 != null) {
      final _$deliverMessageBodyModel2Form = deliverMessageBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$deliverMessageBodyModel2Form);
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
    if (deliverMessageBodyModel != null) {
      final _$deliverMessageBodyModelLabel = deliverMessageBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$deliverMessageBodyModelLabel);
    }
    if (deliverMessageBodyModel2 != null) {
      final _$deliverMessageBodyModel2Label = deliverMessageBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$deliverMessageBodyModel2Label);
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
    if (deliverMessageBodyModel != null) {
      final _$deliverMessageBodyModelMatrix = deliverMessageBodyModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$deliverMessageBodyModelMatrix);
    }
    if (deliverMessageBodyModel2 != null) {
      final _$deliverMessageBodyModel2Matrix = deliverMessageBodyModel2!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$deliverMessageBodyModel2Matrix);
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
    if (deliverMessageBodyModel != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode DeliverMessageBody: contains complex type',
      );
    }
    if (deliverMessageBodyModel2 != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode DeliverMessageBody: contains complex type',
      );
    }
    throw _i1.EncodingException(
      r'Cannot uriEncode DeliverMessageBody: no value set',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageBody &&
        other.deliverMessageBodyModel2 == this.deliverMessageBodyModel2 &&
        other.deliverMessageBodyModel == this.deliverMessageBodyModel;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      deliverMessageBodyModel2,
      deliverMessageBodyModel,
    ]);
  }

  $$DeliverMessageBodyCopyWith<DeliverMessageBody> get copyWith =>
      _DeliverMessageBodyCopyWith(this);
}

abstract class $$DeliverMessageBodyCopyWith<$Res> {
  factory $$DeliverMessageBodyCopyWith(DeliverMessageBody value) =
      _DeliverMessageBodyCopyWith<$Res>;

  $Res call({
    _i5.DeliverMessageBodyModel2? deliverMessageBodyModel2,
    _i4.DeliverMessageBodyModel? deliverMessageBodyModel,
  });
  _i5.DeliverMessageBodyModel2? get deliverMessageBodyModel2;
  _i4.DeliverMessageBodyModel? get deliverMessageBodyModel;
}

class _DeliverMessageBodyCopyWith<$Res>
    implements $$DeliverMessageBodyCopyWith<$Res> {
  _DeliverMessageBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DeliverMessageBody _value;

  @_i3.override
  _i5.DeliverMessageBodyModel2? get deliverMessageBodyModel2 =>
      _value.deliverMessageBodyModel2;

  @_i3.override
  _i4.DeliverMessageBodyModel? get deliverMessageBodyModel =>
      _value.deliverMessageBodyModel;

  @_i3.override
  $Res call({
    _i3.Object? deliverMessageBodyModel2 = _sentinel,
    _i3.Object? deliverMessageBodyModel = _sentinel,
  }) {
    return (DeliverMessageBody(
      deliverMessageBodyModel2:
          _i3.identical(deliverMessageBodyModel2, _sentinel)
          ? this.deliverMessageBodyModel2
          : (deliverMessageBodyModel2 as _i5.DeliverMessageBodyModel2?),
      deliverMessageBodyModel: _i3.identical(deliverMessageBodyModel, _sentinel)
          ? this.deliverMessageBodyModel
          : (deliverMessageBodyModel as _i4.DeliverMessageBodyModel?),
    ) as $Res);
  }
}
