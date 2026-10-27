// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/relay_view_tls_mode_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/relay_view_transport_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RelayView extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RelayView({
    required this.domainId,
    required this.passwordSet,
    required this.transport,
    this.host,
    this.port,
    this.tlsMode,
    this.username,
  });

  factory RelayView.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'domain_id',
        r'host',
        r'password_set',
        r'port',
        r'tls_mode',
        r'transport',
        r'username',
      },
      listKeys: {},
      context: r'RelayView',
    );
    return RelayView(
      domainId: _$values[r'domain_id'].decodeSimpleInt(
        context: r'RelayView.domain_id',
      ),
      host: _$values[r'host'].decodeSimpleNullableString(
        context: r'RelayView.host',
      ),
      passwordSet: _$values[r'password_set'].decodeSimpleBool(
        context: r'RelayView.password_set',
      ),
      port: _$values[r'port'].decodeSimpleNullableInt(
        context: r'RelayView.port',
      ),
      tlsMode: _$values[r'tls_mode'] == null
          ? null
          : _i4.RelayViewTlsModeModel.fromSimple(
              _$values[r'tls_mode'],
              explode: explode,
            ),
      transport: _i5.RelayViewTransportModel.fromSimple(
        _$values[r'transport'],
        explode: explode,
      ),
      username: _$values[r'username'].decodeSimpleNullableString(
        context: r'RelayView.username',
      ),
    );
  }

  factory RelayView.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RelayView');
    return RelayView(
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'RelayView.domain_id',
      ),
      host: _$map[r'host'].decodeJsonNullableString(context: r'RelayView.host'),
      passwordSet: _$map[r'password_set'].decodeJsonBool(
        context: r'RelayView.password_set',
      ),
      port: _$map[r'port'].decodeJsonNullableInt(context: r'RelayView.port'),
      tlsMode: _$map[r'tls_mode'] == null
          ? null
          : _i4.RelayViewTlsModeModel.fromJson(_$map[r'tls_mode']),
      transport: _i5.RelayViewTransportModel.fromJson(_$map[r'transport']),
      username: _$map[r'username'].decodeJsonNullableString(
        context: r'RelayView.username',
      ),
    );
  }

  factory RelayView.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'domain_id',
        r'host',
        r'password_set',
        r'port',
        r'tls_mode',
        r'transport',
        r'username',
      },
      listKeys: {},
      context: r'RelayView',
    );
    return RelayView(
      domainId: _$values[r'domain_id'].decodeFormInt(
        context: r'RelayView.domain_id',
      ),
      host: _$values[r'host'].decodeFormNullableString(
        context: r'RelayView.host',
      ),
      passwordSet: _$values[r'password_set'].decodeFormBool(
        context: r'RelayView.password_set',
      ),
      port: _$values[r'port'].decodeFormNullableInt(context: r'RelayView.port'),
      tlsMode: _$values[r'tls_mode'] == null
          ? null
          : _i4.RelayViewTlsModeModel.fromForm(
              _$values[r'tls_mode'],
              explode: explode,
            ),
      transport: _i5.RelayViewTransportModel.fromForm(
        _$values[r'transport'],
        explode: explode,
      ),
      username: _$values[r'username'].decodeFormNullableString(
        context: r'RelayView.username',
      ),
    );
  }

  final _i3.int domainId;

  final _i3.String? host;

  final _i3.bool passwordSet;

  final _i3.int? port;

  final _i4.RelayViewTlsModeModel? tlsMode;

  final _i5.RelayViewTransportModel transport;

  final _i3.String? username;

  @_i3.override
  _i3.Object? toJson() => {
    r'domain_id': domainId,
    if (host != null) r'host': host,
    r'password_set': passwordSet,
    if (port != null) r'port': port,
    if (tlsMode != null) r'tls_mode': tlsMode?.toJson(),
    r'transport': transport.toJson(),
    if (username != null) r'username': username,
  };

  $$RelayViewCopyWith<RelayView> get copyWith => _RelayViewCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RelayView &&
        other.domainId == this.domainId &&
        other.host == this.host &&
        other.passwordSet == this.passwordSet &&
        other.port == this.port &&
        other.tlsMode == this.tlsMode &&
        other.transport == this.transport &&
        other.username == this.username;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      domainId,
      host,
      passwordSet,
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
    _$result[r'domain_id'] = _i1.PropertyValue.scalar(domainId.toString());
    if (host != null) {
      _$result[r'host'] = _i1.PropertyValue.scalar(host!);
    }
    _$result[r'password_set'] = _i1.PropertyValue.scalar(
      passwordSet.toString(),
    );
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
      r'Cannot uriEncode RelayView: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RelayViewCopyWith<$Res> {
  factory $$RelayViewCopyWith(RelayView value) = _RelayViewCopyWith<$Res>;

  $Res call({
    _i3.int? domainId,
    _i3.String? host,
    _i3.bool? passwordSet,
    _i3.int? port,
    _i4.RelayViewTlsModeModel? tlsMode,
    _i5.RelayViewTransportModel? transport,
    _i3.String? username,
  });
  _i3.int get domainId;
  _i3.String? get host;
  _i3.bool get passwordSet;
  _i3.int? get port;
  _i4.RelayViewTlsModeModel? get tlsMode;
  _i5.RelayViewTransportModel get transport;
  _i3.String? get username;
}

class _RelayViewCopyWith<$Res> implements $$RelayViewCopyWith<$Res> {
  _RelayViewCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RelayView _value;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.String? get host => _value.host;

  @_i3.override
  _i3.bool get passwordSet => _value.passwordSet;

  @_i3.override
  _i3.int? get port => _value.port;

  @_i3.override
  _i4.RelayViewTlsModeModel? get tlsMode => _value.tlsMode;

  @_i3.override
  _i5.RelayViewTransportModel get transport => _value.transport;

  @_i3.override
  _i3.String? get username => _value.username;

  @_i3.override
  $Res call({
    _i3.Object? domainId = _sentinel,
    _i3.Object? host = _sentinel,
    _i3.Object? passwordSet = _sentinel,
    _i3.Object? port = _sentinel,
    _i3.Object? tlsMode = _sentinel,
    _i3.Object? transport = _sentinel,
    _i3.Object? username = _sentinel,
  }) {
    return (RelayView(
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      host: _i3.identical(host, _sentinel) ? this.host : (host as _i3.String?),
      passwordSet: _i3.identical(passwordSet, _sentinel)
          ? this.passwordSet
          : (passwordSet as _i3.bool),
      port: _i3.identical(port, _sentinel) ? this.port : (port as _i3.int?),
      tlsMode: _i3.identical(tlsMode, _sentinel)
          ? this.tlsMode
          : (tlsMode as _i4.RelayViewTlsModeModel?),
      transport: _i3.identical(transport, _sentinel)
          ? this.transport
          : (transport as _i5.RelayViewTransportModel),
      username: _i3.identical(username, _sentinel)
          ? this.username
          : (username as _i3.String?),
    ) as $Res);
  }
}
