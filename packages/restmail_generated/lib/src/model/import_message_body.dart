// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ImportMessageBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ImportMessageBody({
    required this.internalDate,
    required this.rawMessage,
    this.flags,
    this.folder,
  });

  factory ImportMessageBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'flags', r'folder', r'internal_date', r'raw_message'},
      listKeys: {r'flags'},
      context: r'ImportMessageBody',
    );
    return ImportMessageBody(
      flags: _$values[r'flags'].decodeSimpleNullableStringList(
        context: r'ImportMessageBody.flags',
      ),
      folder: _$values[r'folder'].decodeSimpleNullableString(
        context: r'ImportMessageBody.folder',
      ),
      internalDate: _$values[r'internal_date'].decodeSimpleDateTime(
        context: r'ImportMessageBody.internal_date',
      ),
      rawMessage: _i1.TonikFileBytes(
        _$values[r'raw_message'].decodeSimpleBase64(
          context: r'ImportMessageBody.raw_message',
        ),
      ),
    );
  }

  factory ImportMessageBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ImportMessageBody');
    return ImportMessageBody(
      flags: _$map[r'flags'].decodeJsonNullableList<_i3.String>(
        context: r'ImportMessageBody.flags',
      ),
      folder: _$map[r'folder'].decodeJsonNullableString(
        context: r'ImportMessageBody.folder',
      ),
      internalDate: _$map[r'internal_date'].decodeJsonDateTime(
        context: r'ImportMessageBody.internal_date',
      ),
      rawMessage: _i1.TonikFileBytes(
        _$map[r'raw_message'].decodeJsonBase64(
          context: r'ImportMessageBody.raw_message',
        ),
      ),
    );
  }

  factory ImportMessageBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'flags', r'folder', r'internal_date', r'raw_message'},
      listKeys: {r'flags'},
      context: r'ImportMessageBody',
    );
    return ImportMessageBody(
      flags: _$values[r'flags'].decodeFormNullableStringList(
        context: r'ImportMessageBody.flags',
      ),
      folder: _$values[r'folder'].decodeFormNullableString(
        context: r'ImportMessageBody.folder',
      ),
      internalDate: _$values[r'internal_date'].decodeFormDateTime(
        context: r'ImportMessageBody.internal_date',
      ),
      rawMessage: _i1.TonikFileBytes(
        _$values[r'raw_message'].decodeFormBase64(
          context: r'ImportMessageBody.raw_message',
        ),
      ),
    );
  }

  final _i3.List<_i3.String>? flags;

  final _i3.String? folder;

  final _i3.DateTime internalDate;

  final _i1.TonikFile rawMessage;

  @_i3.override
  _i3.Object? toJson() => {
    if (flags != null) r'flags': flags,
    if (folder != null) r'folder': folder,
    r'internal_date': internalDate.toTimeZonedIso8601String(),
    r'raw_message': rawMessage.toBytes().encodeToBase64String(),
  };

  $$ImportMessageBodyCopyWith<ImportMessageBody> get copyWith =>
      _ImportMessageBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is ImportMessageBody &&
        _$deepEquals.equals(other.flags, this.flags) &&
        other.folder == this.folder &&
        other.internalDate == this.internalDate &&
        other.rawMessage == this.rawMessage;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(flags),
      folder,
      internalDate,
      rawMessage,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (flags != null) {
      _$result[r'flags'] = _i1.PropertyValue.array(flags!);
    }
    if (folder != null) {
      _$result[r'folder'] = _i1.PropertyValue.scalar(folder!);
    }
    _$result[r'internal_date'] = _i1.PropertyValue.scalar(
      internalDate.toTimeZonedIso8601String(),
    );
    _$result[r'raw_message'] = _i1.PropertyValue.scalar(
      rawMessage.toBase64String(),
    );
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
      r'Cannot uriEncode ImportMessageBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ImportMessageBodyCopyWith<$Res> {
  factory $$ImportMessageBodyCopyWith(ImportMessageBody value) =
      _ImportMessageBodyCopyWith<$Res>;

  $Res call({
    _i3.List<_i3.String>? flags,
    _i3.String? folder,
    _i3.DateTime? internalDate,
    _i1.TonikFile? rawMessage,
  });
  _i3.List<_i3.String>? get flags;
  _i3.String? get folder;
  _i3.DateTime get internalDate;
  _i1.TonikFile get rawMessage;
}

class _ImportMessageBodyCopyWith<$Res>
    implements $$ImportMessageBodyCopyWith<$Res> {
  _ImportMessageBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ImportMessageBody _value;

  @_i3.override
  _i3.List<_i3.String>? get flags => _value.flags;

  @_i3.override
  _i3.String? get folder => _value.folder;

  @_i3.override
  _i3.DateTime get internalDate => _value.internalDate;

  @_i3.override
  _i1.TonikFile get rawMessage => _value.rawMessage;

  @_i3.override
  $Res call({
    _i3.Object? flags = _sentinel,
    _i3.Object? folder = _sentinel,
    _i3.Object? internalDate = _sentinel,
    _i3.Object? rawMessage = _sentinel,
  }) {
    return (ImportMessageBody(
      flags: _i3.identical(flags, _sentinel)
          ? this.flags
          : (flags as _i3.List<_i3.String>?),
      folder: _i3.identical(folder, _sentinel)
          ? this.folder
          : (folder as _i3.String?),
      internalDate: _i3.identical(internalDate, _sentinel)
          ? this.internalDate
          : (internalDate as _i3.DateTime),
      rawMessage: _i3.identical(rawMessage, _sentinel)
          ? this.rawMessage
          : (rawMessage as _i1.TonikFile),
    ) as $Res);
  }
}
