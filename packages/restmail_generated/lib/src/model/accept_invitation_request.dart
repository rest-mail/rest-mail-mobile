// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/accept_invitation_request_client_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class AcceptInvitationRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const AcceptInvitationRequest({
    required this.password,
    this.client,
    this.token,
  });

  factory AcceptInvitationRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'client', r'password', r'token'},
      listKeys: {},
      context: r'AcceptInvitationRequest',
    );
    return AcceptInvitationRequest(
      client: _$values[r'client'] == null
          ? null
          : _i4.AcceptInvitationRequestClientModel.fromSimple(
              _$values[r'client'],
              explode: explode,
            ),
      password: _$values[r'password'].decodeSimpleString(
        context: r'AcceptInvitationRequest.password',
      ),
      token: _$values[r'token'].decodeSimpleNullableString(
        context: r'AcceptInvitationRequest.token',
      ),
    );
  }

  factory AcceptInvitationRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'AcceptInvitationRequest');
    return AcceptInvitationRequest(
      client: _$map[r'client'] == null
          ? null
          : _i4.AcceptInvitationRequestClientModel.fromJson(_$map[r'client']),
      password: _$map[r'password'].decodeJsonString(
        context: r'AcceptInvitationRequest.password',
      ),
      token: _$map[r'token'].decodeJsonNullableString(
        context: r'AcceptInvitationRequest.token',
      ),
    );
  }

  factory AcceptInvitationRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'client', r'password', r'token'},
      listKeys: {},
      context: r'AcceptInvitationRequest',
    );
    return AcceptInvitationRequest(
      client: _$values[r'client'] == null
          ? null
          : _i4.AcceptInvitationRequestClientModel.fromForm(
              _$values[r'client'],
              explode: explode,
            ),
      password: _$values[r'password'].decodeFormString(
        context: r'AcceptInvitationRequest.password',
      ),
      token: _$values[r'token'].decodeFormNullableString(
        context: r'AcceptInvitationRequest.token',
      ),
    );
  }

  final _i4.AcceptInvitationRequestClientModel? client;

  final _i3.String password;

  final _i3.String? token;

  @_i3.override
  _i3.Object? toJson() => {
    if (client != null) r'client': client?.toJson(),
    r'password': password,
    if (token != null) r'token': token,
  };

  $$AcceptInvitationRequestCopyWith<AcceptInvitationRequest> get copyWith =>
      _AcceptInvitationRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AcceptInvitationRequest &&
        other.client == this.client &&
        other.password == this.password &&
        other.token == this.token;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([client, password, token]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (client != null) {
      _$result[r'client'] = _i1.PropertyValue.scalar(client!.toJson());
    }
    _$result[r'password'] = _i1.PropertyValue.scalar(password);
    if (token != null) {
      _$result[r'token'] = _i1.PropertyValue.scalar(token!);
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
      r'Cannot uriEncode AcceptInvitationRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AcceptInvitationRequestCopyWith<$Res> {
  factory $$AcceptInvitationRequestCopyWith(AcceptInvitationRequest value) =
      _AcceptInvitationRequestCopyWith<$Res>;

  $Res call({
    _i4.AcceptInvitationRequestClientModel? client,
    _i3.String? password,
    _i3.String? token,
  });
  _i4.AcceptInvitationRequestClientModel? get client;
  _i3.String get password;
  _i3.String? get token;
}

class _AcceptInvitationRequestCopyWith<$Res>
    implements $$AcceptInvitationRequestCopyWith<$Res> {
  _AcceptInvitationRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final AcceptInvitationRequest _value;

  @_i3.override
  _i4.AcceptInvitationRequestClientModel? get client => _value.client;

  @_i3.override
  _i3.String get password => _value.password;

  @_i3.override
  _i3.String? get token => _value.token;

  @_i3.override
  $Res call({
    _i3.Object? client = _sentinel,
    _i3.Object? password = _sentinel,
    _i3.Object? token = _sentinel,
  }) {
    return (AcceptInvitationRequest(
      client: _i3.identical(client, _sentinel)
          ? this.client
          : (client as _i4.AcceptInvitationRequestClientModel?),
      password: _i3.identical(password, _sentinel)
          ? this.password
          : (password as _i3.String),
      token: _i3.identical(token, _sentinel)
          ? this.token
          : (token as _i3.String?),
    ) as $Res);
  }
}
