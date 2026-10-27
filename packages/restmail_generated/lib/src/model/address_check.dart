// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class AddressCheck extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const AddressCheck({
    required this.address,
    required this.exists,
    this.mailboxId,
  });

  factory AddressCheck.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'address', r'exists', r'mailbox_id'},
      listKeys: {},
      context: r'AddressCheck',
    );
    return AddressCheck(
      address: _$values[r'address'].decodeSimpleString(
        context: r'AddressCheck.address',
      ),
      exists: _$values[r'exists'].decodeSimpleBool(
        context: r'AddressCheck.exists',
      ),
      mailboxId: _$values[r'mailbox_id'].decodeSimpleNullableInt(
        context: r'AddressCheck.mailbox_id',
      ),
    );
  }

  factory AddressCheck.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'AddressCheck');
    return AddressCheck(
      address: _$map[r'address'].decodeJsonString(
        context: r'AddressCheck.address',
      ),
      exists: _$map[r'exists'].decodeJsonBool(context: r'AddressCheck.exists'),
      mailboxId: _$map[r'mailbox_id'].decodeJsonNullableInt(
        context: r'AddressCheck.mailbox_id',
      ),
    );
  }

  factory AddressCheck.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'address', r'exists', r'mailbox_id'},
      listKeys: {},
      context: r'AddressCheck',
    );
    return AddressCheck(
      address: _$values[r'address'].decodeFormString(
        context: r'AddressCheck.address',
      ),
      exists: _$values[r'exists'].decodeFormBool(
        context: r'AddressCheck.exists',
      ),
      mailboxId: _$values[r'mailbox_id'].decodeFormNullableInt(
        context: r'AddressCheck.mailbox_id',
      ),
    );
  }

  final _i3.String address;

  final _i3.bool exists;

  final _i3.int? mailboxId;

  @_i3.override
  _i3.Object? toJson() => {
    r'address': address,
    r'exists': exists,
    if (mailboxId != null) r'mailbox_id': mailboxId,
  };

  $$AddressCheckCopyWith<AddressCheck> get copyWith =>
      _AddressCheckCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddressCheck &&
        other.address == this.address &&
        other.exists == this.exists &&
        other.mailboxId == this.mailboxId;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([address, exists, mailboxId]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'address'] = _i1.PropertyValue.scalar(address);
    _$result[r'exists'] = _i1.PropertyValue.scalar(exists.toString());
    if (mailboxId != null) {
      _$result[r'mailbox_id'] = _i1.PropertyValue.scalar(mailboxId!.toString());
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
      r'Cannot uriEncode AddressCheck: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AddressCheckCopyWith<$Res> {
  factory $$AddressCheckCopyWith(AddressCheck value) =
      _AddressCheckCopyWith<$Res>;

  $Res call({_i3.String? address, _i3.bool? exists, _i3.int? mailboxId});
  _i3.String get address;
  _i3.bool get exists;
  _i3.int? get mailboxId;
}

class _AddressCheckCopyWith<$Res> implements $$AddressCheckCopyWith<$Res> {
  _AddressCheckCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final AddressCheck _value;

  @_i3.override
  _i3.String get address => _value.address;

  @_i3.override
  _i3.bool get exists => _value.exists;

  @_i3.override
  _i3.int? get mailboxId => _value.mailboxId;

  @_i3.override
  $Res call({
    _i3.Object? address = _sentinel,
    _i3.Object? exists = _sentinel,
    _i3.Object? mailboxId = _sentinel,
  }) {
    return (AddressCheck(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String),
      exists: _i3.identical(exists, _sentinel)
          ? this.exists
          : (exists as _i3.bool),
      mailboxId: _i3.identical(mailboxId, _sentinel)
          ? this.mailboxId
          : (mailboxId as _i3.int?),
    ) as $Res);
  }
}
