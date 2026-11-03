// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i9;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i8;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/dmarc_received_evaluation_disposition_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/dmarc_received_evaluation_dkim_model.dart'
    as _i5;
import 'package:restmail_generated/src/model/dmarc_received_evaluation_spf_model.dart'
    as _i7;
import 'package:restmail_generated/src/model/dmarc_received_reason.dart' as _i6;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DmarcReceivedEvaluation extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DmarcReceivedEvaluation({
    required this.disposition,
    required this.dkim,
    required this.spf,
    this.reasons,
  });

  factory DmarcReceivedEvaluation.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DmarcReceivedEvaluation: contains complex types',
    );
  }

  factory DmarcReceivedEvaluation.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DmarcReceivedEvaluation');
    return DmarcReceivedEvaluation(
      disposition: _i4.DmarcReceivedEvaluationDispositionModel.fromJson(
        _$map[r'disposition'],
      ),
      dkim: _i5.DmarcReceivedEvaluationDkimModel.fromJson(_$map[r'dkim']),
      reasons: _$map[r'reasons']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'DmarcReceivedEvaluation.reasons',
          )
          ?.map(_i6.DmarcReceivedReason.fromJson)
          .toList(),
      spf: _i7.DmarcReceivedEvaluationSpfModel.fromJson(_$map[r'spf']),
    );
  }

  factory DmarcReceivedEvaluation.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DmarcReceivedEvaluation: contains complex types',
    );
  }

  final _i4.DmarcReceivedEvaluationDispositionModel disposition;

  final _i5.DmarcReceivedEvaluationDkimModel dkim;

  final _i3.List<_i6.DmarcReceivedReason>? reasons;

  final _i7.DmarcReceivedEvaluationSpfModel spf;

  @_i3.override
  _i3.Object? toJson() => {
    r'disposition': disposition.toJson(),
    r'dkim': dkim.toJson(),
    if (reasons != null) r'reasons': reasons?.map((e) => e.toJson()).toList(),
    r'spf': spf.toJson(),
  };

  $$DmarcReceivedEvaluationCopyWith<DmarcReceivedEvaluation> get copyWith =>
      _DmarcReceivedEvaluationCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i8.DeepCollectionEquality();
    return other is DmarcReceivedEvaluation &&
        other.disposition == this.disposition &&
        other.dkim == this.dkim &&
        _$deepEquals.equals(other.reasons, this.reasons) &&
        other.spf == this.spf;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i8.DeepCollectionEquality();
    return _i3.Object.hashAll([
      disposition,
      dkim,
      deepEquals.hash(reasons),
      spf,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DmarcReceivedEvaluation: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i9.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DmarcReceivedEvaluation: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DmarcReceivedEvaluationCopyWith<$Res> {
  factory $$DmarcReceivedEvaluationCopyWith(DmarcReceivedEvaluation value) =
      _DmarcReceivedEvaluationCopyWith<$Res>;

  $Res call({
    _i4.DmarcReceivedEvaluationDispositionModel? disposition,
    _i5.DmarcReceivedEvaluationDkimModel? dkim,
    _i3.List<_i6.DmarcReceivedReason>? reasons,
    _i7.DmarcReceivedEvaluationSpfModel? spf,
  });
  _i4.DmarcReceivedEvaluationDispositionModel get disposition;
  _i5.DmarcReceivedEvaluationDkimModel get dkim;
  _i3.List<_i6.DmarcReceivedReason>? get reasons;
  _i7.DmarcReceivedEvaluationSpfModel get spf;
}

class _DmarcReceivedEvaluationCopyWith<$Res>
    implements $$DmarcReceivedEvaluationCopyWith<$Res> {
  _DmarcReceivedEvaluationCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DmarcReceivedEvaluation _value;

  @_i3.override
  _i4.DmarcReceivedEvaluationDispositionModel get disposition =>
      _value.disposition;

  @_i3.override
  _i5.DmarcReceivedEvaluationDkimModel get dkim => _value.dkim;

  @_i3.override
  _i3.List<_i6.DmarcReceivedReason>? get reasons => _value.reasons;

  @_i3.override
  _i7.DmarcReceivedEvaluationSpfModel get spf => _value.spf;

  @_i3.override
  $Res call({
    _i3.Object? disposition = _sentinel,
    _i3.Object? dkim = _sentinel,
    _i3.Object? reasons = _sentinel,
    _i3.Object? spf = _sentinel,
  }) {
    return (DmarcReceivedEvaluation(
      disposition: _i3.identical(disposition, _sentinel)
          ? this.disposition
          : (disposition as _i4.DmarcReceivedEvaluationDispositionModel),
      dkim: _i3.identical(dkim, _sentinel)
          ? this.dkim
          : (dkim as _i5.DmarcReceivedEvaluationDkimModel),
      reasons: _i3.identical(reasons, _sentinel)
          ? this.reasons
          : (reasons as _i3.List<_i6.DmarcReceivedReason>?),
      spf: _i3.identical(spf, _sentinel)
          ? this.spf
          : (spf as _i7.DmarcReceivedEvaluationSpfModel),
    ) as $Res);
  }
}
