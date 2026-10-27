// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SampleAttachment extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SampleAttachment({
    this.checksum,
    this.content,
    this.contentId,
    this.contentType,
    this.disposition,
    this.filename,
    this.ref,
    this.size,
    this.storage,
  });

  factory SampleAttachment.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'checksum',
        r'content',
        r'content_id',
        r'content_type',
        r'disposition',
        r'filename',
        r'ref',
        r'size',
        r'storage',
      },
      listKeys: {},
      context: r'SampleAttachment',
    );
    return SampleAttachment(
      checksum: _$values[r'checksum'].decodeSimpleNullableString(
        context: r'SampleAttachment.checksum',
      ),
      content: _$values[r'content'].decodeSimpleNullableString(
        context: r'SampleAttachment.content',
      ),
      contentId: _$values[r'content_id'].decodeSimpleNullableString(
        context: r'SampleAttachment.content_id',
      ),
      contentType: _$values[r'content_type'].decodeSimpleNullableString(
        context: r'SampleAttachment.content_type',
      ),
      disposition: _$values[r'disposition'].decodeSimpleNullableString(
        context: r'SampleAttachment.disposition',
      ),
      filename: _$values[r'filename'].decodeSimpleNullableString(
        context: r'SampleAttachment.filename',
      ),
      ref: _$values[r'ref'].decodeSimpleNullableString(
        context: r'SampleAttachment.ref',
      ),
      size: _$values[r'size'].decodeSimpleNullableInt(
        context: r'SampleAttachment.size',
      ),
      storage: _$values[r'storage'].decodeSimpleNullableString(
        context: r'SampleAttachment.storage',
      ),
    );
  }

  factory SampleAttachment.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SampleAttachment');
    return SampleAttachment(
      checksum: _$map[r'checksum'].decodeJsonNullableString(
        context: r'SampleAttachment.checksum',
      ),
      content: _$map[r'content'].decodeJsonNullableString(
        context: r'SampleAttachment.content',
      ),
      contentId: _$map[r'content_id'].decodeJsonNullableString(
        context: r'SampleAttachment.content_id',
      ),
      contentType: _$map[r'content_type'].decodeJsonNullableString(
        context: r'SampleAttachment.content_type',
      ),
      disposition: _$map[r'disposition'].decodeJsonNullableString(
        context: r'SampleAttachment.disposition',
      ),
      filename: _$map[r'filename'].decodeJsonNullableString(
        context: r'SampleAttachment.filename',
      ),
      ref: _$map[r'ref'].decodeJsonNullableString(
        context: r'SampleAttachment.ref',
      ),
      size: _$map[r'size'].decodeJsonNullableInt(
        context: r'SampleAttachment.size',
      ),
      storage: _$map[r'storage'].decodeJsonNullableString(
        context: r'SampleAttachment.storage',
      ),
    );
  }

  factory SampleAttachment.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'checksum',
        r'content',
        r'content_id',
        r'content_type',
        r'disposition',
        r'filename',
        r'ref',
        r'size',
        r'storage',
      },
      listKeys: {},
      context: r'SampleAttachment',
    );
    return SampleAttachment(
      checksum: _$values[r'checksum'].decodeFormNullableString(
        context: r'SampleAttachment.checksum',
      ),
      content: _$values[r'content'].decodeFormNullableString(
        context: r'SampleAttachment.content',
      ),
      contentId: _$values[r'content_id'].decodeFormNullableString(
        context: r'SampleAttachment.content_id',
      ),
      contentType: _$values[r'content_type'].decodeFormNullableString(
        context: r'SampleAttachment.content_type',
      ),
      disposition: _$values[r'disposition'].decodeFormNullableString(
        context: r'SampleAttachment.disposition',
      ),
      filename: _$values[r'filename'].decodeFormNullableString(
        context: r'SampleAttachment.filename',
      ),
      ref: _$values[r'ref'].decodeFormNullableString(
        context: r'SampleAttachment.ref',
      ),
      size: _$values[r'size'].decodeFormNullableInt(
        context: r'SampleAttachment.size',
      ),
      storage: _$values[r'storage'].decodeFormNullableString(
        context: r'SampleAttachment.storage',
      ),
    );
  }

  final _i3.String? checksum;

  final _i3.String? content;

  final _i3.String? contentId;

  final _i3.String? contentType;

  final _i3.String? disposition;

  final _i3.String? filename;

  final _i3.String? ref;

  final _i3.int? size;

  final _i3.String? storage;

  @_i3.override
  _i3.Object? toJson() => {
    r'checksum': checksum,
    r'content': content,
    r'content_id': contentId,
    r'content_type': contentType,
    r'disposition': disposition,
    r'filename': filename,
    r'ref': ref,
    r'size': size,
    r'storage': storage,
  };

  $$SampleAttachmentCopyWith<SampleAttachment> get copyWith =>
      _SampleAttachmentCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SampleAttachment &&
        other.checksum == this.checksum &&
        other.content == this.content &&
        other.contentId == this.contentId &&
        other.contentType == this.contentType &&
        other.disposition == this.disposition &&
        other.filename == this.filename &&
        other.ref == this.ref &&
        other.size == this.size &&
        other.storage == this.storage;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      checksum,
      content,
      contentId,
      contentType,
      disposition,
      filename,
      ref,
      size,
      storage,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (checksum != null) {
      _$result[r'checksum'] = _i1.PropertyValue.scalar(checksum!);
    }
    if (content != null) {
      _$result[r'content'] = _i1.PropertyValue.scalar(content!);
    }
    if (contentId != null) {
      _$result[r'content_id'] = _i1.PropertyValue.scalar(contentId!);
    }
    if (contentType != null) {
      _$result[r'content_type'] = _i1.PropertyValue.scalar(contentType!);
    }
    if (disposition != null) {
      _$result[r'disposition'] = _i1.PropertyValue.scalar(disposition!);
    }
    if (filename != null) {
      _$result[r'filename'] = _i1.PropertyValue.scalar(filename!);
    }
    if (ref != null) {
      _$result[r'ref'] = _i1.PropertyValue.scalar(ref!);
    }
    if (size != null) {
      _$result[r'size'] = _i1.PropertyValue.scalar(size!.toString());
    }
    if (storage != null) {
      _$result[r'storage'] = _i1.PropertyValue.scalar(storage!);
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
      r'Cannot uriEncode SampleAttachment: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SampleAttachmentCopyWith<$Res> {
  factory $$SampleAttachmentCopyWith(SampleAttachment value) =
      _SampleAttachmentCopyWith<$Res>;

  $Res call({
    _i3.String? checksum,
    _i3.String? content,
    _i3.String? contentId,
    _i3.String? contentType,
    _i3.String? disposition,
    _i3.String? filename,
    _i3.String? ref,
    _i3.int? size,
    _i3.String? storage,
  });
  _i3.String? get checksum;
  _i3.String? get content;
  _i3.String? get contentId;
  _i3.String? get contentType;
  _i3.String? get disposition;
  _i3.String? get filename;
  _i3.String? get ref;
  _i3.int? get size;
  _i3.String? get storage;
}

