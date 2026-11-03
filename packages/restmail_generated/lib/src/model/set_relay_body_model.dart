// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/set_relay_body_transport_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetRelayBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SetRelayBodyModel({required this.host, this.transport});

  factory SetRelayBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for SetRelayBodyModel: contains complex types',
    );
  }

  factory SetRelayBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SetRelayBodyModel');
    return SetRelayBodyModel(
      host: _$map[r'host'],
      transport: _$map[r'transport'] == null
          ? null
          : _i4.SetRelayBodyTransportModel.fromJson(_$map[r'transport']),
    );
  }

  factory SetRelayBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for SetRelayBodyModel: contains complex types',
    );
  }

  final _i3.Object? host;

  final _i4.SetRelayBodyTransportModel? transport;

  @_i3.override
  _i3.Object? toJson() => {
    r'host': _i1.encodeUnknownJson(host, context: r'SetRelayBodyModel.host'),
    if (transport != null) r'transport': transport?.toJson(),
  };

  $$SetRelayBodyModelCopyWith<SetRelayBodyModel> get copyWith =>
      _SetRelayBodyModelCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetRelayBodyModel &&
        other.host == this.host &&
        other.transport == this.transport;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([host, transport]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for SetRelayBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SetRelayBodyModel: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SetRelayBodyModelCopyWith<$Res> {
  factory $$SetRelayBodyModelCopyWith(SetRelayBodyModel value) =
      _SetRelayBodyModelCopyWith<$Res>;

  $Res call({_i3.Object? host, _i4.SetRelayBodyTransportModel? transport});
  _i3.Object? get host;
  _i4.SetRelayBodyTransportModel? get transport;
}

class _SetRelayBodyModelCopyWith<$Res>
    implements $$SetRelayBodyModelCopyWith<$Res> {
  _SetRelayBodyModelCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SetRelayBodyModel _value;

  @_i3.override
  _i3.Object? get host => _value.host;

  @_i3.override
  _i4.SetRelayBodyTransportModel? get transport => _value.transport;

  @_i3.override
  $Res call({_i3.Object? host = _sentinel, _i3.Object? transport = _sentinel}) {
    return (SetRelayBodyModel(
      host: _i3.identical(host, _sentinel) ? this.host : host,
      transport: _i3.identical(transport, _sentinel)
          ? this.transport
          : (transport as _i4.SetRelayBodyTransportModel?),
    ) as $Res);
  }
}
