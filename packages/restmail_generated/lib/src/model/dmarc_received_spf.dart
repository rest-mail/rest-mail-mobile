// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DmarcReceivedSpf extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DmarcReceivedSpf({
    required this.domain,
    required this.result,
    this.humanResult,
    this.scope,
  });

  factory DmarcReceivedSpf.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'domain', r'human_result', r'result', r'scope'},
      listKeys: {},
      context: r'DmarcReceivedSpf',
    );
    return DmarcReceivedSpf(
      domain: _$values[r'domain'].decodeSimpleString(
        context: r'DmarcReceivedSpf.domain',
      ),
      humanResult: _$values[r'human_result'].decodeSimpleNullableString(
        context: r'DmarcReceivedSpf.human_result',
      ),
      result: _$values[r'result'].decodeSimpleString(
        context: r'DmarcReceivedSpf.result',
      ),
      scope: _$values[r'scope'].decodeSimpleNullableString(
        context: r'DmarcReceivedSpf.scope',
      ),
    );
  }

  factory DmarcReceivedSpf.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DmarcReceivedSpf');
    return DmarcReceivedSpf(
      domain: _$map[r'domain'].decodeJsonString(
        context: r'DmarcReceivedSpf.domain',
      ),
      humanResult: _$map[r'human_result'].decodeJsonNullableString(
        context: r'DmarcReceivedSpf.human_result',
      ),
      result: _$map[r'result'].decodeJsonString(
        context: r'DmarcReceivedSpf.result',
      ),
      scope: _$map[r'scope'].decodeJsonNullableString(
        context: r'DmarcReceivedSpf.scope',
      ),
    );
  }

  factory DmarcReceivedSpf.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'domain', r'human_result', r'result', r'scope'},
      listKeys: {},
      context: r'DmarcReceivedSpf',
    );
    return DmarcReceivedSpf(
      domain: _$values[r'domain'].decodeFormString(
        context: r'DmarcReceivedSpf.domain',
      ),
      humanResult: _$values[r'human_result'].decodeFormNullableString(
        context: r'DmarcReceivedSpf.human_result',
      ),
      result: _$values[r'result'].decodeFormString(
        context: r'DmarcReceivedSpf.result',
      ),
      scope: _$values[r'scope'].decodeFormNullableString(
        context: r'DmarcReceivedSpf.scope',
      ),
    );
  }

  final _i3.String domain;

  final _i3.String? humanResult;

  final _i3.String result;

  final _i3.String? scope;

  @_i3.override
  _i3.Object? toJson() => {
    r'domain': domain,
    if (humanResult != null) r'human_result': humanResult,
    r'result': result,
    if (scope != null) r'scope': scope,
  };

  $$DmarcReceivedSpfCopyWith<DmarcReceivedSpf> get copyWith =>
      _DmarcReceivedSpfCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DmarcReceivedSpf &&
        other.domain == this.domain &&
        other.humanResult == this.humanResult &&
        other.result == this.result &&
        other.scope == this.scope;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([domain, humanResult, result, scope]);
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
    if (scope != null) {
      _$result[r'scope'] = _i1.PropertyValue.scalar(scope!);
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
      r'Cannot uriEncode DmarcReceivedSpf: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DmarcReceivedSpfCopyWith<$Res> {
  factory $$DmarcReceivedSpfCopyWith(DmarcReceivedSpf value) =
      _DmarcReceivedSpfCopyWith<$Res>;

  $Res call({
    _i3.String? domain,
    _i3.String? humanResult,
    _i3.String? result,
    _i3.String? scope,
  });
  _i3.String get domain;
  _i3.String? get humanResult;
  _i3.String get result;
  _i3.String? get scope;
}

class _DmarcReceivedSpfCopyWith<$Res>
    implements $$DmarcReceivedSpfCopyWith<$Res> {
  _DmarcReceivedSpfCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DmarcReceivedSpf _value;

  @_i3.override
  _i3.String get domain => _value.domain;

  @_i3.override
  _i3.String? get humanResult => _value.humanResult;

  @_i3.override
  _i3.String get result => _value.result;

  @_i3.override
  _i3.String? get scope => _value.scope;

  @_i3.override
  $Res call({
    _i3.Object? domain = _sentinel,
    _i3.Object? humanResult = _sentinel,
    _i3.Object? result = _sentinel,
    _i3.Object? scope = _sentinel,
  }) {
    return (DmarcReceivedSpf(
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i3.String),
      humanResult: _i3.identical(humanResult, _sentinel)
          ? this.humanResult
          : (humanResult as _i3.String?),
      result: _i3.identical(result, _sentinel)
          ? this.result
          : (result as _i3.String),
      scope: _i3.identical(scope, _sentinel)
          ? this.scope
          : (scope as _i3.String?),
    ) as $Res);
  }
}
