// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/set_vacation_body_enabled_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetVacationBodyModel2 extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SetVacationBodyModel2({this.enabled});

  factory SetVacationBodyModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for SetVacationBodyModel2: contains complex types',
    );
  }

  factory SetVacationBodyModel2.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SetVacationBodyModel2');
    return SetVacationBodyModel2(
      enabled: _$map[r'enabled'] == null
          ? null
          : _i4.SetVacationBodyEnabledModel.fromJson(_$map[r'enabled']),
    );
  }

  factory SetVacationBodyModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for SetVacationBodyModel2: contains complex types',
    );
  }

  final _i4.SetVacationBodyEnabledModel? enabled;

  @_i3.override
  _i3.Object? toJson() => {if (enabled != null) r'enabled': enabled?.toJson()};

  $$SetVacationBodyModel2CopyWith<SetVacationBodyModel2> get copyWith =>
      _SetVacationBodyModel2CopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationBodyModel2 && other.enabled == this.enabled;
  }

  @_i3.override
  _i3.int get hashCode => enabled.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for SetVacationBodyModel2: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SetVacationBodyModel2: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SetVacationBodyModel2CopyWith<$Res> {
  factory $$SetVacationBodyModel2CopyWith(SetVacationBodyModel2 value) =
      _SetVacationBodyModel2CopyWith<$Res>;

  $Res call({_i4.SetVacationBodyEnabledModel? enabled});
  _i4.SetVacationBodyEnabledModel? get enabled;
}

class _SetVacationBodyModel2CopyWith<$Res>
    implements $$SetVacationBodyModel2CopyWith<$Res> {
  _SetVacationBodyModel2CopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SetVacationBodyModel2 _value;

  @_i3.override
  _i4.SetVacationBodyEnabledModel? get enabled => _value.enabled;

  @_i3.override
  $Res call({_i3.Object? enabled = _sentinel}) {
    return (SetVacationBodyModel2(
      enabled: _i3.identical(enabled, _sentinel)
          ? this.enabled
          : (enabled as _i4.SetVacationBodyEnabledModel?),
    ) as $Res);
  }
}
