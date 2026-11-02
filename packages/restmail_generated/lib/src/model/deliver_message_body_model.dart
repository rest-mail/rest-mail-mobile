// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DeliverMessageBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DeliverMessageBodyModel({required this.address});

  factory DeliverMessageBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'address'},
      listKeys: {},
      context: r'DeliverMessageBodyModel',
    );
    return DeliverMessageBodyModel(address: _$values[r'address']);
  }

  factory DeliverMessageBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DeliverMessageBodyModel');
    return DeliverMessageBodyModel(address: _$map[r'address']);
  }

  factory DeliverMessageBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'address'},
      listKeys: {},
      context: r'DeliverMessageBodyModel',
    );
    return DeliverMessageBodyModel(
      address: _$values[r'address'].decodeFormNullableString(
        context: r'DeliverMessageBodyModel.address',
      ),
    );
  }

  final _i3.Object? address;

  @_i3.override
  _i3.Object? toJson() => {
    r'address': _i1.encodeUnknownJson(
      address,
      context: r'DeliverMessageBodyModel.address',
    ),
  };

  $$DeliverMessageBodyModelCopyWith<DeliverMessageBodyModel> get copyWith =>
      _DeliverMessageBodyModelCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageBodyModel && other.address == this.address;
  }

  @_i3.override
  _i3.int get hashCode => address.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (address != null) {
      _$result[r'address'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          address!,
          context: r'DeliverMessageBodyModel.address',
        ),
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
      r'Cannot uriEncode DeliverMessageBodyModel: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DeliverMessageBodyModelCopyWith<$Res> {
  factory $$DeliverMessageBodyModelCopyWith(DeliverMessageBodyModel value) =
      _DeliverMessageBodyModelCopyWith<$Res>;

  $Res call({_i3.Object? address});
  _i3.Object? get address;
}

class _DeliverMessageBodyModelCopyWith<$Res>
    implements $$DeliverMessageBodyModelCopyWith<$Res> {
  _DeliverMessageBodyModelCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DeliverMessageBodyModel _value;

  @_i3.override
  _i3.Object? get address => _value.address;

  @_i3.override
  $Res call({_i3.Object? address = _sentinel}) {
    return (DeliverMessageBodyModel(
      address: _i3.identical(address, _sentinel) ? this.address : address,
    ) as $Res);
  }
}
