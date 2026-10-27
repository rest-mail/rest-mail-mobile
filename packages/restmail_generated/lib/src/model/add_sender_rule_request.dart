// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class AddSenderRuleRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const AddSenderRuleRequest({required this.pattern, this.reason});

  factory AddSenderRuleRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'pattern', r'reason'},
      listKeys: {},
      context: r'AddSenderRuleRequest',
    );
    return AddSenderRuleRequest(
      pattern: _$values[r'pattern'].decodeSimpleString(
        context: r'AddSenderRuleRequest.pattern',
      ),
      reason: _$values[r'reason'].decodeSimpleNullableString(
        context: r'AddSenderRuleRequest.reason',
      ),
    );
  }

  factory AddSenderRuleRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'AddSenderRuleRequest');
    return AddSenderRuleRequest(
      pattern: _$map[r'pattern'].decodeJsonString(
        context: r'AddSenderRuleRequest.pattern',
      ),
      reason: _$map[r'reason'].decodeJsonNullableString(
        context: r'AddSenderRuleRequest.reason',
      ),
    );
  }

  factory AddSenderRuleRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'pattern', r'reason'},
      listKeys: {},
      context: r'AddSenderRuleRequest',
    );
    return AddSenderRuleRequest(
      pattern: _$values[r'pattern'].decodeFormString(
        context: r'AddSenderRuleRequest.pattern',
      ),
      reason: _$values[r'reason'].decodeFormNullableString(
        context: r'AddSenderRuleRequest.reason',
      ),
    );
  }

  final _i3.String pattern;

  final _i3.String? reason;

  @_i3.override
  _i3.Object? toJson() => {
    r'pattern': pattern,
    if (reason != null) r'reason': reason,
  };

  $$AddSenderRuleRequestCopyWith<AddSenderRuleRequest> get copyWith =>
      _AddSenderRuleRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddSenderRuleRequest &&
        other.pattern == this.pattern &&
        other.reason == this.reason;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([pattern, reason]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'pattern'] = _i1.PropertyValue.scalar(pattern);
    if (reason != null) {
      _$result[r'reason'] = _i1.PropertyValue.scalar(reason!);
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
      r'Cannot uriEncode AddSenderRuleRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AddSenderRuleRequestCopyWith<$Res> {
  factory $$AddSenderRuleRequestCopyWith(AddSenderRuleRequest value) =
      _AddSenderRuleRequestCopyWith<$Res>;

  $Res call({_i3.String? pattern, _i3.String? reason});
  _i3.String get pattern;
  _i3.String? get reason;
}

class _AddSenderRuleRequestCopyWith<$Res>
    implements $$AddSenderRuleRequestCopyWith<$Res> {
  _AddSenderRuleRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final AddSenderRuleRequest _value;

  @_i3.override
  _i3.String get pattern => _value.pattern;

  @_i3.override
  _i3.String? get reason => _value.reason;

  @_i3.override
  $Res call({_i3.Object? pattern = _sentinel, _i3.Object? reason = _sentinel}) {
    return (AddSenderRuleRequest(
      pattern: _i3.identical(pattern, _sentinel)
          ? this.pattern
          : (pattern as _i3.String),
      reason: _i3.identical(reason, _sentinel)
          ? this.reason
          : (reason as _i3.String?),
    ) as $Res);
  }
}
