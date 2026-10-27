// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UpdateMailboxRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UpdateMailboxRequest({
    this.active,
    this.displayName,
    this.password,
    this.quotaBytes,
  });

  factory UpdateMailboxRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'active', r'display_name', r'password', r'quota_bytes'},
      listKeys: {},
      context: r'UpdateMailboxRequest',
    );
    return UpdateMailboxRequest(
      active: _$values[r'active'].decodeSimpleNullableBool(
        context: r'UpdateMailboxRequest.active',
      ),
      displayName: _$values[r'display_name'].decodeSimpleNullableString(
        context: r'UpdateMailboxRequest.display_name',
      ),
      password: _$values[r'password'].decodeSimpleNullableString(
        context: r'UpdateMailboxRequest.password',
      ),
      quotaBytes: _$values[r'quota_bytes'].decodeSimpleNullableInt(
        context: r'UpdateMailboxRequest.quota_bytes',
      ),
    );
  }

  factory UpdateMailboxRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UpdateMailboxRequest');
    return UpdateMailboxRequest(
      active: _$map[r'active'].decodeJsonNullableBool(
        context: r'UpdateMailboxRequest.active',
      ),
      displayName: _$map[r'display_name'].decodeJsonNullableString(
        context: r'UpdateMailboxRequest.display_name',
      ),
      password: _$map[r'password'].decodeJsonNullableString(
        context: r'UpdateMailboxRequest.password',
      ),
      quotaBytes: _$map[r'quota_bytes'].decodeJsonNullableInt(
        context: r'UpdateMailboxRequest.quota_bytes',
      ),
    );
  }

  factory UpdateMailboxRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'active', r'display_name', r'password', r'quota_bytes'},
      listKeys: {},
      context: r'UpdateMailboxRequest',
    );
    return UpdateMailboxRequest(
      active: _$values[r'active'].decodeFormNullableBool(
        context: r'UpdateMailboxRequest.active',
      ),
      displayName: _$values[r'display_name'].decodeFormNullableString(
        context: r'UpdateMailboxRequest.display_name',
      ),
      password: _$values[r'password'].decodeFormNullableString(
        context: r'UpdateMailboxRequest.password',
      ),
      quotaBytes: _$values[r'quota_bytes'].decodeFormNullableInt(
        context: r'UpdateMailboxRequest.quota_bytes',
      ),
    );
  }

  final _i3.bool? active;

  final _i3.String? displayName;

  final _i3.String? password;

  final _i3.int? quotaBytes;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    r'display_name': displayName,
    r'password': password,
    r'quota_bytes': quotaBytes,
  };

  $$UpdateMailboxRequestCopyWith<UpdateMailboxRequest> get copyWith =>
      _UpdateMailboxRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMailboxRequest &&
        other.active == this.active &&
        other.displayName == this.displayName &&
        other.password == this.password &&
        other.quotaBytes == this.quotaBytes;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([active, displayName, password, quotaBytes]);
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
    if (displayName != null) {
      _$result[r'display_name'] = _i1.PropertyValue.scalar(displayName!);
    }
    if (password != null) {
      _$result[r'password'] = _i1.PropertyValue.scalar(password!);
    }
    if (quotaBytes != null) {
      _$result[r'quota_bytes'] = _i1.PropertyValue.scalar(
        quotaBytes!.toString(),
      );
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
      r'Cannot uriEncode UpdateMailboxRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UpdateMailboxRequestCopyWith<$Res> {
  factory $$UpdateMailboxRequestCopyWith(UpdateMailboxRequest value) =
      _UpdateMailboxRequestCopyWith<$Res>;

  $Res call({
    _i3.bool? active,
    _i3.String? displayName,
    _i3.String? password,
    _i3.int? quotaBytes,
  });
  _i3.bool? get active;
  _i3.String? get displayName;
  _i3.String? get password;
  _i3.int? get quotaBytes;
}

class _UpdateMailboxRequestCopyWith<$Res>
    implements $$UpdateMailboxRequestCopyWith<$Res> {
  _UpdateMailboxRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UpdateMailboxRequest _value;

  @_i3.override
  _i3.bool? get active => _value.active;

  @_i3.override
  _i3.String? get displayName => _value.displayName;

  @_i3.override
  _i3.String? get password => _value.password;

  @_i3.override
  _i3.int? get quotaBytes => _value.quotaBytes;

  @_i3.override
  $Res call({
    _i3.Object? active = _sentinel,
    _i3.Object? displayName = _sentinel,
    _i3.Object? password = _sentinel,
    _i3.Object? quotaBytes = _sentinel,
  }) {
    return (UpdateMailboxRequest(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool?),
      displayName: _i3.identical(displayName, _sentinel)
          ? this.displayName
          : (displayName as _i3.String?),
      password: _i3.identical(password, _sentinel)
          ? this.password
          : (password as _i3.String?),
      quotaBytes: _i3.identical(quotaBytes, _sentinel)
          ? this.quotaBytes
          : (quotaBytes as _i3.int?),
    ) as $Res);
  }
}
