// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class BulkQueueRequestModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const BulkQueueRequestModel({required this.ids});

  factory BulkQueueRequestModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'ids'},
      listKeys: {},
      context: r'BulkQueueRequestModel',
    );
    return BulkQueueRequestModel(ids: _$values[r'ids']);
  }

  factory BulkQueueRequestModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'BulkQueueRequestModel');
    return BulkQueueRequestModel(ids: _$map[r'ids']);
  }

  factory BulkQueueRequestModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'ids'},
      listKeys: {},
      context: r'BulkQueueRequestModel',
    );
    return BulkQueueRequestModel(
      ids: _$values[r'ids'].decodeFormNullableString(
        context: r'BulkQueueRequestModel.ids',
      ),
    );
  }

  final _i3.Object? ids;

  @_i3.override
  _i3.Object? toJson() => {
    r'ids': _i1.encodeUnknownJson(ids, context: r'BulkQueueRequestModel.ids'),
  };

  $$BulkQueueRequestModelCopyWith<BulkQueueRequestModel> get copyWith =>
      _BulkQueueRequestModelCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkQueueRequestModel && other.ids == this.ids;
  }

  @_i3.override
  _i3.int get hashCode => ids.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (ids != null) {
      _$result[r'ids'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          ids!,
          context: r'BulkQueueRequestModel.ids',
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
      r'Cannot uriEncode BulkQueueRequestModel: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$BulkQueueRequestModelCopyWith<$Res> {
  factory $$BulkQueueRequestModelCopyWith(BulkQueueRequestModel value) =
      _BulkQueueRequestModelCopyWith<$Res>;

  $Res call({_i3.Object? ids});
  _i3.Object? get ids;
}

class _BulkQueueRequestModelCopyWith<$Res>
    implements $$BulkQueueRequestModelCopyWith<$Res> {
  _BulkQueueRequestModelCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final BulkQueueRequestModel _value;

  @_i3.override
  _i3.Object? get ids => _value.ids;

  @_i3.override
  $Res call({_i3.Object? ids = _sentinel}) {
    return (BulkQueueRequestModel(
      ids: _i3.identical(ids, _sentinel) ? this.ids : ids,
    ) as $Res);
  }
}
