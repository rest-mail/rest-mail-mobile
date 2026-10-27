// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/send_discarded_status_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SendDiscarded extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SendDiscarded({required this.status});

  factory SendDiscarded.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'status'},
      listKeys: {},
      context: r'SendDiscarded',
    );
    return SendDiscarded(
      status: _i4.SendDiscardedStatusModel.fromSimple(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  factory SendDiscarded.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SendDiscarded');
    return SendDiscarded(
      status: _i4.SendDiscardedStatusModel.fromJson(_$map[r'status']),
    );
  }

  factory SendDiscarded.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'status'},
      listKeys: {},
      context: r'SendDiscarded',
    );
    return SendDiscarded(
      status: _i4.SendDiscardedStatusModel.fromForm(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  final _i4.SendDiscardedStatusModel status;

  @_i3.override
  _i3.Object? toJson() => {r'status': status.toJson()};

  $$SendDiscardedCopyWith<SendDiscarded> get copyWith =>
      _SendDiscardedCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDiscarded && other.status == this.status;
  }

  @_i3.override
  _i3.int get hashCode => status.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
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
      r'Cannot uriEncode SendDiscarded: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SendDiscardedCopyWith<$Res> {
  factory $$SendDiscardedCopyWith(SendDiscarded value) =
      _SendDiscardedCopyWith<$Res>;

  $Res call({_i4.SendDiscardedStatusModel? status});
  _i4.SendDiscardedStatusModel get status;
}

class _SendDiscardedCopyWith<$Res> implements $$SendDiscardedCopyWith<$Res> {
  _SendDiscardedCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SendDiscarded _value;

  @_i3.override
  _i4.SendDiscardedStatusModel get status => _value.status;

  @_i3.override
  $Res call({_i3.Object? status = _sentinel}) {
    return (SendDiscarded(
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i4.SendDiscardedStatusModel),
    ) as $Res);
  }
}
