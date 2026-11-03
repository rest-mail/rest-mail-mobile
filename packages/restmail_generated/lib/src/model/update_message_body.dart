// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UpdateMessageBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UpdateMessageBody({
    this.folder,
    this.imapDeleted,
    this.isAnswered,
    this.isDraft,
    this.isFlagged,
    this.isRead,
    this.isStarred,
    this.keywords,
  });

  factory UpdateMessageBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'folder',
        r'imap_deleted',
        r'is_answered',
        r'is_draft',
        r'is_flagged',
        r'is_read',
        r'is_starred',
        r'keywords',
      },
      listKeys: {r'keywords'},
      context: r'UpdateMessageBody',
    );
    return UpdateMessageBody(
      folder: _$values[r'folder'].decodeSimpleNullableString(
        context: r'UpdateMessageBody.folder',
      ),
      imapDeleted: _$values[r'imap_deleted'].decodeSimpleNullableBool(
        context: r'UpdateMessageBody.imap_deleted',
      ),
      isAnswered: _$values[r'is_answered'].decodeSimpleNullableBool(
        context: r'UpdateMessageBody.is_answered',
      ),
      isDraft: _$values[r'is_draft'].decodeSimpleNullableBool(
        context: r'UpdateMessageBody.is_draft',
      ),
      isFlagged: _$values[r'is_flagged'].decodeSimpleNullableBool(
        context: r'UpdateMessageBody.is_flagged',
      ),
      isRead: _$values[r'is_read'].decodeSimpleNullableBool(
        context: r'UpdateMessageBody.is_read',
      ),
      isStarred: _$values[r'is_starred'].decodeSimpleNullableBool(
        context: r'UpdateMessageBody.is_starred',
      ),
      keywords: _$values[r'keywords'].decodeSimpleNullableStringList(
        context: r'UpdateMessageBody.keywords',
      ),
    );
  }

  factory UpdateMessageBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UpdateMessageBody');
    return UpdateMessageBody(
      folder: _$map[r'folder'].decodeJsonNullableString(
        context: r'UpdateMessageBody.folder',
      ),
      imapDeleted: _$map[r'imap_deleted'].decodeJsonNullableBool(
        context: r'UpdateMessageBody.imap_deleted',
      ),
      isAnswered: _$map[r'is_answered'].decodeJsonNullableBool(
        context: r'UpdateMessageBody.is_answered',
      ),
      isDraft: _$map[r'is_draft'].decodeJsonNullableBool(
        context: r'UpdateMessageBody.is_draft',
      ),
      isFlagged: _$map[r'is_flagged'].decodeJsonNullableBool(
        context: r'UpdateMessageBody.is_flagged',
      ),
      isRead: _$map[r'is_read'].decodeJsonNullableBool(
        context: r'UpdateMessageBody.is_read',
      ),
      isStarred: _$map[r'is_starred'].decodeJsonNullableBool(
        context: r'UpdateMessageBody.is_starred',
      ),
      keywords: _$map[r'keywords'].decodeJsonNullableList<_i3.String>(
        context: r'UpdateMessageBody.keywords',
      ),
    );
  }

  factory UpdateMessageBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'folder',
        r'imap_deleted',
        r'is_answered',
        r'is_draft',
        r'is_flagged',
        r'is_read',
        r'is_starred',
        r'keywords',
      },
      listKeys: {r'keywords'},
      context: r'UpdateMessageBody',
    );
    return UpdateMessageBody(
      folder: _$values[r'folder'].decodeFormNullableString(
        context: r'UpdateMessageBody.folder',
      ),
      imapDeleted: _$values[r'imap_deleted'].decodeFormNullableBool(
        context: r'UpdateMessageBody.imap_deleted',
      ),
      isAnswered: _$values[r'is_answered'].decodeFormNullableBool(
        context: r'UpdateMessageBody.is_answered',
      ),
      isDraft: _$values[r'is_draft'].decodeFormNullableBool(
        context: r'UpdateMessageBody.is_draft',
      ),
      isFlagged: _$values[r'is_flagged'].decodeFormNullableBool(
        context: r'UpdateMessageBody.is_flagged',
      ),
      isRead: _$values[r'is_read'].decodeFormNullableBool(
        context: r'UpdateMessageBody.is_read',
      ),
      isStarred: _$values[r'is_starred'].decodeFormNullableBool(
        context: r'UpdateMessageBody.is_starred',
      ),
      keywords: _$values[r'keywords'].decodeFormNullableStringList(
        context: r'UpdateMessageBody.keywords',
      ),
    );
  }

  final _i3.String? folder;

  final _i3.bool? imapDeleted;

  final _i3.bool? isAnswered;

  final _i3.bool? isDraft;

  final _i3.bool? isFlagged;

  final _i3.bool? isRead;

  final _i3.bool? isStarred;

  final _i3.List<_i3.String>? keywords;

  @_i3.override
  _i3.Object? toJson() => {
    r'folder': folder,
    r'imap_deleted': imapDeleted,
    r'is_answered': isAnswered,
    r'is_draft': isDraft,
    r'is_flagged': isFlagged,
    r'is_read': isRead,
    r'is_starred': isStarred,
    r'keywords': keywords,
  };

  $$UpdateMessageBodyCopyWith<UpdateMessageBody> get copyWith =>
      _UpdateMessageBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is UpdateMessageBody &&
        other.folder == this.folder &&
        other.imapDeleted == this.imapDeleted &&
        other.isAnswered == this.isAnswered &&
        other.isDraft == this.isDraft &&
        other.isFlagged == this.isFlagged &&
        other.isRead == this.isRead &&
        other.isStarred == this.isStarred &&
        _$deepEquals.equals(other.keywords, this.keywords);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      folder,
      imapDeleted,
      isAnswered,
      isDraft,
      isFlagged,
      isRead,
      isStarred,
      deepEquals.hash(keywords),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (folder != null) {
      _$result[r'folder'] = _i1.PropertyValue.scalar(folder!);
    }
    if (imapDeleted != null) {
      _$result[r'imap_deleted'] = _i1.PropertyValue.scalar(
        imapDeleted!.toString(),
      );
    }
    if (isAnswered != null) {
      _$result[r'is_answered'] = _i1.PropertyValue.scalar(
        isAnswered!.toString(),
      );
    }
    if (isDraft != null) {
      _$result[r'is_draft'] = _i1.PropertyValue.scalar(isDraft!.toString());
    }
    if (isFlagged != null) {
      _$result[r'is_flagged'] = _i1.PropertyValue.scalar(isFlagged!.toString());
    }
    if (isRead != null) {
      _$result[r'is_read'] = _i1.PropertyValue.scalar(isRead!.toString());
    }
    if (isStarred != null) {
      _$result[r'is_starred'] = _i1.PropertyValue.scalar(isStarred!.toString());
    }
    if (keywords != null) {
      _$result[r'keywords'] = _i1.PropertyValue.array(keywords!);
    }
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
      r'Cannot uriEncode UpdateMessageBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UpdateMessageBodyCopyWith<$Res> {
  factory $$UpdateMessageBodyCopyWith(UpdateMessageBody value) =
      _UpdateMessageBodyCopyWith<$Res>;

  $Res call({
    _i3.String? folder,
    _i3.bool? imapDeleted,
    _i3.bool? isAnswered,
    _i3.bool? isDraft,
    _i3.bool? isFlagged,
    _i3.bool? isRead,
    _i3.bool? isStarred,
    _i3.List<_i3.String>? keywords,
  });
  _i3.String? get folder;
  _i3.bool? get imapDeleted;
  _i3.bool? get isAnswered;
  _i3.bool? get isDraft;
  _i3.bool? get isFlagged;
  _i3.bool? get isRead;
  _i3.bool? get isStarred;
  _i3.List<_i3.String>? get keywords;
}

