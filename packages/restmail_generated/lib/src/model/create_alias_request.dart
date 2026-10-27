// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreateAliasRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreateAliasRequest({
    required this.destinationAddress,
    required this.sourceAddress,
  });

  factory CreateAliasRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'destination_address', r'source_address'},
      listKeys: {},
      context: r'CreateAliasRequest',
    );
    return CreateAliasRequest(
      destinationAddress: _$values[r'destination_address'].decodeSimpleString(
        context: r'CreateAliasRequest.destination_address',
      ),
      sourceAddress: _$values[r'source_address'].decodeSimpleString(
        context: r'CreateAliasRequest.source_address',
      ),
    );
  }

  factory CreateAliasRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreateAliasRequest');
    return CreateAliasRequest(
      destinationAddress: _$map[r'destination_address'].decodeJsonString(
        context: r'CreateAliasRequest.destination_address',
      ),
      sourceAddress: _$map[r'source_address'].decodeJsonString(
        context: r'CreateAliasRequest.source_address',
      ),
    );
  }

  factory CreateAliasRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'destination_address', r'source_address'},
      listKeys: {},
      context: r'CreateAliasRequest',
    );
    return CreateAliasRequest(
      destinationAddress: _$values[r'destination_address'].decodeFormString(
        context: r'CreateAliasRequest.destination_address',
      ),
      sourceAddress: _$values[r'source_address'].decodeFormString(
        context: r'CreateAliasRequest.source_address',
      ),
    );
  }

  final _i3.String destinationAddress;

  final _i3.String sourceAddress;

  @_i3.override
  _i3.Object? toJson() => {
    r'destination_address': destinationAddress,
    r'source_address': sourceAddress,
  };

  $$CreateAliasRequestCopyWith<CreateAliasRequest> get copyWith =>
      _CreateAliasRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAliasRequest &&
        other.destinationAddress == this.destinationAddress &&
        other.sourceAddress == this.sourceAddress;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([destinationAddress, sourceAddress]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'destination_address'] = _i1.PropertyValue.scalar(
      destinationAddress,
    );
    _$result[r'source_address'] = _i1.PropertyValue.scalar(sourceAddress);
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
      r'Cannot uriEncode CreateAliasRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreateAliasRequestCopyWith<$Res> {
  factory $$CreateAliasRequestCopyWith(CreateAliasRequest value) =
      _CreateAliasRequestCopyWith<$Res>;

  $Res call({_i3.String? destinationAddress, _i3.String? sourceAddress});
  _i3.String get destinationAddress;
  _i3.String get sourceAddress;
}

class _CreateAliasRequestCopyWith<$Res>
    implements $$CreateAliasRequestCopyWith<$Res> {
  _CreateAliasRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreateAliasRequest _value;

  @_i3.override
  _i3.String get destinationAddress => _value.destinationAddress;

  @_i3.override
  _i3.String get sourceAddress => _value.sourceAddress;

  @_i3.override
  $Res call({
    _i3.Object? destinationAddress = _sentinel,
    _i3.Object? sourceAddress = _sentinel,
  }) {
    return (CreateAliasRequest(
      destinationAddress: _i3.identical(destinationAddress, _sentinel)
          ? this.destinationAddress
          : (destinationAddress as _i3.String),
      sourceAddress: _i3.identical(sourceAddress, _sentinel)
          ? this.sourceAddress
          : (sourceAddress as _i3.String),
    ) as $Res);
  }
}
