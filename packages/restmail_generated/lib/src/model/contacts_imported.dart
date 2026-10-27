// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ContactsImported extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ContactsImported({required this.imported});

  factory ContactsImported.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'imported'},
      listKeys: {},
      context: r'ContactsImported',
    );
    return ContactsImported(
      imported: _$values[r'imported'].decodeSimpleInt(
        context: r'ContactsImported.imported',
      ),
    );
  }

  factory ContactsImported.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ContactsImported');
    return ContactsImported(
      imported: _$map[r'imported'].decodeJsonInt(
        context: r'ContactsImported.imported',
      ),
    );
  }

  factory ContactsImported.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'imported'},
      listKeys: {},
      context: r'ContactsImported',
    );
    return ContactsImported(
      imported: _$values[r'imported'].decodeFormInt(
        context: r'ContactsImported.imported',
      ),
    );
  }

  final _i3.int imported;

  @_i3.override
  _i3.Object? toJson() => {r'imported': imported};

  $$ContactsImportedCopyWith<ContactsImported> get copyWith =>
      _ContactsImportedCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ContactsImported && other.imported == this.imported;
  }

  @_i3.override
  _i3.int get hashCode => imported.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'imported'] = _i1.PropertyValue.scalar(imported.toString());
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
      r'Cannot uriEncode ContactsImported: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ContactsImportedCopyWith<$Res> {
  factory $$ContactsImportedCopyWith(ContactsImported value) =
      _ContactsImportedCopyWith<$Res>;

  $Res call({_i3.int? imported});
  _i3.int get imported;
}

class _ContactsImportedCopyWith<$Res>
    implements $$ContactsImportedCopyWith<$Res> {
  _ContactsImportedCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ContactsImported _value;

  @_i3.override
  _i3.int get imported => _value.imported;

  @_i3.override
  $Res call({_i3.Object? imported = _sentinel}) {
    return (ContactsImported(
      imported: _i3.identical(imported, _sentinel)
          ? this.imported
          : (imported as _i3.int),
    ) as $Res);
  }
}
