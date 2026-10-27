// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/bulk_queue_request_filter_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class BulkQueueRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const BulkQueueRequest({this.filter, this.ids});

  factory BulkQueueRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for BulkQueueRequest: contains complex types',
    );
  }

  factory BulkQueueRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'BulkQueueRequest');
    return BulkQueueRequest(
      filter: _$map[r'filter'] == null
          ? null
          : _i4.BulkQueueRequestFilterModel.fromJson(_$map[r'filter']),
      ids: _$map[r'ids'].decodeJsonNullableList<_i3.int>(
        context: r'BulkQueueRequest.ids',
      ),
    );
  }

  factory BulkQueueRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for BulkQueueRequest: contains complex types',
    );
  }

  final _i4.BulkQueueRequestFilterModel? filter;

  final _i3.List<_i3.int>? ids;

  @_i3.override
  _i3.Object? toJson() => {
    r'filter': filter?.toJson(),
    if (ids != null) r'ids': ids,
  };

  $$BulkQueueRequestCopyWith<BulkQueueRequest> get copyWith =>
      _BulkQueueRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is BulkQueueRequest &&
        other.filter == this.filter &&
        _$deepEquals.equals(other.ids, this.ids);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([filter, deepEquals.hash(ids)]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for BulkQueueRequest: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode BulkQueueRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$BulkQueueRequestCopyWith<$Res> {
  factory $$BulkQueueRequestCopyWith(BulkQueueRequest value) =
      _BulkQueueRequestCopyWith<$Res>;

  $Res call({_i4.BulkQueueRequestFilterModel? filter, _i3.List<_i3.int>? ids});
  _i4.BulkQueueRequestFilterModel? get filter;
  _i3.List<_i3.int>? get ids;
}

class _BulkQueueRequestCopyWith<$Res>
    implements $$BulkQueueRequestCopyWith<$Res> {
  _BulkQueueRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final BulkQueueRequest _value;

  @_i3.override
  _i4.BulkQueueRequestFilterModel? get filter => _value.filter;

  @_i3.override
  _i3.List<_i3.int>? get ids => _value.ids;

  @_i3.override
  $Res call({_i3.Object? filter = _sentinel, _i3.Object? ids = _sentinel}) {
    return (BulkQueueRequest(
      filter: _i3.identical(filter, _sentinel)
          ? this.filter
          : (filter as _i4.BulkQueueRequestFilterModel?),
      ids: _i3.identical(ids, _sentinel)
          ? this.ids
          : (ids as _i3.List<_i3.int>?),
    ) as $Res);
  }
}
