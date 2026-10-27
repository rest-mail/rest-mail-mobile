// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class $RawBulkQueueRequestFilterModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const $RawBulkQueueRequestFilterModel({
    this.domain,
    this.recipient,
    this.sender,
    this.status,
  });

  factory $RawBulkQueueRequestFilterModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'domain', r'recipient', r'sender', r'status'},
      listKeys: {},
      context: r'$RawBulkQueueRequestFilterModel',
    );
    return $RawBulkQueueRequestFilterModel(
      domain: _$values[r'domain'].decodeSimpleNullableString(
        context: r'$RawBulkQueueRequestFilterModel.domain',
      ),
      recipient: _$values[r'recipient'].decodeSimpleNullableString(
        context: r'$RawBulkQueueRequestFilterModel.recipient',
      ),
      sender: _$values[r'sender'].decodeSimpleNullableString(
        context: r'$RawBulkQueueRequestFilterModel.sender',
      ),
      status: _$values[r'status'].decodeSimpleNullableString(
        context: r'$RawBulkQueueRequestFilterModel.status',
      ),
    );
  }

  factory $RawBulkQueueRequestFilterModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'$RawBulkQueueRequestFilterModel');
    return $RawBulkQueueRequestFilterModel(
      domain: _$map[r'domain'].decodeJsonNullableString(
        context: r'$RawBulkQueueRequestFilterModel.domain',
      ),
      recipient: _$map[r'recipient'].decodeJsonNullableString(
        context: r'$RawBulkQueueRequestFilterModel.recipient',
      ),
      sender: _$map[r'sender'].decodeJsonNullableString(
        context: r'$RawBulkQueueRequestFilterModel.sender',
      ),
      status: _$map[r'status'].decodeJsonNullableString(
        context: r'$RawBulkQueueRequestFilterModel.status',
      ),
    );
  }

  factory $RawBulkQueueRequestFilterModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'domain', r'recipient', r'sender', r'status'},
      listKeys: {},
      context: r'$RawBulkQueueRequestFilterModel',
    );
    return $RawBulkQueueRequestFilterModel(
      domain: _$values[r'domain'].decodeFormNullableString(
        context: r'$RawBulkQueueRequestFilterModel.domain',
      ),
      recipient: _$values[r'recipient'].decodeFormNullableString(
        context: r'$RawBulkQueueRequestFilterModel.recipient',
      ),
      sender: _$values[r'sender'].decodeFormNullableString(
        context: r'$RawBulkQueueRequestFilterModel.sender',
      ),
      status: _$values[r'status'].decodeFormNullableString(
        context: r'$RawBulkQueueRequestFilterModel.status',
      ),
    );
  }

  final _i3.String? domain;

  final _i3.String? recipient;

  final _i3.String? sender;

  final _i3.String? status;

  @_i3.override
  _i3.Object? toJson() => {
    if (domain != null) r'domain': domain,
    if (recipient != null) r'recipient': recipient,
    if (sender != null) r'sender': sender,
    if (status != null) r'status': status,
  };

  $$$RawBulkQueueRequestFilterModelCopyWith<$RawBulkQueueRequestFilterModel>
  get copyWith => _$RawBulkQueueRequestFilterModelCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is $RawBulkQueueRequestFilterModel &&
        other.domain == this.domain &&
        other.recipient == this.recipient &&
        other.sender == this.sender &&
        other.status == this.status;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([domain, recipient, sender, status]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (domain != null) {
      _$result[r'domain'] = _i1.PropertyValue.scalar(domain!);
    }
    if (recipient != null) {
      _$result[r'recipient'] = _i1.PropertyValue.scalar(recipient!);
    }
    if (sender != null) {
      _$result[r'sender'] = _i1.PropertyValue.scalar(sender!);
    }
    if (status != null) {
      _$result[r'status'] = _i1.PropertyValue.scalar(status!);
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
      r'Cannot uriEncode $RawBulkQueueRequestFilterModel: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$$RawBulkQueueRequestFilterModelCopyWith<$Res> {
  factory $$$RawBulkQueueRequestFilterModelCopyWith(
    $RawBulkQueueRequestFilterModel value,
  ) = _$RawBulkQueueRequestFilterModelCopyWith<$Res>;

  $Res call({
    _i3.String? domain,
    _i3.String? recipient,
    _i3.String? sender,
    _i3.String? status,
  });
  _i3.String? get domain;
  _i3.String? get recipient;
  _i3.String? get sender;
  _i3.String? get status;
}

class _$RawBulkQueueRequestFilterModelCopyWith<$Res>
    implements $$$RawBulkQueueRequestFilterModelCopyWith<$Res> {
  _$RawBulkQueueRequestFilterModelCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final $RawBulkQueueRequestFilterModel _value;

  @_i3.override
  _i3.String? get domain => _value.domain;

  @_i3.override
  _i3.String? get recipient => _value.recipient;

  @_i3.override
  _i3.String? get sender => _value.sender;

  @_i3.override
  _i3.String? get status => _value.status;

  @_i3.override
  $Res call({
    _i3.Object? domain = _sentinel,
    _i3.Object? recipient = _sentinel,
    _i3.Object? sender = _sentinel,
    _i3.Object? status = _sentinel,
  }) {
    return ($RawBulkQueueRequestFilterModel(
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i3.String?),
      recipient: _i3.identical(recipient, _sentinel)
          ? this.recipient
          : (recipient as _i3.String?),
      sender: _i3.identical(sender, _sentinel)
          ? this.sender
          : (sender as _i3.String?),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i3.String?),
    ) as $Res);
  }
}

typedef BulkQueueRequestFilterModel = $RawBulkQueueRequestFilterModel?;
