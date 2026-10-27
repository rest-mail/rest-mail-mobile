// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UpdateDraftBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UpdateDraftBody({
    this.bodyHtml,
    this.bodyText,
    this.cc,
    this.from,
    this.inReplyTo,
    this.references,
    this.subject,
    this.to,
  });

  factory UpdateDraftBody.fromSimple(
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
      context: r'UpdateDraftBody',
    );
    return UpdateDraftBody(
      bodyHtml: _$values[r'body_html'].decodeSimpleNullableString(
        context: r'UpdateDraftBody.body_html',
      ),
      bodyText: _$values[r'body_text'].decodeSimpleNullableString(
        context: r'UpdateDraftBody.body_text',
      ),
      cc: _$values[r'cc'].decodeSimpleNullableStringList(
        context: r'UpdateDraftBody.cc',
      ),
      from: _$values[r'from'].decodeSimpleNullableString(
        context: r'UpdateDraftBody.from',
      ),
      inReplyTo: _$values[r'in_reply_to'].decodeSimpleNullableString(
        context: r'UpdateDraftBody.in_reply_to',
      ),
      references: _$values[r'references'].decodeSimpleNullableString(
        context: r'UpdateDraftBody.references',
      ),
      subject: _$values[r'subject'].decodeSimpleNullableString(
        context: r'UpdateDraftBody.subject',
      ),
      to: _$values[r'to'].decodeSimpleNullableStringList(
        context: r'UpdateDraftBody.to',
      ),
    );
  }

  factory UpdateDraftBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UpdateDraftBody');
    return UpdateDraftBody(
      bodyHtml: _$map[r'body_html'].decodeJsonNullableString(
        context: r'UpdateDraftBody.body_html',
      ),
      bodyText: _$map[r'body_text'].decodeJsonNullableString(
        context: r'UpdateDraftBody.body_text',
      ),
      cc: _$map[r'cc'].decodeJsonNullableList<_i3.String>(
        context: r'UpdateDraftBody.cc',
      ),
      from: _$map[r'from'].decodeJsonNullableString(
        context: r'UpdateDraftBody.from',
      ),
      inReplyTo: _$map[r'in_reply_to'].decodeJsonNullableString(
        context: r'UpdateDraftBody.in_reply_to',
      ),
      references: _$map[r'references'].decodeJsonNullableString(
        context: r'UpdateDraftBody.references',
      ),
      subject: _$map[r'subject'].decodeJsonNullableString(
        context: r'UpdateDraftBody.subject',
      ),
      to: _$map[r'to'].decodeJsonNullableList<_i3.String>(
        context: r'UpdateDraftBody.to',
      ),
    );
  }

  factory UpdateDraftBody.fromForm(
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
      context: r'UpdateDraftBody',
    );
    return UpdateDraftBody(
      bodyHtml: _$values[r'body_html'].decodeFormNullableString(
        context: r'UpdateDraftBody.body_html',
      ),
      bodyText: _$values[r'body_text'].decodeFormNullableString(
        context: r'UpdateDraftBody.body_text',
      ),
      cc: _$values[r'cc'].decodeFormNullableStringList(
        context: r'UpdateDraftBody.cc',
      ),
      from: _$values[r'from'].decodeFormNullableString(
        context: r'UpdateDraftBody.from',
      ),
      inReplyTo: _$values[r'in_reply_to'].decodeFormNullableString(
        context: r'UpdateDraftBody.in_reply_to',
      ),
      references: _$values[r'references'].decodeFormNullableString(
        context: r'UpdateDraftBody.references',
      ),
      subject: _$values[r'subject'].decodeFormNullableString(
        context: r'UpdateDraftBody.subject',
      ),
      to: _$values[r'to'].decodeFormNullableStringList(
        context: r'UpdateDraftBody.to',
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
    r'body_html': bodyHtml,
    r'body_text': bodyText,
    if (cc != null) r'cc': cc,
    r'from': from,
    r'in_reply_to': inReplyTo,
    r'references': references,
    r'subject': subject,
    if (to != null) r'to': to,
  };

  $$UpdateDraftBodyCopyWith<UpdateDraftBody> get copyWith =>
      _UpdateDraftBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is UpdateDraftBody &&
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
      r'Cannot uriEncode UpdateDraftBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UpdateDraftBodyCopyWith<$Res> {
  factory $$UpdateDraftBodyCopyWith(UpdateDraftBody value) =
      _UpdateDraftBodyCopyWith<$Res>;

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

class _UpdateDraftBodyCopyWith<$Res>
    implements $$UpdateDraftBodyCopyWith<$Res> {
  _UpdateDraftBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UpdateDraftBody _value;

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
    return (UpdateDraftBody(
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
