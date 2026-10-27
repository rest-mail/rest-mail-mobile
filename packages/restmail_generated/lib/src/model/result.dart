// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/result_anchor_one_of_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Result extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Result({
    required this.checked,
    required this.firstSeq,
    required this.lastHash,
    required this.lastSeq,
    required this.ok,
    this.anchor,
    this.brokenAtSeq,
    this.note,
    this.reason,
  });

  factory Result.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for Result: contains complex types',
    );
  }

  factory Result.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Result');
    return Result(
      anchor: _$map[r'anchor'] == null
          ? null
          : _i4.ResultAnchorOneOfModel.fromJson(_$map[r'anchor']),
      brokenAtSeq: _$map[r'broken_at_seq'].decodeJsonNullableInt(
        context: r'Result.broken_at_seq',
      ),
      checked: _$map[r'checked'].decodeJsonInt(context: r'Result.checked'),
      firstSeq: _$map[r'first_seq'].decodeJsonInt(context: r'Result.first_seq'),
      lastHash: _$map[r'last_hash'].decodeJsonString(
        context: r'Result.last_hash',
      ),
      lastSeq: _$map[r'last_seq'].decodeJsonInt(context: r'Result.last_seq'),
      note: _$map[r'note'].decodeJsonNullableString(context: r'Result.note'),
      ok: _$map[r'ok'].decodeJsonBool(context: r'Result.ok'),
      reason: _$map[r'reason'].decodeJsonNullableString(
        context: r'Result.reason',
      ),
    );
  }

  factory Result.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for Result: contains complex types',
    );
  }

  final _i4.ResultAnchorOneOfModel? anchor;

  final _i3.int? brokenAtSeq;

  final _i3.int checked;

  final _i3.int firstSeq;

  final _i3.String lastHash;

  final _i3.int lastSeq;

  final _i3.String? note;

  final _i3.bool ok;

  final _i3.String? reason;

  @_i3.override
  _i3.Object? toJson() => {
    if (anchor != null) r'anchor': anchor?.toJson(),
    r'broken_at_seq': brokenAtSeq,
    r'checked': checked,
    r'first_seq': firstSeq,
    r'last_hash': lastHash,
    r'last_seq': lastSeq,
    if (note != null) r'note': note,
    r'ok': ok,
    if (reason != null) r'reason': reason,
  };

  $$ResultCopyWith<Result> get copyWith => _ResultCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Result &&
        other.anchor == this.anchor &&
        other.brokenAtSeq == this.brokenAtSeq &&
        other.checked == this.checked &&
        other.firstSeq == this.firstSeq &&
        other.lastHash == this.lastHash &&
        other.lastSeq == this.lastSeq &&
        other.note == this.note &&
        other.ok == this.ok &&
        other.reason == this.reason;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      anchor,
      brokenAtSeq,
      checked,
      firstSeq,
      lastHash,
      lastSeq,
      note,
      ok,
      reason,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for Result: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode Result: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ResultCopyWith<$Res> {
  factory $$ResultCopyWith(Result value) = _ResultCopyWith<$Res>;

  $Res call({
    _i4.ResultAnchorOneOfModel? anchor,
    _i3.int? brokenAtSeq,
    _i3.int? checked,
    _i3.int? firstSeq,
    _i3.String? lastHash,
    _i3.int? lastSeq,
    _i3.String? note,
    _i3.bool? ok,
    _i3.String? reason,
  });
  _i4.ResultAnchorOneOfModel? get anchor;
  _i3.int? get brokenAtSeq;
  _i3.int get checked;
  _i3.int get firstSeq;
  _i3.String get lastHash;
  _i3.int get lastSeq;
  _i3.String? get note;
  _i3.bool get ok;
  _i3.String? get reason;
}

class _ResultCopyWith<$Res> implements $$ResultCopyWith<$Res> {
  _ResultCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Result _value;

  @_i3.override
  _i4.ResultAnchorOneOfModel? get anchor => _value.anchor;

  @_i3.override
  _i3.int? get brokenAtSeq => _value.brokenAtSeq;

  @_i3.override
  _i3.int get checked => _value.checked;

  @_i3.override
  _i3.int get firstSeq => _value.firstSeq;

  @_i3.override
  _i3.String get lastHash => _value.lastHash;

  @_i3.override
  _i3.int get lastSeq => _value.lastSeq;

  @_i3.override
  _i3.String? get note => _value.note;

  @_i3.override
  _i3.bool get ok => _value.ok;

  @_i3.override
  _i3.String? get reason => _value.reason;

  @_i3.override
  $Res call({
    _i3.Object? anchor = _sentinel,
    _i3.Object? brokenAtSeq = _sentinel,
    _i3.Object? checked = _sentinel,
    _i3.Object? firstSeq = _sentinel,
    _i3.Object? lastHash = _sentinel,
    _i3.Object? lastSeq = _sentinel,
    _i3.Object? note = _sentinel,
    _i3.Object? ok = _sentinel,
    _i3.Object? reason = _sentinel,
  }) {
    return (Result(
      anchor: _i3.identical(anchor, _sentinel)
          ? this.anchor
          : (anchor as _i4.ResultAnchorOneOfModel?),
      brokenAtSeq: _i3.identical(brokenAtSeq, _sentinel)
          ? this.brokenAtSeq
          : (brokenAtSeq as _i3.int?),
      checked: _i3.identical(checked, _sentinel)
          ? this.checked
          : (checked as _i3.int),
      firstSeq: _i3.identical(firstSeq, _sentinel)
          ? this.firstSeq
          : (firstSeq as _i3.int),
      lastHash: _i3.identical(lastHash, _sentinel)
          ? this.lastHash
          : (lastHash as _i3.String),
      lastSeq: _i3.identical(lastSeq, _sentinel)
          ? this.lastSeq
          : (lastSeq as _i3.int),
      note: _i3.identical(note, _sentinel) ? this.note : (note as _i3.String?),
      ok: _i3.identical(ok, _sentinel) ? this.ok : (ok as _i3.bool),
      reason: _i3.identical(reason, _sentinel)
          ? this.reason
          : (reason as _i3.String?),
    ) as $Res);
  }
}
