// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ConfirmRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ConfirmRequest({required this.totpCode});

  factory ConfirmRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'totp_code'},
      listKeys: {},
      context: r'ConfirmRequest',
    );
    return ConfirmRequest(
      totpCode: _$values[r'totp_code'].decodeSimpleString(
        context: r'ConfirmRequest.totp_code',
      ),
    );
  }

  factory ConfirmRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ConfirmRequest');
    return ConfirmRequest(
      totpCode: _$map[r'totp_code'].decodeJsonString(
        context: r'ConfirmRequest.totp_code',
      ),
    );
  }

  factory ConfirmRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'totp_code'},
      listKeys: {},
      context: r'ConfirmRequest',
    );
    return ConfirmRequest(
      totpCode: _$values[r'totp_code'].decodeFormString(
        context: r'ConfirmRequest.totp_code',
      ),
    );
  }

  final _i3.String totpCode;

  @_i3.override
  _i3.Object? toJson() => {r'totp_code': totpCode};

  $$ConfirmRequestCopyWith<ConfirmRequest> get copyWith =>
      _ConfirmRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ConfirmRequest && other.totpCode == this.totpCode;
  }

  @_i3.override
  _i3.int get hashCode => totpCode.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'totp_code'] = _i1.PropertyValue.scalar(totpCode);
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
      r'Cannot uriEncode ConfirmRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ConfirmRequestCopyWith<$Res> {
  factory $$ConfirmRequestCopyWith(ConfirmRequest value) =
      _ConfirmRequestCopyWith<$Res>;

  $Res call({_i3.String? totpCode});
  _i3.String get totpCode;
}

class _ConfirmRequestCopyWith<$Res> implements $$ConfirmRequestCopyWith<$Res> {
  _ConfirmRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ConfirmRequest _value;

  @_i3.override
  _i3.String get totpCode => _value.totpCode;

  @_i3.override
  $Res call({_i3.Object? totpCode = _sentinel}) {
    return (ConfirmRequest(
      totpCode: _i3.identical(totpCode, _sentinel)
          ? this.totpCode
          : (totpCode as _i3.String),
    ) as $Res);
  }
}
