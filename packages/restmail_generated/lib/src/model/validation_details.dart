// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ValidationDetails extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ValidationDetails({required this.fields});

  factory ValidationDetails.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ValidationDetails: contains complex types',
    );
  }

  factory ValidationDetails.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ValidationDetails');
    return ValidationDetails(
      fields: _$map[r'fields'].decodeJsonMap(
        (v) => v.decodeJsonString(context: r'ValidationDetails.fields'),
        context: r'ValidationDetails.fields',
      ),
    );
  }

  factory ValidationDetails.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ValidationDetails: contains complex types',
    );
  }

  final _i3.Map<_i3.String, _i3.String> fields;

  @_i3.override
  _i3.Object? toJson() => {r'fields': fields};

  $$ValidationDetailsCopyWith<ValidationDetails> get copyWith =>
      _ValidationDetailsCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is ValidationDetails &&
        _$deepEquals.equals(other.fields, this.fields);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return deepEquals.hash(fields);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ValidationDetails: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ValidationDetails: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ValidationDetailsCopyWith<$Res> {
  factory $$ValidationDetailsCopyWith(ValidationDetails value) =
      _ValidationDetailsCopyWith<$Res>;

  $Res call({_i3.Map<_i3.String, _i3.String>? fields});
  _i3.Map<_i3.String, _i3.String> get fields;
}

class _ValidationDetailsCopyWith<$Res>
    implements $$ValidationDetailsCopyWith<$Res> {
  _ValidationDetailsCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ValidationDetails _value;

  @_i3.override
  _i3.Map<_i3.String, _i3.String> get fields => _value.fields;

  @_i3.override
  $Res call({_i3.Object? fields = _sentinel}) {
    return (ValidationDetails(
      fields: _i3.identical(fields, _sentinel)
          ? this.fields
          : (fields as _i3.Map<_i3.String, _i3.String>),
    ) as $Res);
  }
}
