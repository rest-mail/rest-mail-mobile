// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/set_relay_body_tls_mode_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/set_relay_body_transport_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetRelayBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SetRelayBody({
    required this.transport,
    this.host,
    this.password,
    this.port,
    this.tlsMode,
    this.username,
  });

  factory SetRelayBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'host',
        r'password',
        r'port',
        r'tls_mode',
        r'transport',
        r'username',
      },
      listKeys: {},
      context: r'SetRelayBody',
    );
    return SetRelayBody(
      host: _$values[r'host'].decodeSimpleNullableString(
        context: r'SetRelayBody.host',
      ),
      password: _$values[r'password'].decodeSimpleNullableString(
        context: r'SetRelayBody.password',
      ),
      port: _$values[r'port'].decodeSimpleNullableInt(
        context: r'SetRelayBody.port',
      ),
      tlsMode: _$values[r'tls_mode'] == null
          ? null
          : _i4.SetRelayBodyTlsModeModel.fromSimple(
              _$values[r'tls_mode'],
              explode: explode,
            ),
      transport: _i5.SetRelayBodyTransportModel.fromSimple(
        _$values[r'transport'],
        explode: explode,
      ),
      username: _$values[r'username'].decodeSimpleNullableString(
        context: r'SetRelayBody.username',
      ),
    );
  }

  factory SetRelayBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SetRelayBody');
    return SetRelayBody(
      host: _$map[r'host'].decodeJsonNullableString(
        context: r'SetRelayBody.host',
      ),
      password: _$map[r'password'].decodeJsonNullableString(
        context: r'SetRelayBody.password',
      ),
      port: _$map[r'port'].decodeJsonNullableInt(context: r'SetRelayBody.port'),
      tlsMode: _$map[r'tls_mode'] == null
          ? null
          : _i4.SetRelayBodyTlsModeModel.fromJson(_$map[r'tls_mode']),
      transport: _i5.SetRelayBodyTransportModel.fromJson(_$map[r'transport']),
      username: _$map[r'username'].decodeJsonNullableString(
        context: r'SetRelayBody.username',
      ),
    );
  }

  factory SetRelayBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'host',
        r'password',
        r'port',
        r'tls_mode',
        r'transport',
        r'username',
      },
      listKeys: {},
      context: r'SetRelayBody',
    );
    return SetRelayBody(
      host: _$values[r'host'].decodeFormNullableString(
        context: r'SetRelayBody.host',
      ),
      password: _$values[r'password'].decodeFormNullableString(
        context: r'SetRelayBody.password',
      ),
      port: _$values[r'port'].decodeFormNullableInt(
        context: r'SetRelayBody.port',
      ),
      tlsMode: _$values[r'tls_mode'] == null
          ? null
          : _i4.SetRelayBodyTlsModeModel.fromForm(
              _$values[r'tls_mode'],
              explode: explode,
            ),
      transport: _i5.SetRelayBodyTransportModel.fromForm(
        _$values[r'transport'],
        explode: explode,
      ),
      username: _$values[r'username'].decodeFormNullableString(
        context: r'SetRelayBody.username',
      ),
    );
  }

  final _i3.String? host;

  final _i3.String? password;

  final _i3.int? port;

  final _i4.SetRelayBodyTlsModeModel? tlsMode;

  final _i5.SetRelayBodyTransportModel transport;

  final _i3.String? username;

  @_i3.override
  _i3.Object? toJson() => {
    if (host != null) r'host': host,
    r'password': password,
    r'port': port,
    r'tls_mode': tlsMode?.toJson(),
    r'transport': transport.toJson(),
    if (username != null) r'username': username,
  };

  $$SetRelayBodyCopyWith<SetRelayBody> get copyWith =>
      _SetRelayBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetRelayBody &&
        other.host == this.host &&
        other.password == this.password &&
        other.port == this.port &&
        other.tlsMode == this.tlsMode &&
        other.transport == this.transport &&
        other.username == this.username;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      host,
      password,
      port,
      tlsMode,
      transport,
      username,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (host != null) {
      _$result[r'host'] = _i1.PropertyValue.scalar(host!);
    }
    if (password != null) {
      _$result[r'password'] = _i1.PropertyValue.scalar(password!);
    }
    if (port != null) {
      _$result[r'port'] = _i1.PropertyValue.scalar(port!.toString());
    }
    if (tlsMode != null) {
      _$result[r'tls_mode'] = _i1.PropertyValue.scalar(tlsMode!.toJson());
    }
    _$result[r'transport'] = _i1.PropertyValue.scalar(transport.toJson());
    if (username != null) {
      _$result[r'username'] = _i1.PropertyValue.scalar(username!);
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SetRelayBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SetRelayBodyCopyWith<$Res> {
  factory $$SetRelayBodyCopyWith(SetRelayBody value) =
      _SetRelayBodyCopyWith<$Res>;

  $Res call({
    _i3.String? host,
    _i3.String? password,
    _i3.int? port,
    _i4.SetRelayBodyTlsModeModel? tlsMode,
    _i5.SetRelayBodyTransportModel? transport,
    _i3.String? username,
  });
  _i3.String? get host;
  _i3.String? get password;
  _i3.int? get port;
  _i4.SetRelayBodyTlsModeModel? get tlsMode;
  _i5.SetRelayBodyTransportModel get transport;
  _i3.String? get username;
}

class _SetRelayBodyCopyWith<$Res> implements $$SetRelayBodyCopyWith<$Res> {
  _SetRelayBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SetRelayBody _value;

  @_i3.override
  _i3.String? get host => _value.host;

  @_i3.override
  _i3.String? get password => _value.password;

  @_i3.override
  _i3.int? get port => _value.port;

  @_i3.override
  _i4.SetRelayBodyTlsModeModel? get tlsMode => _value.tlsMode;

  @_i3.override
  _i5.SetRelayBodyTransportModel get transport => _value.transport;

  @_i3.override
  _i3.String? get username => _value.username;

  @_i3.override
  $Res call({
    _i3.Object? host = _sentinel,
    _i3.Object? password = _sentinel,
    _i3.Object? port = _sentinel,
    _i3.Object? tlsMode = _sentinel,
    _i3.Object? transport = _sentinel,
    _i3.Object? username = _sentinel,
  }) {
    return (SetRelayBody(
      host: _i3.identical(host, _sentinel) ? this.host : (host as _i3.String?),
      password: _i3.identical(password, _sentinel)
          ? this.password
          : (password as _i3.String?),
      port: _i3.identical(port, _sentinel) ? this.port : (port as _i3.int?),
      tlsMode: _i3.identical(tlsMode, _sentinel)
          ? this.tlsMode
          : (tlsMode as _i4.SetRelayBodyTlsModeModel?),
      transport: _i3.identical(transport, _sentinel)
          ? this.transport
          : (transport as _i5.SetRelayBodyTransportModel),
      username: _i3.identical(username, _sentinel)
          ? this.username
          : (username as _i3.String?),
    ) as $Res);
  }
}
