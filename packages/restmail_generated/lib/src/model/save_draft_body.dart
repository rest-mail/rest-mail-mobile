// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SaveDraftBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SaveDraftBody({
    this.bodyHtml,
    this.bodyText,
    this.cc,
    this.from,
    this.inReplyTo,
    this.references,
    this.subject,
    this.to,
  });

  factory SaveDraftBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'body_html',
        r'body_text',
        r'cc',
        r'from',
        r'in_reply_to',
        r'references',
        r'subject',
        r'to',
      },
      listKeys: {r'cc', r'to'},
      context: r'SaveDraftBody',
    );
    return SaveDraftBody(
      bodyHtml: _$values[r'body_html'].decodeSimpleNullableString(
        context: r'SaveDraftBody.body_html',
      ),
      bodyText: _$values[r'body_text'].decodeSimpleNullableString(
        context: r'SaveDraftBody.body_text',
      ),
      cc: _$values[r'cc'].decodeSimpleNullableStringList(
        context: r'SaveDraftBody.cc',
      ),
      from: _$values[r'from'].decodeSimpleNullableString(
        context: r'SaveDraftBody.from',
      ),
      inReplyTo: _$values[r'in_reply_to'].decodeSimpleNullableString(
        context: r'SaveDraftBody.in_reply_to',
      ),
      references: _$values[r'references'].decodeSimpleNullableString(
        context: r'SaveDraftBody.references',
      ),
      subject: _$values[r'subject'].decodeSimpleNullableString(
        context: r'SaveDraftBody.subject',
      ),
      to: _$values[r'to'].decodeSimpleNullableStringList(
        context: r'SaveDraftBody.to',
      ),
    );
  }

  factory SaveDraftBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SaveDraftBody');
    return SaveDraftBody(
      bodyHtml: _$map[r'body_html'].decodeJsonNullableString(
        context: r'SaveDraftBody.body_html',
      ),
      bodyText: _$map[r'body_text'].decodeJsonNullableString(
        context: r'SaveDraftBody.body_text',
      ),
      cc: _$map[r'cc'].decodeJsonNullableList<_i3.String>(
        context: r'SaveDraftBody.cc',
      ),
      from: _$map[r'from'].decodeJsonNullableString(
        context: r'SaveDraftBody.from',
      ),
      inReplyTo: _$map[r'in_reply_to'].decodeJsonNullableString(
        context: r'SaveDraftBody.in_reply_to',
      ),
      references: _$map[r'references'].decodeJsonNullableString(
        context: r'SaveDraftBody.references',
      ),
      subject: _$map[r'subject'].decodeJsonNullableString(
        context: r'SaveDraftBody.subject',
      ),
      to: _$map[r'to'].decodeJsonNullableList<_i3.String>(
        context: r'SaveDraftBody.to',
      ),
    );
  }

  factory SaveDraftBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'body_html',
        r'body_text',
        r'cc',
        r'from',
        r'in_reply_to',
        r'references',
        r'subject',
        r'to',
      },
      listKeys: {r'cc', r'to'},
      context: r'SaveDraftBody',
    );
    return SaveDraftBody(
      bodyHtml: _$values[r'body_html'].decodeFormNullableString(
        context: r'SaveDraftBody.body_html',
      ),
      bodyText: _$values[r'body_text'].decodeFormNullableString(
        context: r'SaveDraftBody.body_text',
      ),
      cc: _$values[r'cc'].decodeFormNullableStringList(
        context: r'SaveDraftBody.cc',
      ),
      from: _$values[r'from'].decodeFormNullableString(
        context: r'SaveDraftBody.from',
      ),
      inReplyTo: _$values[r'in_reply_to'].decodeFormNullableString(
        context: r'SaveDraftBody.in_reply_to',
      ),
      references: _$values[r'references'].decodeFormNullableString(
        context: r'SaveDraftBody.references',
      ),
      subject: _$values[r'subject'].decodeFormNullableString(
        context: r'SaveDraftBody.subject',
      ),
      to: _$values[r'to'].decodeFormNullableStringList(
        context: r'SaveDraftBody.to',
      ),
    );
  }

  final _i3.String? bodyHtml;

  final _i3.String? bodyText;

  final _i3.List<_i3.String>? cc;

  final _i3.String? from;

  final _i3.String? inReplyTo;

  final _i3.String? references;

  final _i3.String? subject;

  final _i3.List<_i3.String>? to;

  @_i3.override
  _i3.Object? toJson() => {
    if (bodyHtml != null) r'body_html': bodyHtml,
    if (bodyText != null) r'body_text': bodyText,
    if (cc != null) r'cc': cc,
    if (from != null) r'from': from,
    if (inReplyTo != null) r'in_reply_to': inReplyTo,
    if (references != null) r'references': references,
    if (subject != null) r'subject': subject,
    if (to != null) r'to': to,
  };

  $$SaveDraftBodyCopyWith<SaveDraftBody> get copyWith =>
      _SaveDraftBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is SaveDraftBody &&
        other.bodyHtml == this.bodyHtml &&
        other.bodyText == this.bodyText &&
        _$deepEquals.equals(other.cc, this.cc) &&
        other.from == this.from &&
        other.inReplyTo == this.inReplyTo &&
        other.references == this.references &&
        other.subject == this.subject &&
        _$deepEquals.equals(other.to, this.to);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      bodyHtml,
      bodyText,
      deepEquals.hash(cc),
      from,
      inReplyTo,
      references,
      subject,
      deepEquals.hash(to),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (bodyHtml != null) {
      _$result[r'body_html'] = _i1.PropertyValue.scalar(bodyHtml!);
    }
    if (bodyText != null) {
      _$result[r'body_text'] = _i1.PropertyValue.scalar(bodyText!);
    }
    if (cc != null) {
      _$result[r'cc'] = _i1.PropertyValue.array(cc!);
    }
    if (from != null) {
      _$result[r'from'] = _i1.PropertyValue.scalar(from!);
    }
    if (inReplyTo != null) {
      _$result[r'in_reply_to'] = _i1.PropertyValue.scalar(inReplyTo!);
    }
    if (references != null) {
      _$result[r'references'] = _i1.PropertyValue.scalar(references!);
    }
    if (subject != null) {
      _$result[r'subject'] = _i1.PropertyValue.scalar(subject!);
    }
    if (to != null) {
      _$result[r'to'] = _i1.PropertyValue.array(to!);
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
      r'Cannot uriEncode SaveDraftBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SaveDraftBodyCopyWith<$Res> {
  factory $$SaveDraftBodyCopyWith(SaveDraftBody value) =
      _SaveDraftBodyCopyWith<$Res>;

  $Res call({
    _i3.String? bodyHtml,
    _i3.String? bodyText,
    _i3.List<_i3.String>? cc,
    _i3.String? from,
    _i3.String? inReplyTo,
    _i3.String? references,
    _i3.String? subject,
    _i3.List<_i3.String>? to,
  });
  _i3.String? get bodyHtml;
  _i3.String? get bodyText;
  _i3.List<_i3.String>? get cc;
  _i3.String? get from;
  _i3.String? get inReplyTo;
  _i3.String? get references;
  _i3.String? get subject;
  _i3.List<_i3.String>? get to;
}

