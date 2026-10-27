// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ImportMessageResult extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ImportMessageResult({
    required this.folder,
    required this.id,
    required this.imported,
    required this.messageId,
  });

  factory ImportMessageResult.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'folder', r'id', r'imported', r'message_id'},
      listKeys: {},
      context: r'ImportMessageResult',
    );
    return ImportMessageResult(
      folder: _$values[r'folder'].decodeSimpleString(
        context: r'ImportMessageResult.folder',
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'ImportMessageResult.id'),
      imported: _$values[r'imported'].decodeSimpleBool(
        context: r'ImportMessageResult.imported',
      ),
      messageId: _$values[r'message_id'].decodeSimpleString(
        context: r'ImportMessageResult.message_id',
      ),
    );
  }

  factory ImportMessageResult.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ImportMessageResult');
    return ImportMessageResult(
      folder: _$map[r'folder'].decodeJsonString(
        context: r'ImportMessageResult.folder',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'ImportMessageResult.id'),
      imported: _$map[r'imported'].decodeJsonBool(
        context: r'ImportMessageResult.imported',
      ),
      messageId: _$map[r'message_id'].decodeJsonString(
        context: r'ImportMessageResult.message_id',
      ),
    );
  }

  factory ImportMessageResult.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'folder', r'id', r'imported', r'message_id'},
      listKeys: {},
      context: r'ImportMessageResult',
    );
    return ImportMessageResult(
      folder: _$values[r'folder'].decodeFormString(
        context: r'ImportMessageResult.folder',
      ),
      id: _$values[r'id'].decodeFormInt(context: r'ImportMessageResult.id'),
      imported: _$values[r'imported'].decodeFormBool(
        context: r'ImportMessageResult.imported',
      ),
      messageId: _$values[r'message_id'].decodeFormString(
        context: r'ImportMessageResult.message_id',
      ),
    );
  }

  final _i3.String folder;

  final _i3.int id;

  final _i3.bool imported;

  final _i3.String messageId;

  @_i3.override
  _i3.Object? toJson() => {
    r'folder': folder,
    r'id': id,
    r'imported': imported,
    r'message_id': messageId,
  };

  $$ImportMessageResultCopyWith<ImportMessageResult> get copyWith =>
      _ImportMessageResultCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportMessageResult &&
        other.folder == this.folder &&
        other.id == this.id &&
        other.imported == this.imported &&
        other.messageId == this.messageId;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([folder, id, imported, messageId]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'folder'] = _i1.PropertyValue.scalar(folder);
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'imported'] = _i1.PropertyValue.scalar(imported.toString());
    _$result[r'message_id'] = _i1.PropertyValue.scalar(messageId);
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
      r'Cannot uriEncode ImportMessageResult: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ImportMessageResultCopyWith<$Res> {
  factory $$ImportMessageResultCopyWith(ImportMessageResult value) =
      _ImportMessageResultCopyWith<$Res>;

  $Res call({
    _i3.String? folder,
    _i3.int? id,
    _i3.bool? imported,
    _i3.String? messageId,
  });
  _i3.String get folder;
  _i3.int get id;
  _i3.bool get imported;
  _i3.String get messageId;
}

class _ImportMessageResultCopyWith<$Res>
    implements $$ImportMessageResultCopyWith<$Res> {
  _ImportMessageResultCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ImportMessageResult _value;

  @_i3.override
  _i3.String get folder => _value.folder;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.bool get imported => _value.imported;

  @_i3.override
  _i3.String get messageId => _value.messageId;

  @_i3.override
  $Res call({
    _i3.Object? folder = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? imported = _sentinel,
    _i3.Object? messageId = _sentinel,
  }) {
    return (ImportMessageResult(
      folder: _i3.identical(folder, _sentinel)
          ? this.folder
          : (folder as _i3.String),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      imported: _i3.identical(imported, _sentinel)
          ? this.imported
          : (imported as _i3.bool),
      messageId: _i3.identical(messageId, _sentinel)
          ? this.messageId
          : (messageId as _i3.String),
    ) as $Res);
  }
}
