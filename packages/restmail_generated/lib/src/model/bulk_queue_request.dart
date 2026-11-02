// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/bulk_queue_request_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class BulkQueueRequest implements _i1.ParameterEncodable, _i1.UriEncodable {
  const BulkQueueRequest({this.bulkQueueRequestModel, this.object});

  factory BulkQueueRequest.fromJson(_i3.Object? json) {
    _i4.BulkQueueRequestModel? bulkQueueRequestModel;

    try {
      bulkQueueRequestModel = _i4.BulkQueueRequestModel.fromJson(json);
    } on _i3.Object catch (_) {
      bulkQueueRequestModel = null;
    }

    _i3.Object? object;
    if (bulkQueueRequestModel == null) {
      object = json;
    }
    if (bulkQueueRequestModel == null && object == null) {
      throw _i1.JsonDecodingException(
        r'Invalid JSON for BulkQueueRequest: all variants failed to decode',
      );
    }
    return BulkQueueRequest(
      object: object,
      bulkQueueRequestModel: bulkQueueRequestModel,
    );
  }

  factory BulkQueueRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.BulkQueueRequestModel? bulkQueueRequestModel;

    try {
      bulkQueueRequestModel = _i4.BulkQueueRequestModel.fromSimple(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      bulkQueueRequestModel = null;
    }

    if (bulkQueueRequestModel == null) {
      throw _i1.SimpleDecodingException(
        r'Invalid simple value for BulkQueueRequest: all variants failed to decode',
      );
    }
    return BulkQueueRequest(
      object: null,
      bulkQueueRequestModel: bulkQueueRequestModel,
    );
  }

  factory BulkQueueRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    _i4.BulkQueueRequestModel? bulkQueueRequestModel;

    try {
      bulkQueueRequestModel = _i4.BulkQueueRequestModel.fromForm(
        value,
        explode: explode,
      );
    } on _i3.Object catch (_) {
      bulkQueueRequestModel = null;
    }

    if (bulkQueueRequestModel == null) {
      throw _i1.FormDecodingException(
        r'Invalid form value for BulkQueueRequest: all variants failed to decode',
      );
    }
    return BulkQueueRequest(
      object: null,
      bulkQueueRequestModel: bulkQueueRequestModel,
    );
  }

  final _i4.BulkQueueRequestModel? bulkQueueRequestModel;

  final _i3.Object? object;

  _i1.EncodingShape get currentEncodingShape {
    final _$shapes = <_i1.EncodingShape>{};
    if (object != null) {
      throw _i1.EncodingException(
        r'AnyModel variant of BulkQueueRequest cannot determine encoding shape',
      );
    }
    if (bulkQueueRequestModel != null) {
      _$shapes.add(bulkQueueRequestModel!.currentEncodingShape);
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
    if (object != null) {
      final _i3.Object? _$objectJson = _i1.encodeUnknownJson(
        object!,
        context: r'BulkQueueRequest.Object',
      );
      if (_$objectJson is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$objectJson);
      } else {
        _$values.add(_$objectJson);
      }
    }
    if (bulkQueueRequestModel != null) {
      final _i3.Object? _$bulkQueueRequestModelJson = bulkQueueRequestModel!
          .toJson();
      if (_$bulkQueueRequestModelJson is _i3.Map<_i3.String, _i3.Object?>) {
        _$mapValues.add(_$bulkQueueRequestModelJson);
      } else {
        _$values.add(_$bulkQueueRequestModelJson);
      }
    }
    if (_$values.isEmpty && _$mapValues.isEmpty) return null;
    if (_$values.isNotEmpty && _$mapValues.isNotEmpty) {
      throw _i1.EncodingException(
        r'Mixed encoding not supported for BulkQueueRequest: cannot encode both simple and complex values',
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
    if (object != null) {
      throw _i1.EncodingException(
        r'AnyModel variant of BulkQueueRequest cannot be parameter encoded',
      );
    }
    if (bulkQueueRequestModel != null) {
      _$mapValues.add(
        bulkQueueRequestModel!.parameterProperties(allowEmpty: allowEmpty),
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
    final _$values = <_i3.String>{};
    final _$mapValues = <_i3.Map<_i3.String, _i1.PropertyValue>>[];
    if (object != null) {
      throw _i1.EncodingException(
        r'AnyModel variant of BulkQueueRequest cannot be simple-encoded',
      );
    }
    if (bulkQueueRequestModel != null) {
      final _$bulkQueueRequestModelSimple = bulkQueueRequestModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$bulkQueueRequestModelSimple);
    }
    if (_$values.isEmpty && _$mapValues.isEmpty) return '';
    if (_$mapValues.isNotEmpty && _$values.isNotEmpty) {
      throw _i1.EncodingException(
        r'Ambiguous anyOf simple encoding for BulkQueueRequest: mixing simple and complex values',
      );
    }
    if (_$values.isNotEmpty) {
      return _$values.first;
    } else {
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
    final _$entryLists = <_i3.List<_i1.ParameterEntry>>[];
    final _$values = <_i3.String>{};
    final _$mapValues = <_i3.Map<_i3.String, _i1.PropertyValue>>[];
    if (object != null) {
      throw _i1.EncodingException(
        r'AnyModel variant of BulkQueueRequest cannot be form-encoded',
      );
    }
    if (bulkQueueRequestModel != null) {
      final _$bulkQueueRequestModelForm = bulkQueueRequestModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$bulkQueueRequestModelForm);
    }
    if (_$values.isEmpty && _$mapValues.isEmpty) {
      return const <_i1.ParameterEntry>[];
    }
    if (_$mapValues.isNotEmpty && _$values.isNotEmpty) {
      throw _i1.EncodingException(
        r'Ambiguous anyOf form encoding for BulkQueueRequest: mixing simple and complex values',
      );
    }
    if (_$values.isNotEmpty) {
      return _$entryLists.first;
    } else {
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
  }

  @_i3.override
  _i3.String toLabel({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    final _$values = <_i3.String>{};
    final _$mapValues = <_i3.Map<_i3.String, _i1.PropertyValue>>[];
    if (object != null) {
      throw _i1.EncodingException(
        r'AnyModel variant of BulkQueueRequest cannot be label-encoded',
      );
    }
    if (bulkQueueRequestModel != null) {
      final _$bulkQueueRequestModelLabel = bulkQueueRequestModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$bulkQueueRequestModelLabel);
    }
    if (_$values.isEmpty && _$mapValues.isEmpty) return '';
    if (_$mapValues.isNotEmpty && _$values.isNotEmpty) {
      throw _i1.EncodingException(
        r'Ambiguous anyOf label encoding for BulkQueueRequest: mixing simple and complex values',
      );
    }
    if (_$values.isNotEmpty) {
      return _$values.first;
    } else {
      final _$map = <_i3.String, _i1.PropertyValue>{};
      for (final _$m in _$mapValues) {
        _$map.addAll(_$m);
      }
      return _$map.toLabel(explode: explode, allowEmpty: allowEmpty);
    }
  }

  @_i3.override
  _i3.String toMatrix(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    final _$values = <_i3.String>{};
    final _$mapValues = <_i3.Map<_i3.String, _i1.PropertyValue>>[];
    if (object != null) {
      throw _i1.EncodingException(
        r'AnyModel variant of BulkQueueRequest cannot be matrix-encoded',
      );
    }
    if (bulkQueueRequestModel != null) {
      final _$bulkQueueRequestModelMatrix = bulkQueueRequestModel!
          .parameterProperties(allowEmpty: allowEmpty);
      _$mapValues.add(_$bulkQueueRequestModelMatrix);
    }
    if (_$values.isEmpty && _$mapValues.isEmpty) return '';
    if (_$mapValues.isNotEmpty && _$values.isNotEmpty) {
      throw _i1.EncodingException(
        r'Ambiguous anyOf matrix encoding for BulkQueueRequest: mixing simple and complex values',
      );
    }
    if (_$values.isNotEmpty) {
      return _$values.first;
    } else {
      final _$map = <_i3.String, _i1.PropertyValue>{};
      for (final _$m in _$mapValues) {
        _$map.addAll(_$m);
      }
      return _$map.toMatrix(
        paramName,
        explode: explode,
        allowEmpty: allowEmpty,
      );
    }
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
    if (object != null) {
      throw _i1.EncodingException(
        r'AnyModel variant of BulkQueueRequest cannot be URI encoded',
      );
    }
    if (bulkQueueRequestModel != null) {
      throw _i1.EncodingException(
        r'Cannot uriEncode BulkQueueRequest: contains complex type',
      );
    }
    throw _i1.EncodingException(
      r'Cannot uriEncode BulkQueueRequest: no value set',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkQueueRequest &&
        other.bulkQueueRequestModel == this.bulkQueueRequestModel &&
        other.object == this.object;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([bulkQueueRequestModel, object]);
  }

  $$BulkQueueRequestCopyWith<BulkQueueRequest> get copyWith =>
      _BulkQueueRequestCopyWith(this);
}

abstract class $$BulkQueueRequestCopyWith<$Res> {
  factory $$BulkQueueRequestCopyWith(BulkQueueRequest value) =
      _BulkQueueRequestCopyWith<$Res>;

  $Res call({
    _i4.BulkQueueRequestModel? bulkQueueRequestModel,
    _i3.Object? object,
  });
  _i4.BulkQueueRequestModel? get bulkQueueRequestModel;
  _i3.Object? get object;
}

class _BulkQueueRequestCopyWith<$Res>
    implements $$BulkQueueRequestCopyWith<$Res> {
  _BulkQueueRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final BulkQueueRequest _value;

  @_i3.override
  _i4.BulkQueueRequestModel? get bulkQueueRequestModel =>
      _value.bulkQueueRequestModel;

  @_i3.override
  _i3.Object? get object => _value.object;

  @_i3.override
  $Res call({
    _i3.Object? bulkQueueRequestModel = _sentinel,
    _i3.Object? object = _sentinel,
  }) {
    return (BulkQueueRequest(
      bulkQueueRequestModel: _i3.identical(bulkQueueRequestModel, _sentinel)
          ? this.bulkQueueRequestModel
          : (bulkQueueRequestModel as _i4.BulkQueueRequestModel?),
      object: _i3.identical(object, _sentinel) ? this.object : object,
    ) as $Res);
  }
}
