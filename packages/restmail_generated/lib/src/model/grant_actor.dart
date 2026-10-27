// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/grant_actor_kind_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class GrantActor extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const GrantActor({required this.id, required this.kind});

  factory GrantActor.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'kind'},
      listKeys: {},
      context: r'GrantActor',
    );
    return GrantActor(
      id: _$values[r'id'].decodeSimpleNullableInt(context: r'GrantActor.id'),
      kind: _i4.GrantActorKindModel.fromSimple(
        _$values[r'kind'],
        explode: explode,
      ),
    );
  }

  factory GrantActor.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'GrantActor');
    return GrantActor(
      id: _$map[r'id'].decodeJsonNullableInt(context: r'GrantActor.id'),
      kind: _i4.GrantActorKindModel.fromJson(_$map[r'kind']),
    );
  }

  factory GrantActor.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'kind'},
      listKeys: {},
      context: r'GrantActor',
    );
    return GrantActor(
      id: _$values[r'id'].decodeFormNullableInt(context: r'GrantActor.id'),
      kind: _i4.GrantActorKindModel.fromForm(
        _$values[r'kind'],
        explode: explode,
      ),
    );
  }

  final _i3.int? id;

  final _i4.GrantActorKindModel kind;

  @_i3.override
  _i3.Object? toJson() => {r'id': id, r'kind': kind.toJson()};

  $$GrantActorCopyWith<GrantActor> get copyWith => _GrantActorCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GrantActor &&
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
    _$result[r'kind'] = _i1.PropertyValue.scalar(kind.toJson());
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
      r'Cannot uriEncode GrantActor: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$GrantActorCopyWith<$Res> {
  factory $$GrantActorCopyWith(GrantActor value) = _GrantActorCopyWith<$Res>;

  $Res call({_i3.int? id, _i4.GrantActorKindModel? kind});
  _i3.int? get id;
  _i4.GrantActorKindModel get kind;
}

class _GrantActorCopyWith<$Res> implements $$GrantActorCopyWith<$Res> {
  _GrantActorCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final GrantActor _value;

  @_i3.override
  _i3.int? get id => _value.id;

  @_i3.override
  _i4.GrantActorKindModel get kind => _value.kind;

  @_i3.override
  $Res call({_i3.Object? id = _sentinel, _i3.Object? kind = _sentinel}) {
    return (GrantActor(
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int?),
      kind: _i3.identical(kind, _sentinel)
          ? this.kind
          : (kind as _i4.GrantActorKindModel),
    ) as $Res);
  }
}
