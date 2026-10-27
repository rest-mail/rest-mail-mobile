// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Entry extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Entry({required this.capability, required this.scope});

  factory Entry.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'capability', r'scope'},
      listKeys: {},
      context: r'Entry',
    );
    return Entry(
      capability: _$values[r'capability'].decodeSimpleString(
        context: r'Entry.capability',
      ),
      scope: _$values[r'scope'].decodeSimpleString(context: r'Entry.scope'),
    );
  }

  factory Entry.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Entry');
    return Entry(
      capability: _$map[r'capability'].decodeJsonString(
        context: r'Entry.capability',
      ),
      scope: _$map[r'scope'].decodeJsonString(context: r'Entry.scope'),
    );
  }

  factory Entry.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'capability', r'scope'},
      listKeys: {},
      context: r'Entry',
    );
    return Entry(
      capability: _$values[r'capability'].decodeFormString(
        context: r'Entry.capability',
      ),
      scope: _$values[r'scope'].decodeFormString(context: r'Entry.scope'),
    );
  }

  final _i3.String capability;

  final _i3.String scope;

  @_i3.override
  _i3.Object? toJson() => {r'capability': capability, r'scope': scope};

  $$EntryCopyWith<Entry> get copyWith => _EntryCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Entry &&
        other.capability == this.capability &&
        other.scope == this.scope;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([capability, scope]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'capability'] = _i1.PropertyValue.scalar(capability);
    _$result[r'scope'] = _i1.PropertyValue.scalar(scope);
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
      r'Cannot uriEncode Entry: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$EntryCopyWith<$Res> {
  factory $$EntryCopyWith(Entry value) = _EntryCopyWith<$Res>;

  $Res call({_i3.String? capability, _i3.String? scope});
  _i3.String get capability;
  _i3.String get scope;
}

class _EntryCopyWith<$Res> implements $$EntryCopyWith<$Res> {
  _EntryCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Entry _value;

  @_i3.override
  _i3.String get capability => _value.capability;

  @_i3.override
  _i3.String get scope => _value.scope;

  @_i3.override
  $Res call({
    _i3.Object? capability = _sentinel,
    _i3.Object? scope = _sentinel,
  }) {
    return (Entry(
      capability: _i3.identical(capability, _sentinel)
          ? this.capability
          : (capability as _i3.String),
      scope: _i3.identical(scope, _sentinel)
          ? this.scope
          : (scope as _i3.String),
    ) as $Res);
  }
}
