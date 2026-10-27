// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FolderName extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FolderName({required this.name});

  factory FolderName.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'name'},
      listKeys: {},
      context: r'FolderName',
    );
    return FolderName(
      name: _$values[r'name'].decodeSimpleString(context: r'FolderName.name'),
    );
  }

  factory FolderName.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'FolderName');
    return FolderName(
      name: _$map[r'name'].decodeJsonString(context: r'FolderName.name'),
    );
  }

  factory FolderName.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'name'},
      listKeys: {},
      context: r'FolderName',
    );
    return FolderName(
      name: _$values[r'name'].decodeFormString(context: r'FolderName.name'),
    );
  }

  final _i3.String name;

  @_i3.override
  _i3.Object? toJson() => {r'name': name};

  $$FolderNameCopyWith<FolderName> get copyWith => _FolderNameCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is FolderName && other.name == this.name;
  }

  @_i3.override
  _i3.int get hashCode => name.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'name'] = _i1.PropertyValue.scalar(name);
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
      r'Cannot uriEncode FolderName: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$FolderNameCopyWith<$Res> {
  factory $$FolderNameCopyWith(FolderName value) = _FolderNameCopyWith<$Res>;

  $Res call({_i3.String? name});
  _i3.String get name;
}

class _FolderNameCopyWith<$Res> implements $$FolderNameCopyWith<$Res> {
  _FolderNameCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final FolderName _value;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  $Res call({_i3.Object? name = _sentinel}) {
    return (FolderName(
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
    ) as $Res);
  }
}
