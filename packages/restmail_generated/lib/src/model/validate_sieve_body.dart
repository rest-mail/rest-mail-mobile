// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ValidateSieveBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ValidateSieveBody({required this.script});

  factory ValidateSieveBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'script'},
      listKeys: {},
      context: r'ValidateSieveBody',
    );
    return ValidateSieveBody(
      script: _$values[r'script'].decodeSimpleNullableString(
        context: r'ValidateSieveBody.script',
      ),
    );
  }

  factory ValidateSieveBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ValidateSieveBody');
    return ValidateSieveBody(
      script: _$map[r'script'].decodeJsonNullableString(
        context: r'ValidateSieveBody.script',
      ),
    );
  }

  factory ValidateSieveBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'script'},
      listKeys: {},
      context: r'ValidateSieveBody',
    );
    return ValidateSieveBody(
      script: _$values[r'script'].decodeFormNullableString(
        context: r'ValidateSieveBody.script',
      ),
    );
  }

  final _i3.String? script;

  @_i3.override
  _i3.Object? toJson() => {r'script': script};

  $$ValidateSieveBodyCopyWith<ValidateSieveBody> get copyWith =>
      _ValidateSieveBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateSieveBody && other.script == this.script;
  }

  @_i3.override
  _i3.int get hashCode => script.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (script != null) {
      _$result[r'script'] = _i1.PropertyValue.scalar(script!);
    }
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
      r'Cannot uriEncode ValidateSieveBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ValidateSieveBodyCopyWith<$Res> {
  factory $$ValidateSieveBodyCopyWith(ValidateSieveBody value) =
      _ValidateSieveBodyCopyWith<$Res>;

  $Res call({_i3.String? script});
  _i3.String? get script;
}

class _ValidateSieveBodyCopyWith<$Res>
    implements $$ValidateSieveBodyCopyWith<$Res> {
  _ValidateSieveBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ValidateSieveBody _value;

  @_i3.override
  _i3.String? get script => _value.script;

  @_i3.override
  $Res call({_i3.Object? script = _sentinel}) {
    return (ValidateSieveBody(
      script: _i3.identical(script, _sentinel)
          ? this.script
          : (script as _i3.String?),
    ) as $Res);
  }
}
