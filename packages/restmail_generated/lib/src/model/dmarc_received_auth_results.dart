// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/dmarc_received_dkim.dart' as _i4;
import 'package:restmail_generated/src/model/dmarc_received_spf.dart' as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DmarcReceivedAuthResults extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DmarcReceivedAuthResults({this.dkim, this.spf});

  factory DmarcReceivedAuthResults.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DmarcReceivedAuthResults: contains complex types',
    );
  }

  factory DmarcReceivedAuthResults.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DmarcReceivedAuthResults');
    return DmarcReceivedAuthResults(
      dkim: _$map[r'dkim']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'DmarcReceivedAuthResults.dkim',
          )
          ?.map(_i4.DmarcReceivedDkim.fromJson)
          .toList(),
      spf: _$map[r'spf']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'DmarcReceivedAuthResults.spf',
          )
          ?.map(_i5.DmarcReceivedSpf.fromJson)
          .toList(),
    );
  }

  factory DmarcReceivedAuthResults.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DmarcReceivedAuthResults: contains complex types',
    );
  }

  final _i3.List<_i4.DmarcReceivedDkim>? dkim;

  final _i3.List<_i5.DmarcReceivedSpf>? spf;

  @_i3.override
  _i3.Object? toJson() => {
    if (dkim != null) r'dkim': dkim?.map((e) => e.toJson()).toList(),
    if (spf != null) r'spf': spf?.map((e) => e.toJson()).toList(),
  };

  $$DmarcReceivedAuthResultsCopyWith<DmarcReceivedAuthResults> get copyWith =>
      _DmarcReceivedAuthResultsCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is DmarcReceivedAuthResults &&
        _$deepEquals.equals(other.dkim, this.dkim) &&
        _$deepEquals.equals(other.spf, this.spf);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([deepEquals.hash(dkim), deepEquals.hash(spf)]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DmarcReceivedAuthResults: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DmarcReceivedAuthResults: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DmarcReceivedAuthResultsCopyWith<$Res> {
  factory $$DmarcReceivedAuthResultsCopyWith(DmarcReceivedAuthResults value) =
      _DmarcReceivedAuthResultsCopyWith<$Res>;

  $Res call({
    _i3.List<_i4.DmarcReceivedDkim>? dkim,
    _i3.List<_i5.DmarcReceivedSpf>? spf,
  });
  _i3.List<_i4.DmarcReceivedDkim>? get dkim;
  _i3.List<_i5.DmarcReceivedSpf>? get spf;
}

class _DmarcReceivedAuthResultsCopyWith<$Res>
    implements $$DmarcReceivedAuthResultsCopyWith<$Res> {
  _DmarcReceivedAuthResultsCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DmarcReceivedAuthResults _value;

  @_i3.override
  _i3.List<_i4.DmarcReceivedDkim>? get dkim => _value.dkim;

  @_i3.override
  _i3.List<_i5.DmarcReceivedSpf>? get spf => _value.spf;

  @_i3.override
  $Res call({_i3.Object? dkim = _sentinel, _i3.Object? spf = _sentinel}) {
    return (DmarcReceivedAuthResults(
      dkim: _i3.identical(dkim, _sentinel)
          ? this.dkim
          : (dkim as _i3.List<_i4.DmarcReceivedDkim>?),
      spf: _i3.identical(spf, _sentinel)
          ? this.spf
          : (spf as _i3.List<_i5.DmarcReceivedSpf>?),
    ) as $Res);
  }
}
