// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class QueueAction extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const QueueAction({required this.status});

  factory QueueAction.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'status'},
      listKeys: {},
      context: r'QueueAction',
    );
    return QueueAction(
      status: _$values[r'status'].decodeSimpleString(
        context: r'QueueAction.status',
      ),
    );
  }

  factory QueueAction.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'QueueAction');
    return QueueAction(
      status: _$map[r'status'].decodeJsonString(context: r'QueueAction.status'),
    );
  }

  factory QueueAction.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'status'},
      listKeys: {},
      context: r'QueueAction',
    );
    return QueueAction(
      status: _$values[r'status'].decodeFormString(
        context: r'QueueAction.status',
      ),
    );
  }

  final _i3.String status;

  @_i3.override
  _i3.Object? toJson() => {r'status': status};

  $$QueueActionCopyWith<QueueAction> get copyWith => _QueueActionCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is QueueAction && other.status == this.status;
  }

  @_i3.override
  _i3.int get hashCode => status.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'status'] = _i1.PropertyValue.scalar(status);
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
      r'Cannot uriEncode QueueAction: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$QueueActionCopyWith<$Res> {
  factory $$QueueActionCopyWith(QueueAction value) = _QueueActionCopyWith<$Res>;

  $Res call({_i3.String? status});
  _i3.String get status;
}

class _QueueActionCopyWith<$Res> implements $$QueueActionCopyWith<$Res> {
  _QueueActionCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final QueueAction _value;

  @_i3.override
  _i3.String get status => _value.status;

  @_i3.override
  $Res call({_i3.Object? status = _sentinel}) {
    return (QueueAction(
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i3.String),
    ) as $Res);
  }
}
