// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/quota_usage_mailbox_one_of_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class QuotaUsage extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const QuotaUsage({
    required this.attachmentBytes,
    required this.bodyBytes,
    required this.mailboxId,
    required this.messageCount,
    required this.subjectBytes,
    required this.updatedAt,
    this.mailbox,
  });

  factory QuotaUsage.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for QuotaUsage: contains complex types',
    );
  }

  factory QuotaUsage.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'QuotaUsage');
    return QuotaUsage(
      attachmentBytes: _$map[r'attachment_bytes'].decodeJsonInt(
        context: r'QuotaUsage.attachment_bytes',
      ),
      bodyBytes: _$map[r'body_bytes'].decodeJsonInt(
        context: r'QuotaUsage.body_bytes',
      ),
      mailbox: _$map[r'mailbox'] == null
          ? null
          : _i4.QuotaUsageMailboxOneOfModel.fromJson(_$map[r'mailbox']),
      mailboxId: _$map[r'mailbox_id'].decodeJsonInt(
        context: r'QuotaUsage.mailbox_id',
      ),
      messageCount: _$map[r'message_count'].decodeJsonInt(
        context: r'QuotaUsage.message_count',
      ),
      subjectBytes: _$map[r'subject_bytes'].decodeJsonInt(
        context: r'QuotaUsage.subject_bytes',
      ),
      updatedAt: _$map[r'updated_at'].decodeJsonDateTime(
        context: r'QuotaUsage.updated_at',
      ),
    );
  }

  factory QuotaUsage.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for QuotaUsage: contains complex types',
    );
  }

  final _i3.int attachmentBytes;

  final _i3.int bodyBytes;

  final _i4.QuotaUsageMailboxOneOfModel? mailbox;

  final _i3.int mailboxId;

  final _i3.int messageCount;

  final _i3.int subjectBytes;

  final _i3.DateTime updatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'attachment_bytes': attachmentBytes,
    r'body_bytes': bodyBytes,
    if (mailbox != null) r'mailbox': mailbox?.toJson(),
    r'mailbox_id': mailboxId,
    r'message_count': messageCount,
    r'subject_bytes': subjectBytes,
    r'updated_at': updatedAt.toTimeZonedIso8601String(),
  };

  $$QuotaUsageCopyWith<QuotaUsage> get copyWith => _QuotaUsageCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is QuotaUsage &&
        other.attachmentBytes == this.attachmentBytes &&
        other.bodyBytes == this.bodyBytes &&
        other.mailbox == this.mailbox &&
        other.mailboxId == this.mailboxId &&
        other.messageCount == this.messageCount &&
        other.subjectBytes == this.subjectBytes &&
        other.updatedAt == this.updatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      attachmentBytes,
      bodyBytes,
      mailbox,
      mailboxId,
      messageCount,
      subjectBytes,
      updatedAt,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for QuotaUsage: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode QuotaUsage: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$QuotaUsageCopyWith<$Res> {
  factory $$QuotaUsageCopyWith(QuotaUsage value) = _QuotaUsageCopyWith<$Res>;

  $Res call({
    _i3.int? attachmentBytes,
    _i3.int? bodyBytes,
    _i4.QuotaUsageMailboxOneOfModel? mailbox,
    _i3.int? mailboxId,
    _i3.int? messageCount,
    _i3.int? subjectBytes,
    _i3.DateTime? updatedAt,
  });
  _i3.int get attachmentBytes;
  _i3.int get bodyBytes;
  _i4.QuotaUsageMailboxOneOfModel? get mailbox;
  _i3.int get mailboxId;
  _i3.int get messageCount;
  _i3.int get subjectBytes;
  _i3.DateTime get updatedAt;
}

class _QuotaUsageCopyWith<$Res> implements $$QuotaUsageCopyWith<$Res> {
  _QuotaUsageCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final QuotaUsage _value;

  @_i3.override
  _i3.int get attachmentBytes => _value.attachmentBytes;

  @_i3.override
  _i3.int get bodyBytes => _value.bodyBytes;

  @_i3.override
  _i4.QuotaUsageMailboxOneOfModel? get mailbox => _value.mailbox;

  @_i3.override
  _i3.int get mailboxId => _value.mailboxId;

  @_i3.override
  _i3.int get messageCount => _value.messageCount;

  @_i3.override
  _i3.int get subjectBytes => _value.subjectBytes;

  @_i3.override
  _i3.DateTime get updatedAt => _value.updatedAt;

  @_i3.override
  $Res call({
    _i3.Object? attachmentBytes = _sentinel,
    _i3.Object? bodyBytes = _sentinel,
    _i3.Object? mailbox = _sentinel,
    _i3.Object? mailboxId = _sentinel,
    _i3.Object? messageCount = _sentinel,
    _i3.Object? subjectBytes = _sentinel,
    _i3.Object? updatedAt = _sentinel,
  }) {
    return (QuotaUsage(
      attachmentBytes: _i3.identical(attachmentBytes, _sentinel)
          ? this.attachmentBytes
          : (attachmentBytes as _i3.int),
      bodyBytes: _i3.identical(bodyBytes, _sentinel)
          ? this.bodyBytes
          : (bodyBytes as _i3.int),
      mailbox: _i3.identical(mailbox, _sentinel)
          ? this.mailbox
          : (mailbox as _i4.QuotaUsageMailboxOneOfModel?),
      mailboxId: _i3.identical(mailboxId, _sentinel)
          ? this.mailboxId
          : (mailboxId as _i3.int),
      messageCount: _i3.identical(messageCount, _sentinel)
          ? this.messageCount
          : (messageCount as _i3.int),
      subjectBytes: _i3.identical(subjectBytes, _sentinel)
          ? this.subjectBytes
          : (subjectBytes as _i3.int),
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime),
    ) as $Res);
  }
}
