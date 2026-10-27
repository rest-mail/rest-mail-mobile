// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/dns_record_check_status_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DnsRecordCheck extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DnsRecordCheck({
    required this.name,
    required this.status,
    required this.$type,
    this.message,
    this.value,
  });

  factory DnsRecordCheck.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'message', r'name', r'status', r'type', r'value'},
      listKeys: {},
      context: r'DnsRecordCheck',
    );
    return DnsRecordCheck(
      message: _$values[r'message'].decodeSimpleNullableString(
        context: r'DnsRecordCheck.message',
      ),
      name: _$values[r'name'].decodeSimpleString(
        context: r'DnsRecordCheck.name',
      ),
      status: _i4.DnsRecordCheckStatusModel.fromSimple(
        _$values[r'status'],
        explode: explode,
      ),
      $type: _$values[r'type'].decodeSimpleString(
        context: r'DnsRecordCheck.type',
      ),
      value: _$values[r'value'].decodeSimpleNullableString(
        context: r'DnsRecordCheck.value',
      ),
    );
  }

  factory DnsRecordCheck.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DnsRecordCheck');
    return DnsRecordCheck(
      message: _$map[r'message'].decodeJsonNullableString(
        context: r'DnsRecordCheck.message',
      ),
      name: _$map[r'name'].decodeJsonString(context: r'DnsRecordCheck.name'),
      status: _i4.DnsRecordCheckStatusModel.fromJson(_$map[r'status']),
      $type: _$map[r'type'].decodeJsonString(context: r'DnsRecordCheck.type'),
      value: _$map[r'value'].decodeJsonNullableString(
        context: r'DnsRecordCheck.value',
      ),
    );
  }

  factory DnsRecordCheck.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'message', r'name', r'status', r'type', r'value'},
      listKeys: {},
      context: r'DnsRecordCheck',
    );
    return DnsRecordCheck(
      message: _$values[r'message'].decodeFormNullableString(
        context: r'DnsRecordCheck.message',
      ),
      name: _$values[r'name'].decodeFormString(context: r'DnsRecordCheck.name'),
      status: _i4.DnsRecordCheckStatusModel.fromForm(
        _$values[r'status'],
        explode: explode,
      ),
      $type: _$values[r'type'].decodeFormString(
        context: r'DnsRecordCheck.type',
      ),
      value: _$values[r'value'].decodeFormNullableString(
        context: r'DnsRecordCheck.value',
      ),
    );
  }

  final _i3.String? message;

  final _i3.String name;

  final _i4.DnsRecordCheckStatusModel status;

  final _i3.String $type;

  final _i3.String? value;

  @_i3.override
  _i3.Object? toJson() => {
    if (message != null) r'message': message,
    r'name': name,
    r'status': status.toJson(),
    r'type': $type,
    if (value != null) r'value': value,
  };

  $$DnsRecordCheckCopyWith<DnsRecordCheck> get copyWith =>
      _DnsRecordCheckCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DnsRecordCheck &&
        other.message == this.message &&
        other.name == this.name &&
        other.status == this.status &&
        other.$type == this.$type &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([message, name, status, $type, value]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (message != null) {
      _$result[r'message'] = _i1.PropertyValue.scalar(message!);
    }
    _$result[r'name'] = _i1.PropertyValue.scalar(name);
    _$result[r'status'] = _i1.PropertyValue.scalar(status.toJson());
    _$result[r'type'] = _i1.PropertyValue.scalar($type);
    if (value != null) {
      _$result[r'value'] = _i1.PropertyValue.scalar(value!);
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
      r'Cannot uriEncode DnsRecordCheck: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DnsRecordCheckCopyWith<$Res> {
  factory $$DnsRecordCheckCopyWith(DnsRecordCheck value) =
      _DnsRecordCheckCopyWith<$Res>;

  $Res call({
    _i3.String? message,
    _i3.String? name,
    _i4.DnsRecordCheckStatusModel? status,
    _i3.String? $type,
    _i3.String? value,
  });
  _i3.String? get message;
  _i3.String get name;
  _i4.DnsRecordCheckStatusModel get status;
  _i3.String get $type;
  _i3.String? get value;
}

class _DnsRecordCheckCopyWith<$Res> implements $$DnsRecordCheckCopyWith<$Res> {
  _DnsRecordCheckCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DnsRecordCheck _value;

  @_i3.override
  _i3.String? get message => _value.message;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i4.DnsRecordCheckStatusModel get status => _value.status;

  @_i3.override
  _i3.String get $type => _value.$type;

  @_i3.override
  _i3.String? get value => _value.value;

  @_i3.override
  $Res call({
    _i3.Object? message = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? status = _sentinel,
    _i3.Object? $type = _sentinel,
    _i3.Object? value = _sentinel,
  }) {
    return (DnsRecordCheck(
      message: _i3.identical(message, _sentinel)
          ? this.message
          : (message as _i3.String?),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i4.DnsRecordCheckStatusModel),
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type as _i3.String),
      value: _i3.identical(value, _sentinel)
          ? this.value
          : (value as _i3.String?),
    ) as $Res);
  }
}
