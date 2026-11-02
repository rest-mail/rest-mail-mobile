// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RestmailDeliverBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RestmailDeliverBodyModel({required this.rawMessage});

  factory RestmailDeliverBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'raw_message'},
      listKeys: {},
      context: r'RestmailDeliverBodyModel',
    );
    return RestmailDeliverBodyModel(rawMessage: _$values[r'raw_message']);
  }

  factory RestmailDeliverBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RestmailDeliverBodyModel');
    return RestmailDeliverBodyModel(rawMessage: _$map[r'raw_message']);
  }

  factory RestmailDeliverBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'raw_message'},
      listKeys: {},
      context: r'RestmailDeliverBodyModel',
    );
    return RestmailDeliverBodyModel(
      rawMessage: _$values[r'raw_message'].decodeFormNullableString(
        context: r'RestmailDeliverBodyModel.raw_message',
      ),
    );
  }

  final _i3.Object? rawMessage;

  @_i3.override
  _i3.Object? toJson() => {
    r'raw_message': _i1.encodeUnknownJson(
      rawMessage,
      context: r'RestmailDeliverBodyModel.raw_message',
    ),
  };

  $$RestmailDeliverBodyModelCopyWith<RestmailDeliverBodyModel> get copyWith =>
      _RestmailDeliverBodyModelCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDeliverBodyModel &&
        other.rawMessage == this.rawMessage;
  }

  @_i3.override
  _i3.int get hashCode => rawMessage.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (rawMessage != null) {
      _$result[r'raw_message'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          rawMessage!,
          context: r'RestmailDeliverBodyModel.raw_message',
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
      r'Cannot uriEncode RestmailDeliverBodyModel: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RestmailDeliverBodyModelCopyWith<$Res> {
  factory $$RestmailDeliverBodyModelCopyWith(RestmailDeliverBodyModel value) =
      _RestmailDeliverBodyModelCopyWith<$Res>;

  $Res call({_i3.Object? rawMessage});
  _i3.Object? get rawMessage;
}

class _RestmailDeliverBodyModelCopyWith<$Res>
    implements $$RestmailDeliverBodyModelCopyWith<$Res> {
  _RestmailDeliverBodyModelCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RestmailDeliverBodyModel _value;

  @_i3.override
  _i3.Object? get rawMessage => _value.rawMessage;

  @_i3.override
  $Res call({_i3.Object? rawMessage = _sentinel}) {
    return (RestmailDeliverBodyModel(
      rawMessage: _i3.identical(rawMessage, _sentinel)
          ? this.rawMessage
          : rawMessage,
    ) as $Res);
  }
}
