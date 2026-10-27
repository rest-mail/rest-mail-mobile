// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SieveValidation extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SieveValidation({required this.message, required this.valid});

  factory SieveValidation.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'message', r'valid'},
      listKeys: {},
      context: r'SieveValidation',
    );
    return SieveValidation(
      message: _$values[r'message'].decodeSimpleString(
        context: r'SieveValidation.message',
      ),
      valid: _$values[r'valid'].decodeSimpleBool(
        context: r'SieveValidation.valid',
      ),
    );
  }

  factory SieveValidation.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SieveValidation');
    return SieveValidation(
      message: _$map[r'message'].decodeJsonString(
        context: r'SieveValidation.message',
      ),
      valid: _$map[r'valid'].decodeJsonBool(context: r'SieveValidation.valid'),
    );
  }

  factory SieveValidation.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'message', r'valid'},
      listKeys: {},
      context: r'SieveValidation',
    );
    return SieveValidation(
      message: _$values[r'message'].decodeFormString(
        context: r'SieveValidation.message',
      ),
      valid: _$values[r'valid'].decodeFormBool(
        context: r'SieveValidation.valid',
      ),
    );
  }

  final _i3.String message;

  final _i3.bool valid;

  @_i3.override
  _i3.Object? toJson() => {r'message': message, r'valid': valid};

  $$SieveValidationCopyWith<SieveValidation> get copyWith =>
      _SieveValidationCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SieveValidation &&
        other.message == this.message &&
        other.valid == this.valid;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([message, valid]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'message'] = _i1.PropertyValue.scalar(message);
    _$result[r'valid'] = _i1.PropertyValue.scalar(valid.toString());
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
      r'Cannot uriEncode SieveValidation: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SieveValidationCopyWith<$Res> {
  factory $$SieveValidationCopyWith(SieveValidation value) =
      _SieveValidationCopyWith<$Res>;

  $Res call({_i3.String? message, _i3.bool? valid});
  _i3.String get message;
  _i3.bool get valid;
}

class _SieveValidationCopyWith<$Res>
    implements $$SieveValidationCopyWith<$Res> {
  _SieveValidationCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SieveValidation _value;

  @_i3.override
  _i3.String get message => _value.message;

  @_i3.override
  _i3.bool get valid => _value.valid;

  @_i3.override
  $Res call({_i3.Object? message = _sentinel, _i3.Object? valid = _sentinel}) {
    return (SieveValidation(
      message: _i3.identical(message, _sentinel)
          ? this.message
          : (message as _i3.String),
      valid: _i3.identical(valid, _sentinel) ? this.valid : (valid as _i3.bool),
    ) as $Res);
  }
}
