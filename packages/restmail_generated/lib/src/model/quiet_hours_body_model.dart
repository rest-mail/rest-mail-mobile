// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/quiet_hours_body_enabled_model2.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class QuietHoursBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const QuietHoursBodyModel({this.enabled});

  factory QuietHoursBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for QuietHoursBodyModel: contains complex types',
    );
  }

  factory QuietHoursBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'QuietHoursBodyModel');
    return QuietHoursBodyModel(
      enabled: _$map[r'enabled'] == null
          ? null
          : _i4.QuietHoursBodyEnabledModel2.fromJson(_$map[r'enabled']),
    );
  }

  factory QuietHoursBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for QuietHoursBodyModel: contains complex types',
    );
  }

  final _i4.QuietHoursBodyEnabledModel2? enabled;

  @_i3.override
  _i3.Object? toJson() => {if (enabled != null) r'enabled': enabled?.toJson()};

  $$QuietHoursBodyModelCopyWith<QuietHoursBodyModel> get copyWith =>
      _QuietHoursBodyModelCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is QuietHoursBodyModel && other.enabled == this.enabled;
  }

  @_i3.override
  _i3.int get hashCode => enabled.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for QuietHoursBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode QuietHoursBodyModel: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$QuietHoursBodyModelCopyWith<$Res> {
  factory $$QuietHoursBodyModelCopyWith(QuietHoursBodyModel value) =
      _QuietHoursBodyModelCopyWith<$Res>;

  $Res call({_i4.QuietHoursBodyEnabledModel2? enabled});
  _i4.QuietHoursBodyEnabledModel2? get enabled;
}

class _QuietHoursBodyModelCopyWith<$Res>
    implements $$QuietHoursBodyModelCopyWith<$Res> {
  _QuietHoursBodyModelCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final QuietHoursBodyModel _value;

  @_i3.override
  _i4.QuietHoursBodyEnabledModel2? get enabled => _value.enabled;

  @_i3.override
  $Res call({_i3.Object? enabled = _sentinel}) {
    return (QuietHoursBodyModel(
      enabled: _i3.identical(enabled, _sentinel)
          ? this.enabled
          : (enabled as _i4.QuietHoursBodyEnabledModel2?),
    ) as $Res);
  }
}
