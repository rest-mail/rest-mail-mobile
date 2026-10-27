// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/dkim_rotation_settings_previous_one_of_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/dkim_rotation_settings_staged_one_of_model.dart'
    as _i5;
import 'package:restmail_generated/src/model/dkim_rotation_settings_state_model.dart'
    as _i6;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DkimRotationSettings extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DkimRotationSettings({
    required this.domainId,
    required this.previous,
    required this.rotationIntervalDays,
    required this.staged,
    required this.state,
  });

  factory DkimRotationSettings.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DkimRotationSettings: contains complex types',
    );
  }

  factory DkimRotationSettings.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DkimRotationSettings');
    return DkimRotationSettings(
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'DkimRotationSettings.domain_id',
      ),
      previous: _$map[r'previous'] == null
          ? null
          : _i4.DkimRotationSettingsPreviousOneOfModel.fromJson(
              _$map[r'previous'],
            ),
      rotationIntervalDays: _$map[r'rotation_interval_days'].decodeJsonInt(
        context: r'DkimRotationSettings.rotation_interval_days',
      ),
      staged: _$map[r'staged'] == null
          ? null
          : _i5.DkimRotationSettingsStagedOneOfModel.fromJson(_$map[r'staged']),
      state: _i6.DkimRotationSettingsStateModel.fromJson(_$map[r'state']),
    );
  }

  factory DkimRotationSettings.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DkimRotationSettings: contains complex types',
    );
  }

  final _i3.int domainId;

  final _i4.DkimRotationSettingsPreviousOneOfModel previous;

  final _i3.int rotationIntervalDays;

  final _i5.DkimRotationSettingsStagedOneOfModel staged;

  final _i6.DkimRotationSettingsStateModel state;

  @_i3.override
  _i3.Object? toJson() => {
    r'domain_id': domainId,
    r'previous': previous?.toJson(),
    r'rotation_interval_days': rotationIntervalDays,
    r'staged': staged?.toJson(),
    r'state': state.toJson(),
  };

  $$DkimRotationSettingsCopyWith<DkimRotationSettings> get copyWith =>
      _DkimRotationSettingsCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DkimRotationSettings &&
        other.domainId == this.domainId &&
        other.previous == this.previous &&
        other.rotationIntervalDays == this.rotationIntervalDays &&
        other.staged == this.staged &&
        other.state == this.state;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      domainId,
      previous,
      rotationIntervalDays,
      staged,
      state,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DkimRotationSettings: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DkimRotationSettings: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DkimRotationSettingsCopyWith<$Res> {
  factory $$DkimRotationSettingsCopyWith(DkimRotationSettings value) =
      _DkimRotationSettingsCopyWith<$Res>;

  $Res call({
    _i3.int? domainId,
    _i4.DkimRotationSettingsPreviousOneOfModel? previous,
    _i3.int? rotationIntervalDays,
    _i5.DkimRotationSettingsStagedOneOfModel? staged,
    _i6.DkimRotationSettingsStateModel? state,
  });
  _i3.int get domainId;
  _i4.DkimRotationSettingsPreviousOneOfModel get previous;
  _i3.int get rotationIntervalDays;
  _i5.DkimRotationSettingsStagedOneOfModel get staged;
  _i6.DkimRotationSettingsStateModel get state;
}

class _DkimRotationSettingsCopyWith<$Res>
    implements $$DkimRotationSettingsCopyWith<$Res> {
  _DkimRotationSettingsCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DkimRotationSettings _value;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i4.DkimRotationSettingsPreviousOneOfModel get previous => _value.previous;

  @_i3.override
  _i3.int get rotationIntervalDays => _value.rotationIntervalDays;

  @_i3.override
  _i5.DkimRotationSettingsStagedOneOfModel get staged => _value.staged;

  @_i3.override
  _i6.DkimRotationSettingsStateModel get state => _value.state;

  @_i3.override
  $Res call({
    _i3.Object? domainId = _sentinel,
    _i3.Object? previous = _sentinel,
    _i3.Object? rotationIntervalDays = _sentinel,
    _i3.Object? staged = _sentinel,
    _i3.Object? state = _sentinel,
  }) {
    return (DkimRotationSettings(
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      previous: _i3.identical(previous, _sentinel)
          ? this.previous
          : (previous as _i4.DkimRotationSettingsPreviousOneOfModel),
      rotationIntervalDays: _i3.identical(rotationIntervalDays, _sentinel)
          ? this.rotationIntervalDays
          : (rotationIntervalDays as _i3.int),
      staged: _i3.identical(staged, _sentinel)
          ? this.staged
          : (staged as _i5.DkimRotationSettingsStagedOneOfModel),
      state: _i3.identical(state, _sentinel)
          ? this.state
          : (state as _i6.DkimRotationSettingsStateModel),
    ) as $Res);
  }
}
