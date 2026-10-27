// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/script_validation_dry_run_one_of_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ScriptValidation extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ScriptValidation({this.dryRun, this.error, this.phase, this.valid});

  factory ScriptValidation.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ScriptValidation: contains complex types',
    );
  }

  factory ScriptValidation.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ScriptValidation');
    return ScriptValidation(
      dryRun: _$map[r'dry_run'] == null
          ? null
          : _i4.ScriptValidationDryRunOneOfModel.fromJson(_$map[r'dry_run']),
      error: _$map[r'error'].decodeJsonNullableString(
        context: r'ScriptValidation.error',
      ),
      phase: _$map[r'phase'].decodeJsonNullableString(
        context: r'ScriptValidation.phase',
      ),
      valid: _$map[r'valid'].decodeJsonNullableBool(
        context: r'ScriptValidation.valid',
      ),
    );
  }

  factory ScriptValidation.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ScriptValidation: contains complex types',
    );
  }

  final _i4.ScriptValidationDryRunOneOfModel? dryRun;

  final _i3.String? error;

  final _i3.String? phase;

  final _i3.bool? valid;

  @_i3.override
  _i3.Object? toJson() => {
    if (dryRun != null) r'dry_run': dryRun?.toJson(),
    if (error != null) r'error': error,
    if (phase != null) r'phase': phase,
    if (valid != null) r'valid': valid,
  };

  $$ScriptValidationCopyWith<ScriptValidation> get copyWith =>
      _ScriptValidationCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ScriptValidation &&
        other.dryRun == this.dryRun &&
        other.error == this.error &&
        other.phase == this.phase &&
        other.valid == this.valid;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([dryRun, error, phase, valid]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ScriptValidation: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ScriptValidation: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ScriptValidationCopyWith<$Res> {
  factory $$ScriptValidationCopyWith(ScriptValidation value) =
      _ScriptValidationCopyWith<$Res>;

  $Res call({
    _i4.ScriptValidationDryRunOneOfModel? dryRun,
    _i3.String? error,
    _i3.String? phase,
    _i3.bool? valid,
  });
  _i4.ScriptValidationDryRunOneOfModel? get dryRun;
  _i3.String? get error;
  _i3.String? get phase;
  _i3.bool? get valid;
}

class _ScriptValidationCopyWith<$Res>
    implements $$ScriptValidationCopyWith<$Res> {
  _ScriptValidationCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ScriptValidation _value;

  @_i3.override
  _i4.ScriptValidationDryRunOneOfModel? get dryRun => _value.dryRun;

  @_i3.override
  _i3.String? get error => _value.error;

  @_i3.override
  _i3.String? get phase => _value.phase;

  @_i3.override
  _i3.bool? get valid => _value.valid;

  @_i3.override
  $Res call({
    _i3.Object? dryRun = _sentinel,
    _i3.Object? error = _sentinel,
    _i3.Object? phase = _sentinel,
    _i3.Object? valid = _sentinel,
  }) {
    return (ScriptValidation(
      dryRun: _i3.identical(dryRun, _sentinel)
          ? this.dryRun
          : (dryRun as _i4.ScriptValidationDryRunOneOfModel?),
      error: _i3.identical(error, _sentinel)
          ? this.error
          : (error as _i3.String?),
      phase: _i3.identical(phase, _sentinel)
          ? this.phase
          : (phase as _i3.String?),
      valid: _i3.identical(valid, _sentinel)
          ? this.valid
          : (valid as _i3.bool?),
    ) as $Res);
  }
}
