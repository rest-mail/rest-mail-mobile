// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/dmarc_received_policy_p_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DmarcReceivedPolicy extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DmarcReceivedPolicy({
    required this.domain,
    required this.p,
    this.adkim,
    this.aspf,
    this.discoveryMethod,
    this.fo,
    this.np,
    this.pct,
    this.sp,
    this.testing,
  });

  factory DmarcReceivedPolicy.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'adkim',
        r'aspf',
        r'discovery_method',
        r'domain',
        r'fo',
        r'np',
        r'p',
        r'pct',
        r'sp',
        r'testing',
      },
      listKeys: {},
      context: r'DmarcReceivedPolicy',
    );
    return DmarcReceivedPolicy(
      adkim: _$values[r'adkim'].decodeSimpleNullableString(
        context: r'DmarcReceivedPolicy.adkim',
      ),
      aspf: _$values[r'aspf'].decodeSimpleNullableString(
        context: r'DmarcReceivedPolicy.aspf',
      ),
      discoveryMethod: _$values[r'discovery_method'].decodeSimpleNullableString(
        context: r'DmarcReceivedPolicy.discovery_method',
      ),
      domain: _$values[r'domain'].decodeSimpleString(
        context: r'DmarcReceivedPolicy.domain',
      ),
      fo: _$values[r'fo'].decodeSimpleNullableString(
        context: r'DmarcReceivedPolicy.fo',
      ),
      np: _$values[r'np'].decodeSimpleNullableString(
        context: r'DmarcReceivedPolicy.np',
      ),
      p: _i4.DmarcReceivedPolicyPModel.fromSimple(
        _$values[r'p'],
        explode: explode,
      ),
      pct: _$values[r'pct'].decodeSimpleNullableInt(
        context: r'DmarcReceivedPolicy.pct',
      ),
      sp: _$values[r'sp'].decodeSimpleNullableString(
        context: r'DmarcReceivedPolicy.sp',
      ),
      testing: _$values[r'testing'].decodeSimpleNullableString(
        context: r'DmarcReceivedPolicy.testing',
      ),
    );
  }

  factory DmarcReceivedPolicy.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DmarcReceivedPolicy');
    return DmarcReceivedPolicy(
      adkim: _$map[r'adkim'].decodeJsonNullableString(
        context: r'DmarcReceivedPolicy.adkim',
      ),
      aspf: _$map[r'aspf'].decodeJsonNullableString(
        context: r'DmarcReceivedPolicy.aspf',
      ),
      discoveryMethod: _$map[r'discovery_method'].decodeJsonNullableString(
        context: r'DmarcReceivedPolicy.discovery_method',
      ),
      domain: _$map[r'domain'].decodeJsonString(
        context: r'DmarcReceivedPolicy.domain',
      ),
      fo: _$map[r'fo'].decodeJsonNullableString(
        context: r'DmarcReceivedPolicy.fo',
      ),
      np: _$map[r'np'].decodeJsonNullableString(
        context: r'DmarcReceivedPolicy.np',
      ),
      p: _i4.DmarcReceivedPolicyPModel.fromJson(_$map[r'p']),
      pct: _$map[r'pct'].decodeJsonNullableInt(
        context: r'DmarcReceivedPolicy.pct',
      ),
      sp: _$map[r'sp'].decodeJsonNullableString(
        context: r'DmarcReceivedPolicy.sp',
      ),
      testing: _$map[r'testing'].decodeJsonNullableString(
        context: r'DmarcReceivedPolicy.testing',
      ),
    );
  }

  factory DmarcReceivedPolicy.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'adkim',
        r'aspf',
        r'discovery_method',
        r'domain',
        r'fo',
        r'np',
        r'p',
        r'pct',
        r'sp',
        r'testing',
      },
      listKeys: {},
      context: r'DmarcReceivedPolicy',
    );
    return DmarcReceivedPolicy(
      adkim: _$values[r'adkim'].decodeFormNullableString(
        context: r'DmarcReceivedPolicy.adkim',
      ),
      aspf: _$values[r'aspf'].decodeFormNullableString(
        context: r'DmarcReceivedPolicy.aspf',
      ),
      discoveryMethod: _$values[r'discovery_method'].decodeFormNullableString(
        context: r'DmarcReceivedPolicy.discovery_method',
      ),
      domain: _$values[r'domain'].decodeFormString(
        context: r'DmarcReceivedPolicy.domain',
      ),
      fo: _$values[r'fo'].decodeFormNullableString(
        context: r'DmarcReceivedPolicy.fo',
      ),
      np: _$values[r'np'].decodeFormNullableString(
        context: r'DmarcReceivedPolicy.np',
      ),
      p: _i4.DmarcReceivedPolicyPModel.fromForm(
        _$values[r'p'],
        explode: explode,
      ),
      pct: _$values[r'pct'].decodeFormNullableInt(
        context: r'DmarcReceivedPolicy.pct',
      ),
      sp: _$values[r'sp'].decodeFormNullableString(
        context: r'DmarcReceivedPolicy.sp',
      ),
      testing: _$values[r'testing'].decodeFormNullableString(
        context: r'DmarcReceivedPolicy.testing',
      ),
    );
  }

  final _i3.String? adkim;

  final _i3.String? aspf;

  final _i3.String? discoveryMethod;

  final _i3.String domain;

  final _i3.String? fo;

  final _i3.String? np;

  final _i4.DmarcReceivedPolicyPModel p;

  final _i3.int? pct;

  final _i3.String? sp;

  final _i3.String? testing;

  @_i3.override
  _i3.Object? toJson() => {
    if (adkim != null) r'adkim': adkim,
    if (aspf != null) r'aspf': aspf,
    if (discoveryMethod != null) r'discovery_method': discoveryMethod,
    r'domain': domain,
    if (fo != null) r'fo': fo,
    if (np != null) r'np': np,
    r'p': p.toJson(),
    r'pct': pct,
    if (sp != null) r'sp': sp,
    if (testing != null) r'testing': testing,
  };

  $$DmarcReceivedPolicyCopyWith<DmarcReceivedPolicy> get copyWith =>
      _DmarcReceivedPolicyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DmarcReceivedPolicy &&
        other.adkim == this.adkim &&
        other.aspf == this.aspf &&
        other.discoveryMethod == this.discoveryMethod &&
        other.domain == this.domain &&
        other.fo == this.fo &&
        other.np == this.np &&
        other.p == this.p &&
        other.pct == this.pct &&
        other.sp == this.sp &&
        other.testing == this.testing;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      adkim,
      aspf,
      discoveryMethod,
      domain,
      fo,
      np,
      p,
      pct,
      sp,
      testing,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (adkim != null) {
      _$result[r'adkim'] = _i1.PropertyValue.scalar(adkim!);
    }
    if (aspf != null) {
      _$result[r'aspf'] = _i1.PropertyValue.scalar(aspf!);
    }
    if (discoveryMethod != null) {
      _$result[r'discovery_method'] = _i1.PropertyValue.scalar(
        discoveryMethod!,
      );
    }
    _$result[r'domain'] = _i1.PropertyValue.scalar(domain);
    if (fo != null) {
      _$result[r'fo'] = _i1.PropertyValue.scalar(fo!);
    }
    if (np != null) {
      _$result[r'np'] = _i1.PropertyValue.scalar(np!);
    }
    _$result[r'p'] = _i1.PropertyValue.scalar(p.toJson());
    if (pct != null) {
      _$result[r'pct'] = _i1.PropertyValue.scalar(pct!.toString());
    }
    if (sp != null) {
      _$result[r'sp'] = _i1.PropertyValue.scalar(sp!);
    }
    if (testing != null) {
      _$result[r'testing'] = _i1.PropertyValue.scalar(testing!);
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
      r'Cannot uriEncode DmarcReceivedPolicy: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DmarcReceivedPolicyCopyWith<$Res> {
  factory $$DmarcReceivedPolicyCopyWith(DmarcReceivedPolicy value) =
      _DmarcReceivedPolicyCopyWith<$Res>;

  $Res call({
    _i3.String? adkim,
    _i3.String? aspf,
    _i3.String? discoveryMethod,
    _i3.String? domain,
    _i3.String? fo,
    _i3.String? np,
    _i4.DmarcReceivedPolicyPModel? p,
    _i3.int? pct,
    _i3.String? sp,
    _i3.String? testing,
  });
  _i3.String? get adkim;
  _i3.String? get aspf;
  _i3.String? get discoveryMethod;
  _i3.String get domain;
  _i3.String? get fo;
  _i3.String? get np;
  _i4.DmarcReceivedPolicyPModel get p;
  _i3.int? get pct;
  _i3.String? get sp;
  _i3.String? get testing;
}

