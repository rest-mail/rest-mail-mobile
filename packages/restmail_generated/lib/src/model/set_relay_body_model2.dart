// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/set_relay_body_transport_model2.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetRelayBodyModel2 extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SetRelayBodyModel2({this.transport});

  factory SetRelayBodyModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for SetRelayBodyModel2: contains complex types',
    );
  }

  factory SetRelayBodyModel2.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SetRelayBodyModel2');
    return SetRelayBodyModel2(
      transport: _$map[r'transport'] == null
          ? null
          : _i4.SetRelayBodyTransportModel2.fromJson(_$map[r'transport']),
    );
  }

  factory SetRelayBodyModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for SetRelayBodyModel2: contains complex types',
    );
  }

  final _i4.SetRelayBodyTransportModel2? transport;

  @_i3.override
  _i3.Object? toJson() => {
    if (transport != null) r'transport': transport?.toJson(),
  };

  $$SetRelayBodyModel2CopyWith<SetRelayBodyModel2> get copyWith =>
      _SetRelayBodyModel2CopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetRelayBodyModel2 && other.transport == this.transport;
  }

  @_i3.override
  _i3.int get hashCode => transport.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for SetRelayBodyModel2: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SetRelayBodyModel2: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SetRelayBodyModel2CopyWith<$Res> {
  factory $$SetRelayBodyModel2CopyWith(SetRelayBodyModel2 value) =
      _SetRelayBodyModel2CopyWith<$Res>;

  $Res call({_i4.SetRelayBodyTransportModel2? transport});
  _i4.SetRelayBodyTransportModel2? get transport;
}

class _SetRelayBodyModel2CopyWith<$Res>
    implements $$SetRelayBodyModel2CopyWith<$Res> {
  _SetRelayBodyModel2CopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SetRelayBodyModel2 _value;

  @_i3.override
  _i4.SetRelayBodyTransportModel2? get transport => _value.transport;

  @_i3.override
  $Res call({_i3.Object? transport = _sentinel}) {
    return (SetRelayBodyModel2(
      transport: _i3.identical(transport, _sentinel)
          ? this.transport
          : (transport as _i4.SetRelayBodyTransportModel2?),
    ) as $Res);
  }
}
