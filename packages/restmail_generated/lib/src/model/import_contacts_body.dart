// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/import_contact_entry.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ImportContactsBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ImportContactsBody({required this.contacts});

  factory ImportContactsBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ImportContactsBody: contains complex types',
    );
  }

  factory ImportContactsBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ImportContactsBody');
    return ImportContactsBody(
      contacts: _$map[r'contacts']
          .decodeJsonList<_i3.Object?>(context: r'ImportContactsBody.contacts')
          .map(_i4.ImportContactEntry.fromJson)
          .toList(),
    );
  }

  factory ImportContactsBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ImportContactsBody: contains complex types',
    );
  }

  final _i3.List<_i4.ImportContactEntry> contacts;

  @_i3.override
  _i3.Object? toJson() => {
    r'contacts': contacts.map((e) => e.toJson()).toList(),
  };

  $$ImportContactsBodyCopyWith<ImportContactsBody> get copyWith =>
      _ImportContactsBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is ImportContactsBody &&
        _$deepEquals.equals(other.contacts, this.contacts);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return deepEquals.hash(contacts);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ImportContactsBody: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ImportContactsBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ImportContactsBodyCopyWith<$Res> {
  factory $$ImportContactsBodyCopyWith(ImportContactsBody value) =
      _ImportContactsBodyCopyWith<$Res>;

  $Res call({_i3.List<_i4.ImportContactEntry>? contacts});
  _i3.List<_i4.ImportContactEntry> get contacts;
}

class _ImportContactsBodyCopyWith<$Res>
    implements $$ImportContactsBodyCopyWith<$Res> {
  _ImportContactsBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ImportContactsBody _value;

  @_i3.override
  _i3.List<_i4.ImportContactEntry> get contacts => _value.contacts;

  @_i3.override
  $Res call({_i3.Object? contacts = _sentinel}) {
    return (ImportContactsBody(
      contacts: _i3.identical(contacts, _sentinel)
          ? this.contacts
          : (contacts as _i3.List<_i4.ImportContactEntry>),
    ) as $Res);
  }
}
