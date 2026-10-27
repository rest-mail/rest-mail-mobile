// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreateGrantHolder extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreateGrantHolder({this.id, this.kind});

  factory CreateGrantHolder.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'kind'},
      listKeys: {},
      context: r'CreateGrantHolder',
    );
    return CreateGrantHolder(
      id: _$values[r'id'].decodeSimpleNullableInt(
        context: r'CreateGrantHolder.id',
      ),
      kind: _$values[r'kind'].decodeSimpleNullableString(
        context: r'CreateGrantHolder.kind',
      ),
    );
  }

  factory CreateGrantHolder.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreateGrantHolder');
    return CreateGrantHolder(
      id: _$map[r'id'].decodeJsonNullableInt(context: r'CreateGrantHolder.id'),
      kind: _$map[r'kind'].decodeJsonNullableString(
        context: r'CreateGrantHolder.kind',
      ),
    );
  }

  factory CreateGrantHolder.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'kind'},
      listKeys: {},
      context: r'CreateGrantHolder',
    );
    return CreateGrantHolder(
      id: _$values[r'id'].decodeFormNullableInt(
        context: r'CreateGrantHolder.id',
      ),
      kind: _$values[r'kind'].decodeFormNullableString(
        context: r'CreateGrantHolder.kind',
      ),
    );
  }

  final _i3.int? id;

  final _i3.String? kind;

  @_i3.override
  _i3.Object? toJson() => {
    if (id != null) r'id': id,
    if (kind != null) r'kind': kind,
  };

  $$CreateGrantHolderCopyWith<CreateGrantHolder> get copyWith =>
      _CreateGrantHolderCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateGrantHolder &&
        other.id == this.id &&
        other.kind == this.kind;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([id, kind]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (id != null) {
      _$result[r'id'] = _i1.PropertyValue.scalar(id!.toString());
    }
    if (kind != null) {
      _$result[r'kind'] = _i1.PropertyValue.scalar(kind!);
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
      r'Cannot uriEncode CreateGrantHolder: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreateGrantHolderCopyWith<$Res> {
  factory $$CreateGrantHolderCopyWith(CreateGrantHolder value) =
      _CreateGrantHolderCopyWith<$Res>;

  $Res call({_i3.int? id, _i3.String? kind});
  _i3.int? get id;
  _i3.String? get kind;
}

class _CreateGrantHolderCopyWith<$Res>
    implements $$CreateGrantHolderCopyWith<$Res> {
  _CreateGrantHolderCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreateGrantHolder _value;

  @_i3.override
  _i3.int? get id => _value.id;

  @_i3.override
  _i3.String? get kind => _value.kind;

  @_i3.override
  $Res call({_i3.Object? id = _sentinel, _i3.Object? kind = _sentinel}) {
    return (CreateGrantHolder(
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int?),
      kind: _i3.identical(kind, _sentinel) ? this.kind : (kind as _i3.String?),
    ) as $Res);
  }
}
