// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/delivery_processed_status_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DeliveryProcessed extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DeliveryProcessed({required this.status});

  factory DeliveryProcessed.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'status'},
      listKeys: {},
      context: r'DeliveryProcessed',
    );
    return DeliveryProcessed(
      status: _i4.DeliveryProcessedStatusModel.fromSimple(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  factory DeliveryProcessed.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DeliveryProcessed');
    return DeliveryProcessed(
      status: _i4.DeliveryProcessedStatusModel.fromJson(_$map[r'status']),
    );
  }

  factory DeliveryProcessed.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'status'},
      listKeys: {},
      context: r'DeliveryProcessed',
    );
    return DeliveryProcessed(
      status: _i4.DeliveryProcessedStatusModel.fromForm(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  final _i4.DeliveryProcessedStatusModel status;

  @_i3.override
  _i3.Object? toJson() => {r'status': status.toJson()};

  $$DeliveryProcessedCopyWith<DeliveryProcessed> get copyWith =>
      _DeliveryProcessedCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliveryProcessed && other.status == this.status;
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
      r'Cannot uriEncode DeliveryProcessed: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DeliveryProcessedCopyWith<$Res> {
  factory $$DeliveryProcessedCopyWith(DeliveryProcessed value) =
      _DeliveryProcessedCopyWith<$Res>;

  $Res call({_i4.DeliveryProcessedStatusModel? status});
  _i4.DeliveryProcessedStatusModel get status;
}

class _DeliveryProcessedCopyWith<$Res>
    implements $$DeliveryProcessedCopyWith<$Res> {
  _DeliveryProcessedCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DeliveryProcessed _value;

  @_i3.override
  _i4.DeliveryProcessedStatusModel get status => _value.status;

  @_i3.override
  $Res call({_i3.Object? status = _sentinel}) {
    return (DeliveryProcessed(
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i4.DeliveryProcessedStatusModel),
    ) as $Res);
  }
}
