// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/quarantine_deleted_status_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class QuarantineDeleted extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const QuarantineDeleted({required this.status});

  factory QuarantineDeleted.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'status'},
      listKeys: {},
      context: r'QuarantineDeleted',
    );
    return QuarantineDeleted(
      status: _i4.QuarantineDeletedStatusModel.fromSimple(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  factory QuarantineDeleted.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'QuarantineDeleted');
    return QuarantineDeleted(
      status: _i4.QuarantineDeletedStatusModel.fromJson(_$map[r'status']),
    );
  }

  factory QuarantineDeleted.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'status'},
      listKeys: {},
      context: r'QuarantineDeleted',
    );
    return QuarantineDeleted(
      status: _i4.QuarantineDeletedStatusModel.fromForm(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  final _i4.QuarantineDeletedStatusModel status;

  @_i3.override
  _i3.Object? toJson() => {r'status': status.toJson()};

  $$QuarantineDeletedCopyWith<QuarantineDeleted> get copyWith =>
      _QuarantineDeletedCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is QuarantineDeleted && other.status == this.status;
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
      r'Cannot uriEncode QuarantineDeleted: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$QuarantineDeletedCopyWith<$Res> {
  factory $$QuarantineDeletedCopyWith(QuarantineDeleted value) =
      _QuarantineDeletedCopyWith<$Res>;

  $Res call({_i4.QuarantineDeletedStatusModel? status});
  _i4.QuarantineDeletedStatusModel get status;
}

class _QuarantineDeletedCopyWith<$Res>
    implements $$QuarantineDeletedCopyWith<$Res> {
  _QuarantineDeletedCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final QuarantineDeleted _value;

  @_i3.override
  _i4.QuarantineDeletedStatusModel get status => _value.status;

  @_i3.override
  $Res call({_i3.Object? status = _sentinel}) {
    return (QuarantineDeleted(
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i4.QuarantineDeletedStatusModel),
    ) as $Res);
  }
}
