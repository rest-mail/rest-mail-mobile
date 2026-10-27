// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/sieve_deleted_status_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SieveDeleted extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SieveDeleted({required this.status});

  factory SieveDeleted.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'status'},
      listKeys: {},
      context: r'SieveDeleted',
    );
    return SieveDeleted(
      status: _i4.SieveDeletedStatusModel.fromSimple(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  factory SieveDeleted.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SieveDeleted');
    return SieveDeleted(
      status: _i4.SieveDeletedStatusModel.fromJson(_$map[r'status']),
    );
  }

  factory SieveDeleted.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'status'},
      listKeys: {},
      context: r'SieveDeleted',
    );
    return SieveDeleted(
      status: _i4.SieveDeletedStatusModel.fromForm(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  final _i4.SieveDeletedStatusModel status;

  @_i3.override
  _i3.Object? toJson() => {r'status': status.toJson()};

  $$SieveDeletedCopyWith<SieveDeleted> get copyWith =>
      _SieveDeletedCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SieveDeleted && other.status == this.status;
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
      r'Cannot uriEncode SieveDeleted: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SieveDeletedCopyWith<$Res> {
  factory $$SieveDeletedCopyWith(SieveDeleted value) =
      _SieveDeletedCopyWith<$Res>;

  $Res call({_i4.SieveDeletedStatusModel? status});
  _i4.SieveDeletedStatusModel get status;
}

class _SieveDeletedCopyWith<$Res> implements $$SieveDeletedCopyWith<$Res> {
  _SieveDeletedCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SieveDeleted _value;

  @_i3.override
  _i4.SieveDeletedStatusModel get status => _value.status;

  @_i3.override
  $Res call({_i3.Object? status = _sentinel}) {
    return (SieveDeleted(
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i4.SieveDeletedStatusModel),
    ) as $Res);
  }
}