class _UpdateMessageBodyCopyWith<$Res>
    implements $$UpdateMessageBodyCopyWith<$Res> {
  _UpdateMessageBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UpdateMessageBody _value;

  @_i3.override
  _i3.String? get folder => _value.folder;

  @_i3.override
  _i3.bool? get imapDeleted => _value.imapDeleted;

  @_i3.override
  _i3.bool? get isAnswered => _value.isAnswered;

  @_i3.override
  _i3.bool? get isDraft => _value.isDraft;

  @_i3.override
  _i3.bool? get isFlagged => _value.isFlagged;

  @_i3.override
  _i3.bool? get isRead => _value.isRead;

  @_i3.override
  _i3.bool? get isStarred => _value.isStarred;

  @_i3.override
  _i3.List<_i3.String>? get keywords => _value.keywords;

  @_i3.override
  $Res call({
    _i3.Object? folder = _sentinel,
    _i3.Object? imapDeleted = _sentinel,
    _i3.Object? isAnswered = _sentinel,
    _i3.Object? isDraft = _sentinel,
    _i3.Object? isFlagged = _sentinel,
    _i3.Object? isRead = _sentinel,
    _i3.Object? isStarred = _sentinel,
    _i3.Object? keywords = _sentinel,
  }) {
    return (UpdateMessageBody(
      folder: _i3.identical(folder, _sentinel)
          ? this.folder
          : (folder as _i3.String?),
      imapDeleted: _i3.identical(imapDeleted, _sentinel)
          ? this.imapDeleted
          : (imapDeleted as _i3.bool?),
      isAnswered: _i3.identical(isAnswered, _sentinel)
          ? this.isAnswered
          : (isAnswered as _i3.bool?),
      isDraft: _i3.identical(isDraft, _sentinel)
          ? this.isDraft
          : (isDraft as _i3.bool?),
      isFlagged: _i3.identical(isFlagged, _sentinel)
          ? this.isFlagged
          : (isFlagged as _i3.bool?),
      isRead: _i3.identical(isRead, _sentinel)
          ? this.isRead
          : (isRead as _i3.bool?),
      isStarred: _i3.identical(isStarred, _sentinel)
          ? this.isStarred
          : (isStarred as _i3.bool?),
      keywords: _i3.identical(keywords, _sentinel)
          ? this.keywords
          : (keywords as _i3.List<_i3.String>?),
    ) as $Res);
  }
}
