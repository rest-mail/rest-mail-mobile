// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UpdateAliasRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UpdateAliasRequest({this.active, this.destinationAddress});

  factory UpdateAliasRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'active', r'destination_address'},
      listKeys: {},
      context: r'UpdateAliasRequest',
    );
    return UpdateAliasRequest(
      active: _$values[r'active'].decodeSimpleNullableBool(
        context: r'UpdateAliasRequest.active',
      ),
      destinationAddress: _$values[r'destination_address']
          .decodeSimpleNullableString(
            context: r'UpdateAliasRequest.destination_address',
          ),
    );
  }

  factory UpdateAliasRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UpdateAliasRequest');
    return UpdateAliasRequest(
      active: _$map[r'active'].decodeJsonNullableBool(
        context: r'UpdateAliasRequest.active',
      ),
      destinationAddress: _$map[r'destination_address']
          .decodeJsonNullableString(
            context: r'UpdateAliasRequest.destination_address',
          ),
    );
  }

  factory UpdateAliasRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'active', r'destination_address'},
      listKeys: {},
      context: r'UpdateAliasRequest',
    );
    return UpdateAliasRequest(
      active: _$values[r'active'].decodeFormNullableBool(
        context: r'UpdateAliasRequest.active',
      ),
      destinationAddress: _$values[r'destination_address']
          .decodeFormNullableString(
            context: r'UpdateAliasRequest.destination_address',
          ),
    );
  }

  final _i3.bool? active;

  final _i3.String? destinationAddress;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    r'destination_address': destinationAddress,
  };

  $$UpdateAliasRequestCopyWith<UpdateAliasRequest> get copyWith =>
      _UpdateAliasRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateAliasRequest &&
        other.active == this.active &&
        other.destinationAddress == this.destinationAddress;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([active, destinationAddress]);
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
    if (destinationAddress != null) {
      _$result[r'destination_address'] = _i1.PropertyValue.scalar(
        destinationAddress!,
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
      r'Cannot uriEncode UpdateAliasRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UpdateAliasRequestCopyWith<$Res> {
  factory $$UpdateAliasRequestCopyWith(UpdateAliasRequest value) =
      _UpdateAliasRequestCopyWith<$Res>;

  $Res call({_i3.bool? active, _i3.String? destinationAddress});
  _i3.bool? get active;
  _i3.String? get destinationAddress;
}

class _UpdateAliasRequestCopyWith<$Res>
    implements $$UpdateAliasRequestCopyWith<$Res> {
  _UpdateAliasRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UpdateAliasRequest _value;

  @_i3.override
  _i3.bool? get active => _value.active;

  @_i3.override
  _i3.String? get destinationAddress => _value.destinationAddress;

  @_i3.override
  $Res call({
    _i3.Object? active = _sentinel,
    _i3.Object? destinationAddress = _sentinel,
  }) {
    return (UpdateAliasRequest(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool?),
      destinationAddress: _i3.identical(destinationAddress, _sentinel)
          ? this.destinationAddress
          : (destinationAddress as _i3.String?),
    ) as $Res);
  }
}
