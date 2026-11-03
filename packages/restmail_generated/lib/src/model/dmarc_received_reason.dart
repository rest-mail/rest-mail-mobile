// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DmarcReceivedReason extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DmarcReceivedReason({required this.$type, this.comment});

  factory DmarcReceivedReason.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'comment', r'type'},
      listKeys: {},
      context: r'DmarcReceivedReason',
    );
    return DmarcReceivedReason(
      comment: _$values[r'comment'].decodeSimpleNullableString(
        context: r'DmarcReceivedReason.comment',
      ),
      $type: _$values[r'type'].decodeSimpleString(
        context: r'DmarcReceivedReason.type',
      ),
    );
  }

  factory DmarcReceivedReason.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DmarcReceivedReason');
    return DmarcReceivedReason(
      comment: _$map[r'comment'].decodeJsonNullableString(
        context: r'DmarcReceivedReason.comment',
      ),
      $type: _$map[r'type'].decodeJsonString(
        context: r'DmarcReceivedReason.type',
      ),
    );
  }

  factory DmarcReceivedReason.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'comment', r'type'},
      listKeys: {},
      context: r'DmarcReceivedReason',
    );
    return DmarcReceivedReason(
      comment: _$values[r'comment'].decodeFormNullableString(
        context: r'DmarcReceivedReason.comment',
      ),
      $type: _$values[r'type'].decodeFormString(
        context: r'DmarcReceivedReason.type',
      ),
    );
  }

  final _i3.String? comment;

  final _i3.String $type;

  @_i3.override
  _i3.Object? toJson() => {
    if (comment != null) r'comment': comment,
    r'type': $type,
  };

  $$DmarcReceivedReasonCopyWith<DmarcReceivedReason> get copyWith =>
      _DmarcReceivedReasonCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DmarcReceivedReason &&
        other.comment == this.comment &&
        other.$type == this.$type;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([comment, $type]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (comment != null) {
      _$result[r'comment'] = _i1.PropertyValue.scalar(comment!);
    }
    _$result[r'type'] = _i1.PropertyValue.scalar($type);
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
      r'Cannot uriEncode DmarcReceivedReason: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DmarcReceivedReasonCopyWith<$Res> {
  factory $$DmarcReceivedReasonCopyWith(DmarcReceivedReason value) =
      _DmarcReceivedReasonCopyWith<$Res>;

  $Res call({_i3.String? comment, _i3.String? $type});
  _i3.String? get comment;
  _i3.String get $type;
}

class _DmarcReceivedReasonCopyWith<$Res>
    implements $$DmarcReceivedReasonCopyWith<$Res> {
  _DmarcReceivedReasonCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DmarcReceivedReason _value;

  @_i3.override
  _i3.String? get comment => _value.comment;

  @_i3.override
  _i3.String get $type => _value.$type;

  @_i3.override
  $Res call({_i3.Object? comment = _sentinel, _i3.Object? $type = _sentinel}) {
    return (DmarcReceivedReason(
      comment: _i3.identical(comment, _sentinel)
          ? this.comment
          : (comment as _i3.String?),
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type as _i3.String),
    ) as $Res);
  }
}
