// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetVacationBodyEnabledModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SetVacationBodyEnabledModel();

  factory SetVacationBodyEnabledModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return SetVacationBodyEnabledModel();
  }

  factory SetVacationBodyEnabledModel.fromJson(_i3.Object? json) {
    return SetVacationBodyEnabledModel();
  }

  factory SetVacationBodyEnabledModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return SetVacationBodyEnabledModel();
  }

  @_i3.override
  _i3.Object? toJson() => <_i3.String, _i3.Object?>{};

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationBodyEnabledModel;
  }

  @_i3.override
  _i3.int get hashCode => runtimeType.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    return <_i3.String, _i1.PropertyValue>{};
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SetVacationBodyEnabledModel: complex types cannot be URI-encoded',
    );
  }
}
