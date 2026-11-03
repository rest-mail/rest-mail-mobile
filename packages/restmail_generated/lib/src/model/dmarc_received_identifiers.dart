// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DmarcReceivedIdentifiers extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DmarcReceivedIdentifiers({
    required this.headerFrom,
    this.envelopeFrom,
    this.envelopeTo,
  });

  factory DmarcReceivedIdentifiers.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'envelope_from', r'envelope_to', r'header_from'},
      listKeys: {},
      context: r'DmarcReceivedIdentifiers',
    );
    return DmarcReceivedIdentifiers(
      envelopeFrom: _$values[r'envelope_from'].decodeSimpleNullableString(
        context: r'DmarcReceivedIdentifiers.envelope_from',
      ),
      envelopeTo: _$values[r'envelope_to'].decodeSimpleNullableString(
        context: r'DmarcReceivedIdentifiers.envelope_to',
      ),
      headerFrom: _$values[r'header_from'].decodeSimpleString(
        context: r'DmarcReceivedIdentifiers.header_from',
      ),
    );
  }

  factory DmarcReceivedIdentifiers.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DmarcReceivedIdentifiers');
    return DmarcReceivedIdentifiers(
      envelopeFrom: _$map[r'envelope_from'].decodeJsonNullableString(
        context: r'DmarcReceivedIdentifiers.envelope_from',
      ),
      envelopeTo: _$map[r'envelope_to'].decodeJsonNullableString(
        context: r'DmarcReceivedIdentifiers.envelope_to',
      ),
      headerFrom: _$map[r'header_from'].decodeJsonString(
        context: r'DmarcReceivedIdentifiers.header_from',
      ),
    );
  }

  factory DmarcReceivedIdentifiers.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'envelope_from', r'envelope_to', r'header_from'},
      listKeys: {},
      context: r'DmarcReceivedIdentifiers',
    );
    return DmarcReceivedIdentifiers(
      envelopeFrom: _$values[r'envelope_from'].decodeFormNullableString(
        context: r'DmarcReceivedIdentifiers.envelope_from',
      ),
      envelopeTo: _$values[r'envelope_to'].decodeFormNullableString(
        context: r'DmarcReceivedIdentifiers.envelope_to',
      ),
      headerFrom: _$values[r'header_from'].decodeFormString(
        context: r'DmarcReceivedIdentifiers.header_from',
      ),
    );
  }

  final _i3.String? envelopeFrom;

  final _i3.String? envelopeTo;

  final _i3.String headerFrom;

  @_i3.override
  _i3.Object? toJson() => {
    if (envelopeFrom != null) r'envelope_from': envelopeFrom,
    if (envelopeTo != null) r'envelope_to': envelopeTo,
    r'header_from': headerFrom,
  };

  $$DmarcReceivedIdentifiersCopyWith<DmarcReceivedIdentifiers> get copyWith =>
      _DmarcReceivedIdentifiersCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DmarcReceivedIdentifiers &&
        other.envelopeFrom == this.envelopeFrom &&
        other.envelopeTo == this.envelopeTo &&
        other.headerFrom == this.headerFrom;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([envelopeFrom, envelopeTo, headerFrom]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (envelopeFrom != null) {
      _$result[r'envelope_from'] = _i1.PropertyValue.scalar(envelopeFrom!);
    }
    if (envelopeTo != null) {
      _$result[r'envelope_to'] = _i1.PropertyValue.scalar(envelopeTo!);
    }
    _$result[r'header_from'] = _i1.PropertyValue.scalar(headerFrom);
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
      r'Cannot uriEncode DmarcReceivedIdentifiers: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DmarcReceivedIdentifiersCopyWith<$Res> {
  factory $$DmarcReceivedIdentifiersCopyWith(DmarcReceivedIdentifiers value) =
      _DmarcReceivedIdentifiersCopyWith<$Res>;

  $Res call({
    _i3.String? envelopeFrom,
    _i3.String? envelopeTo,
    _i3.String? headerFrom,
  });
  _i3.String? get envelopeFrom;
  _i3.String? get envelopeTo;
  _i3.String get headerFrom;
}

class _DmarcReceivedIdentifiersCopyWith<$Res>
    implements $$DmarcReceivedIdentifiersCopyWith<$Res> {
  _DmarcReceivedIdentifiersCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DmarcReceivedIdentifiers _value;

  @_i3.override
  _i3.String? get envelopeFrom => _value.envelopeFrom;

  @_i3.override
  _i3.String? get envelopeTo => _value.envelopeTo;

  @_i3.override
  _i3.String get headerFrom => _value.headerFrom;

  @_i3.override
  $Res call({
    _i3.Object? envelopeFrom = _sentinel,
    _i3.Object? envelopeTo = _sentinel,
    _i3.Object? headerFrom = _sentinel,
  }) {
    return (DmarcReceivedIdentifiers(
      envelopeFrom: _i3.identical(envelopeFrom, _sentinel)
          ? this.envelopeFrom
          : (envelopeFrom as _i3.String?),
      envelopeTo: _i3.identical(envelopeTo, _sentinel)
          ? this.envelopeTo
          : (envelopeTo as _i3.String?),
      headerFrom: _i3.identical(headerFrom, _sentinel)
          ? this.headerFrom
          : (headerFrom as _i3.String),
    ) as $Res);
  }
}
