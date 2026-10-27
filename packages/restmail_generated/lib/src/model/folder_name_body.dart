// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FolderNameBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FolderNameBody({required this.name});

  factory FolderNameBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'name'},
      listKeys: {},
      context: r'FolderNameBody',
    );
    return FolderNameBody(
      name: _$values[r'name'].decodeSimpleString(
        context: r'FolderNameBody.name',
      ),
    );
  }

  factory FolderNameBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'FolderNameBody');
    return FolderNameBody(
      name: _$map[r'name'].decodeJsonString(context: r'FolderNameBody.name'),
    );
  }

  factory FolderNameBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'name'},
      listKeys: {},
      context: r'FolderNameBody',
    );
    return FolderNameBody(
      name: _$values[r'name'].decodeFormString(context: r'FolderNameBody.name'),
    );
  }

  final _i3.String name;

  @_i3.override
  _i3.Object? toJson() => {r'name': name};

  $$FolderNameBodyCopyWith<FolderNameBody> get copyWith =>
      _FolderNameBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is FolderNameBody && other.name == this.name;
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
      r'Cannot uriEncode FolderNameBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$FolderNameBodyCopyWith<$Res> {
  factory $$FolderNameBodyCopyWith(FolderNameBody value) =
      _FolderNameBodyCopyWith<$Res>;

  $Res call({_i3.String? name});
  _i3.String get name;
}

class _FolderNameBodyCopyWith<$Res> implements $$FolderNameBodyCopyWith<$Res> {
  _FolderNameBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final FolderNameBody _value;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  $Res call({_i3.Object? name = _sentinel}) {
    return (FolderNameBody(
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
    ) as $Res);
  }
}