class _DmarcReceivedPolicyCopyWith<$Res>
    implements $$DmarcReceivedPolicyCopyWith<$Res> {
  _DmarcReceivedPolicyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DmarcReceivedPolicy _value;

  @_i3.override
  _i3.String? get adkim => _value.adkim;

  @_i3.override
  _i3.String? get aspf => _value.aspf;

  @_i3.override
  _i3.String? get discoveryMethod => _value.discoveryMethod;

  @_i3.override
  _i3.String get domain => _value.domain;

  @_i3.override
  _i3.String? get fo => _value.fo;

  @_i3.override
  _i3.String? get np => _value.np;

  @_i3.override
  _i4.DmarcReceivedPolicyPModel get p => _value.p;

  @_i3.override
  _i3.int? get pct => _value.pct;

  @_i3.override
  _i3.String? get sp => _value.sp;

  @_i3.override
  _i3.String? get testing => _value.testing;

  @_i3.override
  $Res call({
    _i3.Object? adkim = _sentinel,
    _i3.Object? aspf = _sentinel,
    _i3.Object? discoveryMethod = _sentinel,
    _i3.Object? domain = _sentinel,
    _i3.Object? fo = _sentinel,
    _i3.Object? np = _sentinel,
    _i3.Object? p = _sentinel,
    _i3.Object? pct = _sentinel,
    _i3.Object? sp = _sentinel,
    _i3.Object? testing = _sentinel,
  }) {
    return (DmarcReceivedPolicy(
      adkim: _i3.identical(adkim, _sentinel)
          ? this.adkim
          : (adkim as _i3.String?),
      aspf: _i3.identical(aspf, _sentinel) ? this.aspf : (aspf as _i3.String?),
      discoveryMethod: _i3.identical(discoveryMethod, _sentinel)
          ? this.discoveryMethod
          : (discoveryMethod as _i3.String?),
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i3.String),
      fo: _i3.identical(fo, _sentinel) ? this.fo : (fo as _i3.String?),
      np: _i3.identical(np, _sentinel) ? this.np : (np as _i3.String?),
      p: _i3.identical(p, _sentinel)
          ? this.p
          : (p as _i4.DmarcReceivedPolicyPModel),
      pct: _i3.identical(pct, _sentinel) ? this.pct : (pct as _i3.int?),
      sp: _i3.identical(sp, _sentinel) ? this.sp : (sp as _i3.String?),
      testing: _i3.identical(testing, _sentinel)
          ? this.testing
          : (testing as _i3.String?),
    ) as $Res);
  }
}