class _SampleAttachmentCopyWith<$Res>
    implements $$SampleAttachmentCopyWith<$Res> {
  _SampleAttachmentCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SampleAttachment _value;

  @_i3.override
  _i3.String? get checksum => _value.checksum;

  @_i3.override
  _i3.String? get content => _value.content;

  @_i3.override
  _i3.String? get contentId => _value.contentId;

  @_i3.override
  _i3.String? get contentType => _value.contentType;

  @_i3.override
  _i3.String? get disposition => _value.disposition;

  @_i3.override
  _i3.String? get filename => _value.filename;

  @_i3.override
  _i3.String? get ref => _value.ref;

  @_i3.override
  _i3.int? get size => _value.size;

  @_i3.override
  _i3.String? get storage => _value.storage;

  @_i3.override
  $Res call({
    _i3.Object? checksum = _sentinel,
    _i3.Object? content = _sentinel,
    _i3.Object? contentId = _sentinel,
    _i3.Object? contentType = _sentinel,
    _i3.Object? disposition = _sentinel,
    _i3.Object? filename = _sentinel,
    _i3.Object? ref = _sentinel,
    _i3.Object? size = _sentinel,
    _i3.Object? storage = _sentinel,
  }) {
    return (SampleAttachment(
      checksum: _i3.identical(checksum, _sentinel)
          ? this.checksum
          : (checksum as _i3.String?),
      content: _i3.identical(content, _sentinel)
          ? this.content
          : (content as _i3.String?),
      contentId: _i3.identical(contentId, _sentinel)
          ? this.contentId
          : (contentId as _i3.String?),
      contentType: _i3.identical(contentType, _sentinel)
          ? this.contentType
          : (contentType as _i3.String?),
      disposition: _i3.identical(disposition, _sentinel)
          ? this.disposition
          : (disposition as _i3.String?),
      filename: _i3.identical(filename, _sentinel)
          ? this.filename
          : (filename as _i3.String?),
      ref: _i3.identical(ref, _sentinel) ? this.ref : (ref as _i3.String?),
      size: _i3.identical(size, _sentinel) ? this.size : (size as _i3.int?),
      storage: _i3.identical(storage, _sentinel)
          ? this.storage
          : (storage as _i3.String?),
    ) as $Res);
  }
}
