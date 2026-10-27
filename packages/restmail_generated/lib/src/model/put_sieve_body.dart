// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PutSieveBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PutSieveBody({required this.script, this.active});

  factory PutSieveBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'active', r'script'},
      listKeys: {},
      context: r'PutSieveBody',
    );
    return PutSieveBody(
      active: _$values[r'active'].decodeSimpleNullableBool(
        context: r'PutSieveBody.active',
      ),
      script: _$values[r'script'].decodeSimpleNullableString(
        context: r'PutSieveBody.script',
      ),
    );
  }

  factory PutSieveBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'PutSieveBody');
    return PutSieveBody(
      active: _$map[r'active'].decodeJsonNullableBool(
        context: r'PutSieveBody.active',
      ),
      script: _$map[r'script'].decodeJsonNullableString(
        context: r'PutSieveBody.script',
      ),
    );
  }

  factory PutSieveBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'active', r'script'},
      listKeys: {},
      context: r'PutSieveBody',
    );
    return PutSieveBody(
      active: _$values[r'active'].decodeFormNullableBool(
        context: r'PutSieveBody.active',
      ),
      script: _$values[r'script'].decodeFormNullableString(
        context: r'PutSieveBody.script',
      ),
    );
  }

  final _i3.bool? active;

  final _i3.String? script;

  @_i3.override
  _i3.Object? toJson() => {r'active': active, r'script': script};

  $$PutSieveBodyCopyWith<PutSieveBody> get copyWith =>
      _PutSieveBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PutSieveBody &&
        other.active == this.active &&
        other.script == this.script;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([active, script]);
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
      r'Cannot uriEncode PutSieveBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$PutSieveBodyCopyWith<$Res> {
  factory $$PutSieveBodyCopyWith(PutSieveBody value) =
      _PutSieveBodyCopyWith<$Res>;

  $Res call({_i3.bool? active, _i3.String? script});
  _i3.bool? get active;
  _i3.String? get script;
}

class _PutSieveBodyCopyWith<$Res> implements $$PutSieveBodyCopyWith<$Res> {
  _PutSieveBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final PutSieveBody _value;

  @_i3.override
  _i3.bool? get active => _value.active;

  @_i3.override
  _i3.String? get script => _value.script;

  @_i3.override
  $Res call({_i3.Object? active = _sentinel, _i3.Object? script = _sentinel}) {
    return (PutSieveBody(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool?),
      script: _i3.identical(script, _sentinel)
          ? this.script
          : (script as _i3.String?),
    ) as $Res);
  }
}
