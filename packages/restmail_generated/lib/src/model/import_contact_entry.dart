// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ImportContactEntry extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ImportContactEntry({required this.email, this.name});

  factory ImportContactEntry.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'email', r'name'},
      listKeys: {},
      context: r'ImportContactEntry',
    );
    return ImportContactEntry(
      email: _$values[r'email'].decodeSimpleString(
        context: r'ImportContactEntry.email',
      ),
      name: _$values[r'name'].decodeSimpleNullableString(
        context: r'ImportContactEntry.name',
      ),
    );
  }

  factory ImportContactEntry.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ImportContactEntry');
    return ImportContactEntry(
      email: _$map[r'email'].decodeJsonString(
        context: r'ImportContactEntry.email',
      ),
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'ImportContactEntry.name',
      ),
    );
  }

  factory ImportContactEntry.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'email', r'name'},
      listKeys: {},
      context: r'ImportContactEntry',
    );
    return ImportContactEntry(
      email: _$values[r'email'].decodeFormString(
        context: r'ImportContactEntry.email',
      ),
      name: _$values[r'name'].decodeFormNullableString(
        context: r'ImportContactEntry.name',
      ),
    );
  }

  final _i3.String email;

  final _i3.String? name;

  @_i3.override
  _i3.Object? toJson() => {r'email': email, if (name != null) r'name': name};

  $$ImportContactEntryCopyWith<ImportContactEntry> get copyWith =>
      _ImportContactEntryCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportContactEntry &&
        other.email == this.email &&
        other.name == this.name;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([email, name]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'email'] = _i1.PropertyValue.scalar(email);
    if (name != null) {
      _$result[r'name'] = _i1.PropertyValue.scalar(name!);
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
      r'Cannot uriEncode ImportContactEntry: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ImportContactEntryCopyWith<$Res> {
  factory $$ImportContactEntryCopyWith(ImportContactEntry value) =
      _ImportContactEntryCopyWith<$Res>;

  $Res call({_i3.String? email, _i3.String? name});
  _i3.String get email;
  _i3.String? get name;
}

class _ImportContactEntryCopyWith<$Res>
    implements $$ImportContactEntryCopyWith<$Res> {
  _ImportContactEntryCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ImportContactEntry _value;

  @_i3.override
  _i3.String get email => _value.email;

  @_i3.override
  _i3.String? get name => _value.name;

  @_i3.override
  $Res call({_i3.Object? email = _sentinel, _i3.Object? name = _sentinel}) {
    return (ImportContactEntry(
      email: _i3.identical(email, _sentinel)
          ? this.email
          : (email as _i3.String),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
    ) as $Res);
  }
}
