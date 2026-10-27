// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ForwardBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ForwardBody({this.bodyText, this.from, this.to});

  factory ForwardBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'body_text', r'from', r'to'},
      listKeys: {r'to'},
      context: r'ForwardBody',
    );
    return ForwardBody(
      bodyText: _$values[r'body_text'].decodeSimpleNullableString(
        context: r'ForwardBody.body_text',
      ),
      from: _$values[r'from'].decodeSimpleNullableString(
        context: r'ForwardBody.from',
      ),
      to: _$values[r'to'].decodeSimpleNullableStringList(
        context: r'ForwardBody.to',
      ),
    );
  }

  factory ForwardBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ForwardBody');
    return ForwardBody(
      bodyText: _$map[r'body_text'].decodeJsonNullableString(
        context: r'ForwardBody.body_text',
      ),
      from: _$map[r'from'].decodeJsonNullableString(
        context: r'ForwardBody.from',
      ),
      to: _$map[r'to'].decodeJsonNullableList<_i3.String>(
        context: r'ForwardBody.to',
      ),
    );
  }

  factory ForwardBody.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'body_text', r'from', r'to'},
      listKeys: {r'to'},
      context: r'ForwardBody',
    );
    return ForwardBody(
      bodyText: _$values[r'body_text'].decodeFormNullableString(
        context: r'ForwardBody.body_text',
      ),
      from: _$values[r'from'].decodeFormNullableString(
        context: r'ForwardBody.from',
      ),
      to: _$values[r'to'].decodeFormNullableStringList(
        context: r'ForwardBody.to',
      ),
    );
  }

  final _i3.String? bodyText;

  final _i3.String? from;

  final _i3.List<_i3.String>? to;

  @_i3.override
  _i3.Object? toJson() => {
    if (bodyText != null) r'body_text': bodyText,
    if (from != null) r'from': from,
    if (to != null) r'to': to,
  };

  $$ForwardBodyCopyWith<ForwardBody> get copyWith => _ForwardBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is ForwardBody &&
        other.bodyText == this.bodyText &&
        other.from == this.from &&
        _$deepEquals.equals(other.to, this.to);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([bodyText, from, deepEquals.hash(to)]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (bodyText != null) {
      _$result[r'body_text'] = _i1.PropertyValue.scalar(bodyText!);
    }
    if (from != null) {
      _$result[r'from'] = _i1.PropertyValue.scalar(from!);
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
      r'Cannot uriEncode ForwardBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ForwardBodyCopyWith<$Res> {
  factory $$ForwardBodyCopyWith(ForwardBody value) = _ForwardBodyCopyWith<$Res>;

  $Res call({_i3.String? bodyText, _i3.String? from, _i3.List<_i3.String>? to});
  _i3.String? get bodyText;
  _i3.String? get from;
  _i3.List<_i3.String>? get to;
}

class _ForwardBodyCopyWith<$Res> implements $$ForwardBodyCopyWith<$Res> {
  _ForwardBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ForwardBody _value;

  @_i3.override
  _i3.String? get bodyText => _value.bodyText;

  @_i3.override
  _i3.String? get from => _value.from;

  @_i3.override
  _i3.List<_i3.String>? get to => _value.to;

  @_i3.override
  $Res call({
    _i3.Object? bodyText = _sentinel,
    _i3.Object? from = _sentinel,
    _i3.Object? to = _sentinel,
  }) {
    return (ForwardBody(
      bodyText: _i3.identical(bodyText, _sentinel)
          ? this.bodyText
          : (bodyText as _i3.String?),
      from: _i3.identical(from, _sentinel) ? this.from : (from as _i3.String?),
      to: _i3.identical(to, _sentinel)
          ? this.to
          : (to as _i3.List<_i3.String>?),
    ) as $Res);
  }
}
