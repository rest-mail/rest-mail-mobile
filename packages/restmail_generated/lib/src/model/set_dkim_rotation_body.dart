// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetDkimRotationBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SetDkimRotationBody({required this.rotationIntervalDays});

  factory SetDkimRotationBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'rotation_interval_days'},
      listKeys: {},
      context: r'SetDkimRotationBody',
    );
    return SetDkimRotationBody(
      rotationIntervalDays: _$values[r'rotation_interval_days'].decodeSimpleInt(
        context: r'SetDkimRotationBody.rotation_interval_days',
      ),
    );
  }

  factory SetDkimRotationBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SetDkimRotationBody');
    return SetDkimRotationBody(
      rotationIntervalDays: _$map[r'rotation_interval_days'].decodeJsonInt(
        context: r'SetDkimRotationBody.rotation_interval_days',
      ),
    );
  }

  factory SetDkimRotationBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'rotation_interval_days'},
      listKeys: {},
      context: r'SetDkimRotationBody',
    );
    return SetDkimRotationBody(
      rotationIntervalDays: _$values[r'rotation_interval_days'].decodeFormInt(
        context: r'SetDkimRotationBody.rotation_interval_days',
      ),
    );
  }

  final _i3.int rotationIntervalDays;

  @_i3.override
  _i3.Object? toJson() => {r'rotation_interval_days': rotationIntervalDays};

  $$SetDkimRotationBodyCopyWith<SetDkimRotationBody> get copyWith =>
      _SetDkimRotationBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimRotationBody &&
        other.rotationIntervalDays == this.rotationIntervalDays;
  }

  @_i3.override
  _i3.int get hashCode => rotationIntervalDays.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'rotation_interval_days'] = _i1.PropertyValue.scalar(
      rotationIntervalDays.toString(),
    );
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SetDkimRotationBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SetDkimRotationBodyCopyWith<$Res> {
  factory $$SetDkimRotationBodyCopyWith(SetDkimRotationBody value) =
      _SetDkimRotationBodyCopyWith<$Res>;

  $Res call({_i3.int? rotationIntervalDays});
  _i3.int get rotationIntervalDays;
}

class _SetDkimRotationBodyCopyWith<$Res>
    implements $$SetDkimRotationBodyCopyWith<$Res> {
  _SetDkimRotationBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SetDkimRotationBody _value;

  @_i3.override
  _i3.int get rotationIntervalDays => _value.rotationIntervalDays;

  @_i3.override
  $Res call({_i3.Object? rotationIntervalDays = _sentinel}) {
    return (SetDkimRotationBody(
      rotationIntervalDays: _i3.identical(rotationIntervalDays, _sentinel)
          ? this.rotationIntervalDays
          : (rotationIntervalDays as _i3.int),
    ) as $Res);
  }
}
