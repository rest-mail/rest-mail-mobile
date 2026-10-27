// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ResetRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ResetRequest({this.client, this.password, this.token});

  factory ResetRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'client', r'password', r'token'},
      listKeys: {},
      context: r'ResetRequest',
    );
    return ResetRequest(
      client: _$values[r'client'].decodeSimpleNullableString(
        context: r'ResetRequest.client',
      ),
      password: _$values[r'password'].decodeSimpleNullableString(
        context: r'ResetRequest.password',
      ),
      token: _$values[r'token'].decodeSimpleNullableString(
        context: r'ResetRequest.token',
      ),
    );
  }

  factory ResetRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ResetRequest');
    return ResetRequest(
      client: _$map[r'client'].decodeJsonNullableString(
        context: r'ResetRequest.client',
      ),
      password: _$map[r'password'].decodeJsonNullableString(
        context: r'ResetRequest.password',
      ),
      token: _$map[r'token'].decodeJsonNullableString(
        context: r'ResetRequest.token',
      ),
    );
  }

  factory ResetRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'client', r'password', r'token'},
      listKeys: {},
      context: r'ResetRequest',
    );
    return ResetRequest(
      client: _$values[r'client'].decodeFormNullableString(
        context: r'ResetRequest.client',
      ),
      password: _$values[r'password'].decodeFormNullableString(
        context: r'ResetRequest.password',
      ),
      token: _$values[r'token'].decodeFormNullableString(
        context: r'ResetRequest.token',
      ),
    );
  }

  final _i3.String? client;

  final _i3.String? password;

  final _i3.String? token;

  @_i3.override
  _i3.Object? toJson() => {
    if (client != null) r'client': client,
    if (password != null) r'password': password,
    if (token != null) r'token': token,
  };

  $$ResetRequestCopyWith<ResetRequest> get copyWith =>
      _ResetRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetRequest &&
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
      _$result[r'client'] = _i1.PropertyValue.scalar(client!);
    }
    if (password != null) {
      _$result[r'password'] = _i1.PropertyValue.scalar(password!);
    }
    if (token != null) {
      _$result[r'token'] = _i1.PropertyValue.scalar(token!);
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
      r'Cannot uriEncode ResetRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ResetRequestCopyWith<$Res> {
  factory $$ResetRequestCopyWith(ResetRequest value) =
      _ResetRequestCopyWith<$Res>;

  $Res call({_i3.String? client, _i3.String? password, _i3.String? token});
  _i3.String? get client;
  _i3.String? get password;
  _i3.String? get token;
}

class _ResetRequestCopyWith<$Res> implements $$ResetRequestCopyWith<$Res> {
  _ResetRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ResetRequest _value;

  @_i3.override
  _i3.String? get client => _value.client;

  @_i3.override
  _i3.String? get password => _value.password;

  @_i3.override
  _i3.String? get token => _value.token;

  @_i3.override
  $Res call({
    _i3.Object? client = _sentinel,
    _i3.Object? password = _sentinel,
    _i3.Object? token = _sentinel,
  }) {
    return (ResetRequest(
      client: _i3.identical(client, _sentinel)
          ? this.client
          : (client as _i3.String?),
      password: _i3.identical(password, _sentinel)
          ? this.password
          : (password as _i3.String?),
      token: _i3.identical(token, _sentinel)
          ? this.token
          : (token as _i3.String?),
    ) as $Res);
  }
}
