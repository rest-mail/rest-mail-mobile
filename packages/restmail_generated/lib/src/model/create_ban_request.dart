// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/create_ban_request_protocol_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreateBanRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreateBanRequest({
    required this.createdBy,
    required this.ip,
    required this.protocol,
    this.duration,
    this.reason,
  });

  factory CreateBanRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'created_by', r'duration', r'ip', r'protocol', r'reason'},
      listKeys: {},
      context: r'CreateBanRequest',
    );
    return CreateBanRequest(
      createdBy: _$values[r'created_by'].decodeSimpleString(
        context: r'CreateBanRequest.created_by',
      ),
      duration: _$values[r'duration'].decodeSimpleNullableString(
        context: r'CreateBanRequest.duration',
      ),
      ip: _$values[r'ip'].decodeSimpleString(context: r'CreateBanRequest.ip'),
      protocol: _i4.CreateBanRequestProtocolModel.fromSimple(
        _$values[r'protocol'],
        explode: explode,
      ),
      reason: _$values[r'reason'].decodeSimpleNullableString(
        context: r'CreateBanRequest.reason',
      ),
    );
  }

  factory CreateBanRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreateBanRequest');
    return CreateBanRequest(
      createdBy: _$map[r'created_by'].decodeJsonString(
        context: r'CreateBanRequest.created_by',
      ),
      duration: _$map[r'duration'].decodeJsonNullableString(
        context: r'CreateBanRequest.duration',
      ),
      ip: _$map[r'ip'].decodeJsonString(context: r'CreateBanRequest.ip'),
      protocol: _i4.CreateBanRequestProtocolModel.fromJson(_$map[r'protocol']),
      reason: _$map[r'reason'].decodeJsonNullableString(
        context: r'CreateBanRequest.reason',
      ),
    );
  }

  factory CreateBanRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'created_by', r'duration', r'ip', r'protocol', r'reason'},
      listKeys: {},
      context: r'CreateBanRequest',
    );
    return CreateBanRequest(
      createdBy: _$values[r'created_by'].decodeFormString(
        context: r'CreateBanRequest.created_by',
      ),
      duration: _$values[r'duration'].decodeFormNullableString(
        context: r'CreateBanRequest.duration',
      ),
      ip: _$values[r'ip'].decodeFormString(context: r'CreateBanRequest.ip'),
      protocol: _i4.CreateBanRequestProtocolModel.fromForm(
        _$values[r'protocol'],
        explode: explode,
      ),
      reason: _$values[r'reason'].decodeFormNullableString(
        context: r'CreateBanRequest.reason',
      ),
    );
  }

  final _i3.String createdBy;

  final _i3.String? duration;

  final _i3.String ip;

  final _i4.CreateBanRequestProtocolModel protocol;

  final _i3.String? reason;

  @_i3.override
  _i3.Object? toJson() => {
    r'created_by': createdBy,
    r'duration': duration,
    r'ip': ip,
    r'protocol': protocol.toJson(),
    if (reason != null) r'reason': reason,
  };

  $$CreateBanRequestCopyWith<CreateBanRequest> get copyWith =>
      _CreateBanRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateBanRequest &&
        other.createdBy == this.createdBy &&
        other.duration == this.duration &&
        other.ip == this.ip &&
        other.protocol == this.protocol &&
        other.reason == this.reason;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([createdBy, duration, ip, protocol, reason]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'created_by'] = _i1.PropertyValue.scalar(createdBy);
    if (duration != null) {
      _$result[r'duration'] = _i1.PropertyValue.scalar(duration!);
    }
    _$result[r'ip'] = _i1.PropertyValue.scalar(ip);
    _$result[r'protocol'] = _i1.PropertyValue.scalar(protocol.toJson());
    if (reason != null) {
      _$result[r'reason'] = _i1.PropertyValue.scalar(reason!);
    }
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
      r'Cannot uriEncode CreateBanRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreateBanRequestCopyWith<$Res> {
  factory $$CreateBanRequestCopyWith(CreateBanRequest value) =
      _CreateBanRequestCopyWith<$Res>;

  $Res call({
    _i3.String? createdBy,
    _i3.String? duration,
    _i3.String? ip,
    _i4.CreateBanRequestProtocolModel? protocol,
    _i3.String? reason,
  });
  _i3.String get createdBy;
  _i3.String? get duration;
  _i3.String get ip;
  _i4.CreateBanRequestProtocolModel get protocol;
  _i3.String? get reason;
}

class _CreateBanRequestCopyWith<$Res>
    implements $$CreateBanRequestCopyWith<$Res> {
  _CreateBanRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreateBanRequest _value;

  @_i3.override
  _i3.String get createdBy => _value.createdBy;

  @_i3.override
  _i3.String? get duration => _value.duration;

  @_i3.override
  _i3.String get ip => _value.ip;

  @_i3.override
  _i4.CreateBanRequestProtocolModel get protocol => _value.protocol;

  @_i3.override
  _i3.String? get reason => _value.reason;

  @_i3.override
  $Res call({
    _i3.Object? createdBy = _sentinel,
    _i3.Object? duration = _sentinel,
    _i3.Object? ip = _sentinel,
    _i3.Object? protocol = _sentinel,
    _i3.Object? reason = _sentinel,
  }) {
    return (CreateBanRequest(
      createdBy: _i3.identical(createdBy, _sentinel)
          ? this.createdBy
          : (createdBy as _i3.String),
      duration: _i3.identical(duration, _sentinel)
          ? this.duration
          : (duration as _i3.String?),
      ip: _i3.identical(ip, _sentinel) ? this.ip : (ip as _i3.String),
      protocol: _i3.identical(protocol, _sentinel)
          ? this.protocol
          : (protocol as _i4.CreateBanRequestProtocolModel),
      reason: _i3.identical(reason, _sentinel)
          ? this.reason
          : (reason as _i3.String?),
    ) as $Res);
  }
}
