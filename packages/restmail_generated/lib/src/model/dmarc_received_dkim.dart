// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DmarcReceivedDkim extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DmarcReceivedDkim({
    required this.domain,
    required this.result,
    this.humanResult,
    this.selector,
  });

  factory DmarcReceivedDkim.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'domain', r'human_result', r'result', r'selector'},
      listKeys: {},
      context: r'DmarcReceivedDkim',
    );
    return DmarcReceivedDkim(
      domain: _$values[r'domain'].decodeSimpleString(
        context: r'DmarcReceivedDkim.domain',
      ),
      humanResult: _$values[r'human_result'].decodeSimpleNullableString(
        context: r'DmarcReceivedDkim.human_result',
      ),
      result: _$values[r'result'].decodeSimpleString(
        context: r'DmarcReceivedDkim.result',
      ),
      selector: _$values[r'selector'].decodeSimpleNullableString(
        context: r'DmarcReceivedDkim.selector',
      ),
    );
  }

  factory DmarcReceivedDkim.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DmarcReceivedDkim');
    return DmarcReceivedDkim(
      domain: _$map[r'domain'].decodeJsonString(
        context: r'DmarcReceivedDkim.domain',
      ),
      humanResult: _$map[r'human_result'].decodeJsonNullableString(
        context: r'DmarcReceivedDkim.human_result',
      ),
      result: _$map[r'result'].decodeJsonString(
        context: r'DmarcReceivedDkim.result',
      ),
      selector: _$map[r'selector'].decodeJsonNullableString(
        context: r'DmarcReceivedDkim.selector',
      ),
    );
  }

  factory DmarcReceivedDkim.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'domain', r'human_result', r'result', r'selector'},
      listKeys: {},
      context: r'DmarcReceivedDkim',
    );
    return DmarcReceivedDkim(
      domain: _$values[r'domain'].decodeFormString(
        context: r'DmarcReceivedDkim.domain',
      ),
      humanResult: _$values[r'human_result'].decodeFormNullableString(
        context: r'DmarcReceivedDkim.human_result',
      ),
      result: _$values[r'result'].decodeFormString(
        context: r'DmarcReceivedDkim.result',
      ),
      selector: _$values[r'selector'].decodeFormNullableString(
        context: r'DmarcReceivedDkim.selector',
      ),
    );
  }

  final _i3.String domain;

  final _i3.String? humanResult;

  final _i3.String result;

  final _i3.String? selector;

  @_i3.override
  _i3.Object? toJson() => {
    r'domain': domain,
    if (humanResult != null) r'human_result': humanResult,
    r'result': result,
    if (selector != null) r'selector': selector,
  };

  $$DmarcReceivedDkimCopyWith<DmarcReceivedDkim> get copyWith =>
      _DmarcReceivedDkimCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DmarcReceivedDkim &&
        other.domain == this.domain &&
        other.humanResult == this.humanResult &&
        other.result == this.result &&
        other.selector == this.selector;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([domain, humanResult, result, selector]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'domain'] = _i1.PropertyValue.scalar(domain);
    if (humanResult != null) {
      _$result[r'human_result'] = _i1.PropertyValue.scalar(humanResult!);
    }
    _$result[r'result'] = _i1.PropertyValue.scalar(result);
    if (selector != null) {
      _$result[r'selector'] = _i1.PropertyValue.scalar(selector!);
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
      r'Cannot uriEncode DmarcReceivedDkim: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DmarcReceivedDkimCopyWith<$Res> {
  factory $$DmarcReceivedDkimCopyWith(DmarcReceivedDkim value) =
      _DmarcReceivedDkimCopyWith<$Res>;

  $Res call({
    _i3.String? domain,
    _i3.String? humanResult,
    _i3.String? result,
    _i3.String? selector,
  });
  _i3.String get domain;
  _i3.String? get humanResult;
  _i3.String get result;
  _i3.String? get selector;
}

class _DmarcReceivedDkimCopyWith<$Res>
    implements $$DmarcReceivedDkimCopyWith<$Res> {
  _DmarcReceivedDkimCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DmarcReceivedDkim _value;

  @_i3.override
  _i3.String get domain => _value.domain;

  @_i3.override
  _i3.String? get humanResult => _value.humanResult;

  @_i3.override
  _i3.String get result => _value.result;

  @_i3.override
  _i3.String? get selector => _value.selector;

  @_i3.override
  $Res call({
    _i3.Object? domain = _sentinel,
    _i3.Object? humanResult = _sentinel,
    _i3.Object? result = _sentinel,
    _i3.Object? selector = _sentinel,
  }) {
    return (DmarcReceivedDkim(
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i3.String),
      humanResult: _i3.identical(humanResult, _sentinel)
          ? this.humanResult
          : (humanResult as _i3.String?),
      result: _i3.identical(result, _sentinel)
          ? this.result
          : (result as _i3.String),
      selector: _i3.identical(selector, _sentinel)
          ? this.selector
          : (selector as _i3.String?),
    ) as $Res);
  }
}
