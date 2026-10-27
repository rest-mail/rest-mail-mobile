// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/quarantine_released_status_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class QuarantineReleased extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const QuarantineReleased({required this.messageId, required this.status});

  factory QuarantineReleased.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'message_id', r'status'},
      listKeys: {},
      context: r'QuarantineReleased',
    );
    return QuarantineReleased(
      messageId: _$values[r'message_id'].decodeSimpleString(
        context: r'QuarantineReleased.message_id',
      ),
      status: _i4.QuarantineReleasedStatusModel.fromSimple(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  factory QuarantineReleased.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'QuarantineReleased');
    return QuarantineReleased(
      messageId: _$map[r'message_id'].decodeJsonString(
        context: r'QuarantineReleased.message_id',
      ),
      status: _i4.QuarantineReleasedStatusModel.fromJson(_$map[r'status']),
    );
  }

  factory QuarantineReleased.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'message_id', r'status'},
      listKeys: {},
      context: r'QuarantineReleased',
    );
    return QuarantineReleased(
      messageId: _$values[r'message_id'].decodeFormString(
        context: r'QuarantineReleased.message_id',
      ),
      status: _i4.QuarantineReleasedStatusModel.fromForm(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  final _i3.String messageId;

  final _i4.QuarantineReleasedStatusModel status;

  @_i3.override
  _i3.Object? toJson() => {
    r'message_id': messageId,
    r'status': status.toJson(),
  };

  $$QuarantineReleasedCopyWith<QuarantineReleased> get copyWith =>
      _QuarantineReleasedCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is QuarantineReleased &&
        other.messageId == this.messageId &&
        other.status == this.status;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([messageId, status]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'message_id'] = _i1.PropertyValue.scalar(messageId);
    _$result[r'status'] = _i1.PropertyValue.scalar(status.toJson());
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
      r'Cannot uriEncode QuarantineReleased: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$QuarantineReleasedCopyWith<$Res> {
  factory $$QuarantineReleasedCopyWith(QuarantineReleased value) =
      _QuarantineReleasedCopyWith<$Res>;

  $Res call({_i3.String? messageId, _i4.QuarantineReleasedStatusModel? status});
  _i3.String get messageId;
  _i4.QuarantineReleasedStatusModel get status;
}

class _QuarantineReleasedCopyWith<$Res>
    implements $$QuarantineReleasedCopyWith<$Res> {
  _QuarantineReleasedCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final QuarantineReleased _value;

  @_i3.override
  _i3.String get messageId => _value.messageId;

  @_i3.override
  _i4.QuarantineReleasedStatusModel get status => _value.status;

  @_i3.override
  $Res call({
    _i3.Object? messageId = _sentinel,
    _i3.Object? status = _sentinel,
  }) {
    return (QuarantineReleased(
      messageId: _i3.identical(messageId, _sentinel)
          ? this.messageId
          : (messageId as _i3.String),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i4.QuarantineReleasedStatusModel),
    ) as $Res);
  }
}
