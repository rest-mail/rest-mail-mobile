// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/queue_action.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DataQueueAction extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DataQueueAction({required this.data});

  factory DataQueueAction.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DataQueueAction: contains complex types',
    );
  }

  factory DataQueueAction.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DataQueueAction');
    return DataQueueAction(data: _i4.QueueAction.fromJson(_$map[r'data']));
  }

  factory DataQueueAction.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DataQueueAction: contains complex types',
    );
  }

  final _i4.QueueAction data;

  @_i3.override
  _i3.Object? toJson() => {r'data': data.toJson()};

  $$DataQueueActionCopyWith<DataQueueAction> get copyWith =>
      _DataQueueActionCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DataQueueAction && other.data == this.data;
  }

  @_i3.override
  _i3.int get hashCode => data.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DataQueueAction: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DataQueueAction: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DataQueueActionCopyWith<$Res> {
  factory $$DataQueueActionCopyWith(DataQueueAction value) =
      _DataQueueActionCopyWith<$Res>;

  $Res call({_i4.QueueAction? data});
  _i4.QueueAction get data;
}

class _DataQueueActionCopyWith<$Res>
    implements $$DataQueueActionCopyWith<$Res> {
  _DataQueueActionCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DataQueueAction _value;

  @_i3.override
  _i4.QueueAction get data => _value.data;

  @_i3.override
  $Res call({_i3.Object? data = _sentinel}) {
    return (DataQueueAction(
      data: _i3.identical(data, _sentinel)
          ? this.data
          : (data as _i4.QueueAction),
    ) as $Res);
  }
}
