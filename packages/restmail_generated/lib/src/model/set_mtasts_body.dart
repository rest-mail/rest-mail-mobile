// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/set_mtasts_body_mode_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetMtastsBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SetMtastsBody({this.active, this.maxAge, this.mode, this.mxHosts});

  factory SetMtastsBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'active', r'max_age', r'mode', r'mx_hosts'},
      listKeys: {},
      context: r'SetMtastsBody',
    );
    return SetMtastsBody(
      active: _$values[r'active'].decodeSimpleNullableBool(
        context: r'SetMtastsBody.active',
      ),
      maxAge: _$values[r'max_age'].decodeSimpleNullableInt(
        context: r'SetMtastsBody.max_age',
      ),
      mode: _$values[r'mode'] == null
          ? null
          : _i4.SetMtastsBodyModeModel.fromSimple(
              _$values[r'mode'],
              explode: explode,
            ),
      mxHosts: _$values[r'mx_hosts'].decodeSimpleNullableString(
        context: r'SetMtastsBody.mx_hosts',
      ),
    );
  }

  factory SetMtastsBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SetMtastsBody');
    return SetMtastsBody(
      active: _$map[r'active'].decodeJsonNullableBool(
        context: r'SetMtastsBody.active',
      ),
      maxAge: _$map[r'max_age'].decodeJsonNullableInt(
        context: r'SetMtastsBody.max_age',
      ),
      mode: _$map[r'mode'] == null
          ? null
          : _i4.SetMtastsBodyModeModel.fromJson(_$map[r'mode']),
      mxHosts: _$map[r'mx_hosts'].decodeJsonNullableString(
        context: r'SetMtastsBody.mx_hosts',
      ),
    );
  }

  factory SetMtastsBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'active', r'max_age', r'mode', r'mx_hosts'},
      listKeys: {},
      context: r'SetMtastsBody',
    );
    return SetMtastsBody(
      active: _$values[r'active'].decodeFormNullableBool(
        context: r'SetMtastsBody.active',
      ),
      maxAge: _$values[r'max_age'].decodeFormNullableInt(
        context: r'SetMtastsBody.max_age',
      ),
      mode: _$values[r'mode'] == null
          ? null
          : _i4.SetMtastsBodyModeModel.fromForm(
              _$values[r'mode'],
              explode: explode,
            ),
      mxHosts: _$values[r'mx_hosts'].decodeFormNullableString(
        context: r'SetMtastsBody.mx_hosts',
      ),
    );
  }

  final _i3.bool? active;

  final _i3.int? maxAge;

  final _i4.SetMtastsBodyModeModel? mode;

  final _i3.String? mxHosts;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    r'max_age': maxAge,
    if (mode != null) r'mode': mode?.toJson(),
    if (mxHosts != null) r'mx_hosts': mxHosts,
  };

  $$SetMtastsBodyCopyWith<SetMtastsBody> get copyWith =>
      _SetMtastsBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetMtastsBody &&
        other.active == this.active &&
        other.maxAge == this.maxAge &&
        other.mode == this.mode &&
        other.mxHosts == this.mxHosts;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([active, maxAge, mode, mxHosts]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (active != null) {
      _$result[r'active'] = _i1.PropertyValue.scalar(active!.toString());
    }
    if (maxAge != null) {
      _$result[r'max_age'] = _i1.PropertyValue.scalar(maxAge!.toString());
    }
    if (mode != null) {
      _$result[r'mode'] = _i1.PropertyValue.scalar(mode!.toJson());
    }
    if (mxHosts != null) {
      _$result[r'mx_hosts'] = _i1.PropertyValue.scalar(mxHosts!);
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SetMtastsBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SetMtastsBodyCopyWith<$Res> {
  factory $$SetMtastsBodyCopyWith(SetMtastsBody value) =
      _SetMtastsBodyCopyWith<$Res>;

  $Res call({
    _i3.bool? active,
    _i3.int? maxAge,
    _i4.SetMtastsBodyModeModel? mode,
    _i3.String? mxHosts,
  });
  _i3.bool? get active;
  _i3.int? get maxAge;
  _i4.SetMtastsBodyModeModel? get mode;
  _i3.String? get mxHosts;
}

class _SetMtastsBodyCopyWith<$Res> implements $$SetMtastsBodyCopyWith<$Res> {
  _SetMtastsBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SetMtastsBody _value;

  @_i3.override
  _i3.bool? get active => _value.active;

  @_i3.override
  _i3.int? get maxAge => _value.maxAge;

  @_i3.override
  _i4.SetMtastsBodyModeModel? get mode => _value.mode;

  @_i3.override
  _i3.String? get mxHosts => _value.mxHosts;

  @_i3.override
  $Res call({
    _i3.Object? active = _sentinel,
    _i3.Object? maxAge = _sentinel,
    _i3.Object? mode = _sentinel,
    _i3.Object? mxHosts = _sentinel,
  }) {
    return (SetMtastsBody(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool?),
      maxAge: _i3.identical(maxAge, _sentinel)
          ? this.maxAge
          : (maxAge as _i3.int?),
      mode: _i3.identical(mode, _sentinel)
          ? this.mode
          : (mode as _i4.SetMtastsBodyModeModel?),
      mxHosts: _i3.identical(mxHosts, _sentinel)
          ? this.mxHosts
          : (mxHosts as _i3.String?),
    ) as $Res);
  }
}
