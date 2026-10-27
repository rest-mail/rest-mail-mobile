// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class BulkQueueResult extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const BulkQueueResult({required this.affected});

  factory BulkQueueResult.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'affected'},
      listKeys: {},
      context: r'BulkQueueResult',
    );
    return BulkQueueResult(
      affected: _$values[r'affected'].decodeSimpleInt(
        context: r'BulkQueueResult.affected',
      ),
    );
  }

  factory BulkQueueResult.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'BulkQueueResult');
    return BulkQueueResult(
      affected: _$map[r'affected'].decodeJsonInt(
        context: r'BulkQueueResult.affected',
      ),
    );
  }

  factory BulkQueueResult.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'affected'},
      listKeys: {},
      context: r'BulkQueueResult',
    );
    return BulkQueueResult(
      affected: _$values[r'affected'].decodeFormInt(
        context: r'BulkQueueResult.affected',
      ),
    );
  }

  final _i3.int affected;

  @_i3.override
  _i3.Object? toJson() => {r'affected': affected};

  $$BulkQueueResultCopyWith<BulkQueueResult> get copyWith =>
      _BulkQueueResultCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkQueueResult && other.affected == this.affected;
  }

  @_i3.override
  _i3.int get hashCode => affected.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'affected'] = _i1.PropertyValue.scalar(affected.toString());
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
      r'Cannot uriEncode BulkQueueResult: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$BulkQueueResultCopyWith<$Res> {
  factory $$BulkQueueResultCopyWith(BulkQueueResult value) =
      _BulkQueueResultCopyWith<$Res>;

  $Res call({_i3.int? affected});
  _i3.int get affected;
}

class _BulkQueueResultCopyWith<$Res>
    implements $$BulkQueueResultCopyWith<$Res> {
  _BulkQueueResultCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final BulkQueueResult _value;

  @_i3.override
  _i3.int get affected => _value.affected;

  @_i3.override
  $Res call({_i3.Object? affected = _sentinel}) {
    return (BulkQueueResult(
      affected: _i3.identical(affected, _sentinel)
          ? this.affected
          : (affected as _i3.int),
    ) as $Res);
  }
}
