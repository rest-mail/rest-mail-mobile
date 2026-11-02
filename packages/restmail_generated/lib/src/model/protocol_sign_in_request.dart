// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/protocol_sign_in_request_protocol_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ProtocolSignInRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ProtocolSignInRequest({required this.protocol});

  factory ProtocolSignInRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'protocol'},
      listKeys: {},
      context: r'ProtocolSignInRequest',
    );
    return ProtocolSignInRequest(
      protocol: _i4.ProtocolSignInRequestProtocolModel.fromSimple(
        _$values[r'protocol'],
        explode: explode,
      ),
    );
  }

  factory ProtocolSignInRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ProtocolSignInRequest');
    return ProtocolSignInRequest(
      protocol: _i4.ProtocolSignInRequestProtocolModel.fromJson(
        _$map[r'protocol'],
      ),
    );
  }

  factory ProtocolSignInRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'protocol'},
      listKeys: {},
      context: r'ProtocolSignInRequest',
    );
    return ProtocolSignInRequest(
      protocol: _i4.ProtocolSignInRequestProtocolModel.fromForm(
        _$values[r'protocol'],
        explode: explode,
      ),
    );
  }

  final _i4.ProtocolSignInRequestProtocolModel protocol;

  @_i3.override
  _i3.Object? toJson() => {r'protocol': protocol.toJson()};

  $$ProtocolSignInRequestCopyWith<ProtocolSignInRequest> get copyWith =>
      _ProtocolSignInRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ProtocolSignInRequest && other.protocol == this.protocol;
  }

  @_i3.override
  _i3.int get hashCode => protocol.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'protocol'] = _i1.PropertyValue.scalar(protocol.toJson());
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
      r'Cannot uriEncode ProtocolSignInRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ProtocolSignInRequestCopyWith<$Res> {
  factory $$ProtocolSignInRequestCopyWith(ProtocolSignInRequest value) =
      _ProtocolSignInRequestCopyWith<$Res>;

  $Res call({_i4.ProtocolSignInRequestProtocolModel? protocol});
  _i4.ProtocolSignInRequestProtocolModel get protocol;
}

class _ProtocolSignInRequestCopyWith<$Res>
    implements $$ProtocolSignInRequestCopyWith<$Res> {
  _ProtocolSignInRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ProtocolSignInRequest _value;

  @_i3.override
  _i4.ProtocolSignInRequestProtocolModel get protocol => _value.protocol;

  @_i3.override
  $Res call({_i3.Object? protocol = _sentinel}) {
    return (ProtocolSignInRequest(
      protocol: _i3.identical(protocol, _sentinel)
          ? this.protocol
          : (protocol as _i4.ProtocolSignInRequestProtocolModel),
    ) as $Res);
  }
}