class _SaveDraftBodyCopyWith<$Res> implements $$SaveDraftBodyCopyWith<$Res> {
  _SaveDraftBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SaveDraftBody _value;

  @_i3.override
  _i3.String? get bodyHtml => _value.bodyHtml;

  @_i3.override
  _i3.String? get bodyText => _value.bodyText;

  @_i3.override
  _i3.List<_i3.String>? get cc => _value.cc;

  @_i3.override
  _i3.String? get from => _value.from;

  @_i3.override
  _i3.String? get inReplyTo => _value.inReplyTo;

  @_i3.override
  _i3.String? get references => _value.references;

  @_i3.override
  _i3.String? get subject => _value.subject;

  @_i3.override
  _i3.List<_i3.String>? get to => _value.to;

  @_i3.override
  $Res call({
    _i3.Object? bodyHtml = _sentinel,
    _i3.Object? bodyText = _sentinel,
    _i3.Object? cc = _sentinel,
    _i3.Object? from = _sentinel,
    _i3.Object? inReplyTo = _sentinel,
    _i3.Object? references = _sentinel,
    _i3.Object? subject = _sentinel,
    _i3.Object? to = _sentinel,
  }) {
    return (SaveDraftBody(
      bodyHtml: _i3.identical(bodyHtml, _sentinel)
          ? this.bodyHtml
          : (bodyHtml as _i3.String?),
      bodyText: _i3.identical(bodyText, _sentinel)
          ? this.bodyText
          : (bodyText as _i3.String?),
      cc: _i3.identical(cc, _sentinel)
          ? this.cc
          : (cc as _i3.List<_i3.String>?),
      from: _i3.identical(from, _sentinel) ? this.from : (from as _i3.String?),
      inReplyTo: _i3.identical(inReplyTo, _sentinel)
          ? this.inReplyTo
          : (inReplyTo as _i3.String?),
      references: _i3.identical(references, _sentinel)
          ? this.references
          : (references as _i3.String?),
      subject: _i3.identical(subject, _sentinel)
          ? this.subject
          : (subject as _i3.String?),
      to: _i3.identical(to, _sentinel)
          ? this.to
          : (to as _i3.List<_i3.String>?),
    ) as $Res);
  }
}
