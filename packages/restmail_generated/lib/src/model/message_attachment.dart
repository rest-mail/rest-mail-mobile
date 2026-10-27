// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class MessageAttachment extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const MessageAttachment({
    required this.checksum,
    required this.contentType,
    required this.createdAt,
    required this.filename,
    required this.id,
    required this.messageId,
    required this.sizeBytes,
  });

  factory MessageAttachment.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'checksum',
        r'content_type',
        r'created_at',
        r'filename',
        r'id',
        r'message_id',
        r'size_bytes',
      },
      listKeys: {},
      context: r'MessageAttachment',
    );
    return MessageAttachment(
      checksum: _$values[r'checksum'].decodeSimpleString(
        context: r'MessageAttachment.checksum',
      ),
      contentType: _$values[r'content_type'].decodeSimpleString(
        context: r'MessageAttachment.content_type',
      ),
      createdAt: _$values[r'created_at'].decodeSimpleDateTime(
        context: r'MessageAttachment.created_at',
      ),
      filename: _$values[r'filename'].decodeSimpleString(
        context: r'MessageAttachment.filename',
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'MessageAttachment.id'),
      messageId: _$values[r'message_id'].decodeSimpleInt(
        context: r'MessageAttachment.message_id',
      ),
      sizeBytes: _$values[r'size_bytes'].decodeSimpleInt(
        context: r'MessageAttachment.size_bytes',
      ),
    );
  }

  factory MessageAttachment.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'MessageAttachment');
    return MessageAttachment(
      checksum: _$map[r'checksum'].decodeJsonString(
        context: r'MessageAttachment.checksum',
      ),
      contentType: _$map[r'content_type'].decodeJsonString(
        context: r'MessageAttachment.content_type',
      ),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'MessageAttachment.created_at',
      ),
      filename: _$map[r'filename'].decodeJsonString(
        context: r'MessageAttachment.filename',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'MessageAttachment.id'),
      messageId: _$map[r'message_id'].decodeJsonInt(
        context: r'MessageAttachment.message_id',
      ),
      sizeBytes: _$map[r'size_bytes'].decodeJsonInt(
        context: r'MessageAttachment.size_bytes',
      ),
    );
  }

  factory MessageAttachment.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'checksum',
        r'content_type',
        r'created_at',
        r'filename',
        r'id',
        r'message_id',
        r'size_bytes',
      },
      listKeys: {},
      context: r'MessageAttachment',
    );
    return MessageAttachment(
      checksum: _$values[r'checksum'].decodeFormString(
        context: r'MessageAttachment.checksum',
      ),
      contentType: _$values[r'content_type'].decodeFormString(
        context: r'MessageAttachment.content_type',
      ),
      createdAt: _$values[r'created_at'].decodeFormDateTime(
        context: r'MessageAttachment.created_at',
      ),
      filename: _$values[r'filename'].decodeFormString(
        context: r'MessageAttachment.filename',
      ),
      id: _$values[r'id'].decodeFormInt(context: r'MessageAttachment.id'),
      messageId: _$values[r'message_id'].decodeFormInt(
        context: r'MessageAttachment.message_id',
      ),
      sizeBytes: _$values[r'size_bytes'].decodeFormInt(
        context: r'MessageAttachment.size_bytes',
      ),
    );
  }

  final _i3.String checksum;

  final _i3.String contentType;

  final _i3.DateTime createdAt;

  final _i3.String filename;

  final _i3.int id;

  final _i3.int messageId;

  final _i3.int sizeBytes;

  @_i3.override
  _i3.Object? toJson() => {
    r'checksum': checksum,
    r'content_type': contentType,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'filename': filename,
    r'id': id,
    r'message_id': messageId,
    r'size_bytes': sizeBytes,
  };

  $$MessageAttachmentCopyWith<MessageAttachment> get copyWith =>
      _MessageAttachmentCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MessageAttachment &&
        other.checksum == this.checksum &&
        other.contentType == this.contentType &&
        other.createdAt == this.createdAt &&
        other.filename == this.filename &&
        other.id == this.id &&
        other.messageId == this.messageId &&
        other.sizeBytes == this.sizeBytes;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      checksum,
      contentType,
      createdAt,
      filename,
      id,
      messageId,
      sizeBytes,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'checksum'] = _i1.PropertyValue.scalar(checksum);
    _$result[r'content_type'] = _i1.PropertyValue.scalar(contentType);
    _$result[r'created_at'] = _i1.PropertyValue.scalar(
      createdAt.toTimeZonedIso8601String(),
    );
    _$result[r'filename'] = _i1.PropertyValue.scalar(filename);
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'message_id'] = _i1.PropertyValue.scalar(messageId.toString());
    _$result[r'size_bytes'] = _i1.PropertyValue.scalar(sizeBytes.toString());
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
      r'Cannot uriEncode MessageAttachment: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$MessageAttachmentCopyWith<$Res> {
  factory $$MessageAttachmentCopyWith(MessageAttachment value) =
      _MessageAttachmentCopyWith<$Res>;

  $Res call({
    _i3.String? checksum,
    _i3.String? contentType,
    _i3.DateTime? createdAt,
    _i3.String? filename,
    _i3.int? id,
    _i3.int? messageId,
    _i3.int? sizeBytes,
  });
  _i3.String get checksum;
  _i3.String get contentType;
  _i3.DateTime get createdAt;
  _i3.String get filename;
  _i3.int get id;
  _i3.int get messageId;
  _i3.int get sizeBytes;
}

class _MessageAttachmentCopyWith<$Res>
    implements $$MessageAttachmentCopyWith<$Res> {
  _MessageAttachmentCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final MessageAttachment _value;

  @_i3.override
  _i3.String get checksum => _value.checksum;

  @_i3.override
  _i3.String get contentType => _value.contentType;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.String get filename => _value.filename;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.int get messageId => _value.messageId;

  @_i3.override
  _i3.int get sizeBytes => _value.sizeBytes;

  @_i3.override
  $Res call({
    _i3.Object? checksum = _sentinel,
    _i3.Object? contentType = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? filename = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? messageId = _sentinel,
    _i3.Object? sizeBytes = _sentinel,
  }) {
    return (MessageAttachment(
      checksum: _i3.identical(checksum, _sentinel)
          ? this.checksum
          : (checksum as _i3.String),
      contentType: _i3.identical(contentType, _sentinel)
          ? this.contentType
          : (contentType as _i3.String),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      filename: _i3.identical(filename, _sentinel)
          ? this.filename
          : (filename as _i3.String),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      messageId: _i3.identical(messageId, _sentinel)
          ? this.messageId
          : (messageId as _i3.int),
      sizeBytes: _i3.identical(sizeBytes, _sentinel)
          ? this.sizeBytes
          : (sizeBytes as _i3.int),
    ) as $Res);
  }
}
