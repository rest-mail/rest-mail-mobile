// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ListUnsubscribe extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ListUnsubscribe({this.https, this.mailto});

  factory ListUnsubscribe.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'https', r'mailto'},
      listKeys: {},
      context: r'ListUnsubscribe',
    );
    return ListUnsubscribe(
      https: _$values[r'https'].decodeSimpleNullableString(
        context: r'ListUnsubscribe.https',
      ),
      mailto: _$values[r'mailto'].decodeSimpleNullableString(
        context: r'ListUnsubscribe.mailto',
      ),
    );
  }

  factory ListUnsubscribe.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ListUnsubscribe');
    return ListUnsubscribe(
      https: _$map[r'https'].decodeJsonNullableString(
        context: r'ListUnsubscribe.https',
      ),
      mailto: _$map[r'mailto'].decodeJsonNullableString(
        context: r'ListUnsubscribe.mailto',
      ),
    );
  }

  factory ListUnsubscribe.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'https', r'mailto'},
      listKeys: {},
      context: r'ListUnsubscribe',
    );
    return ListUnsubscribe(
      https: _$values[r'https'].decodeFormNullableString(
        context: r'ListUnsubscribe.https',
      ),
      mailto: _$values[r'mailto'].decodeFormNullableString(
        context: r'ListUnsubscribe.mailto',
      ),
    );
  }

  final _i3.String? https;

  final _i3.String? mailto;

  @_i3.override
  _i3.Object? toJson() => {
    if (https != null) r'https': https,
    if (mailto != null) r'mailto': mailto,
  };

  $$ListUnsubscribeCopyWith<ListUnsubscribe> get copyWith =>
      _ListUnsubscribeCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListUnsubscribe &&
        other.https == this.https &&
        other.mailto == this.mailto;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([https, mailto]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (https != null) {
      _$result[r'https'] = _i1.PropertyValue.scalar(https!);
    }
    if (mailto != null) {
      _$result[r'mailto'] = _i1.PropertyValue.scalar(mailto!);
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
      r'Cannot uriEncode ListUnsubscribe: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ListUnsubscribeCopyWith<$Res> {
  factory $$ListUnsubscribeCopyWith(ListUnsubscribe value) =
      _ListUnsubscribeCopyWith<$Res>;

  $Res call({_i3.String? https, _i3.String? mailto});
  _i3.String? get https;
  _i3.String? get mailto;
}

class _ListUnsubscribeCopyWith<$Res>
    implements $$ListUnsubscribeCopyWith<$Res> {
  _ListUnsubscribeCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ListUnsubscribe _value;

  @_i3.override
  _i3.String? get https => _value.https;

  @_i3.override
  _i3.String? get mailto => _value.mailto;

  @_i3.override
  $Res call({_i3.Object? https = _sentinel, _i3.Object? mailto = _sentinel}) {
    return (ListUnsubscribe(
      https: _i3.identical(https, _sentinel)
          ? this.https
          : (https as _i3.String?),
      mailto: _i3.identical(mailto, _sentinel)
          ? this.mailto
          : (mailto as _i3.String?),
    ) as $Res);
  }
}
