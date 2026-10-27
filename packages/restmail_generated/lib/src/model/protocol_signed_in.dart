// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/protocol_signed_in_credential_kind_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/user_info.dart' as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ProtocolSignedIn extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ProtocolSignedIn({
    required this.credentialId,
    required this.credentialKind,
    required this.user,
  });

  factory ProtocolSignedIn.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ProtocolSignedIn: contains complex types',
    );
  }

  factory ProtocolSignedIn.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ProtocolSignedIn');
    return ProtocolSignedIn(
      credentialId: _$map[r'credential_id'].decodeJsonInt(
        context: r'ProtocolSignedIn.credential_id',
      ),
      credentialKind: _i4.ProtocolSignedInCredentialKindModel.fromJson(
        _$map[r'credential_kind'],
      ),
      user: _i5.UserInfo.fromJson(_$map[r'user']),
    );
  }

  factory ProtocolSignedIn.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ProtocolSignedIn: contains complex types',
    );
  }

  final _i3.int credentialId;

  final _i4.ProtocolSignedInCredentialKindModel credentialKind;

  final _i5.UserInfo user;

  @_i3.override
  _i3.Object? toJson() => {
    r'credential_id': credentialId,
    r'credential_kind': credentialKind.toJson(),
    r'user': user.toJson(),
  };

  $$ProtocolSignedInCopyWith<ProtocolSignedIn> get copyWith =>
      _ProtocolSignedInCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ProtocolSignedIn &&
        other.credentialId == this.credentialId &&
        other.credentialKind == this.credentialKind &&
        other.user == this.user;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([credentialId, credentialKind, user]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ProtocolSignedIn: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ProtocolSignedIn: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ProtocolSignedInCopyWith<$Res> {
  factory $$ProtocolSignedInCopyWith(ProtocolSignedIn value) =
      _ProtocolSignedInCopyWith<$Res>;

  $Res call({
    _i3.int? credentialId,
    _i4.ProtocolSignedInCredentialKindModel? credentialKind,
    _i5.UserInfo? user,
  });
  _i3.int get credentialId;
  _i4.ProtocolSignedInCredentialKindModel get credentialKind;
  _i5.UserInfo get user;
}

class _ProtocolSignedInCopyWith<$Res>
    implements $$ProtocolSignedInCopyWith<$Res> {
  _ProtocolSignedInCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ProtocolSignedIn _value;

  @_i3.override
  _i3.int get credentialId => _value.credentialId;

  @_i3.override
  _i4.ProtocolSignedInCredentialKindModel get credentialKind =>
      _value.credentialKind;

  @_i3.override
  _i5.UserInfo get user => _value.user;

  @_i3.override
  $Res call({
    _i3.Object? credentialId = _sentinel,
    _i3.Object? credentialKind = _sentinel,
    _i3.Object? user = _sentinel,
  }) {
    return (ProtocolSignedIn(
      credentialId: _i3.identical(credentialId, _sentinel)
          ? this.credentialId
          : (credentialId as _i3.int),
      credentialKind: _i3.identical(credentialKind, _sentinel)
          ? this.credentialKind
          : (credentialKind as _i4.ProtocolSignedInCredentialKindModel),
      user: _i3.identical(user, _sentinel) ? this.user : (user as _i5.UserInfo),
    ) as $Res);
  }
}
