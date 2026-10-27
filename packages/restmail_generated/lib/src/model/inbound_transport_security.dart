// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class InboundTransportSecurity extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const InboundTransportSecurity({
    required this.overTls,
    required this.plaintext,
    required this.plaintextAuthFail,
    required this.plaintextAuthPass,
    required this.plaintextPercent,
    required this.tlsPercent,
    required this.totalInboundMx,
  });

  factory InboundTransportSecurity.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'overTLS',
        r'plaintext',
        r'plaintextAuthFail',
        r'plaintextAuthPass',
        r'plaintextPercent',
        r'tlsPercent',
        r'totalInboundMX',
      },
      listKeys: {},
      context: r'InboundTransportSecurity',
    );
    return InboundTransportSecurity(
      overTls: _$values[r'overTLS'].decodeSimpleInt(
        context: r'InboundTransportSecurity.overTLS',
      ),
      plaintext: _$values[r'plaintext'].decodeSimpleInt(
        context: r'InboundTransportSecurity.plaintext',
      ),
      plaintextAuthFail: _$values[r'plaintextAuthFail'].decodeSimpleInt(
        context: r'InboundTransportSecurity.plaintextAuthFail',
      ),
      plaintextAuthPass: _$values[r'plaintextAuthPass'].decodeSimpleInt(
        context: r'InboundTransportSecurity.plaintextAuthPass',
      ),
      plaintextPercent: _$values[r'plaintextPercent'].decodeSimpleDouble(
        context: r'InboundTransportSecurity.plaintextPercent',
      ),
      tlsPercent: _$values[r'tlsPercent'].decodeSimpleDouble(
        context: r'InboundTransportSecurity.tlsPercent',
      ),
      totalInboundMx: _$values[r'totalInboundMX'].decodeSimpleInt(
        context: r'InboundTransportSecurity.totalInboundMX',
      ),
    );
  }

  factory InboundTransportSecurity.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'InboundTransportSecurity');
    return InboundTransportSecurity(
      overTls: _$map[r'overTLS'].decodeJsonInt(
        context: r'InboundTransportSecurity.overTLS',
      ),
      plaintext: _$map[r'plaintext'].decodeJsonInt(
        context: r'InboundTransportSecurity.plaintext',
      ),
      plaintextAuthFail: _$map[r'plaintextAuthFail'].decodeJsonInt(
        context: r'InboundTransportSecurity.plaintextAuthFail',
      ),
      plaintextAuthPass: _$map[r'plaintextAuthPass'].decodeJsonInt(
        context: r'InboundTransportSecurity.plaintextAuthPass',
      ),
      plaintextPercent: _$map[r'plaintextPercent'].decodeJsonDouble(
        context: r'InboundTransportSecurity.plaintextPercent',
      ),
      tlsPercent: _$map[r'tlsPercent'].decodeJsonDouble(
        context: r'InboundTransportSecurity.tlsPercent',
      ),
      totalInboundMx: _$map[r'totalInboundMX'].decodeJsonInt(
        context: r'InboundTransportSecurity.totalInboundMX',
      ),
    );
  }

  factory InboundTransportSecurity.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'overTLS',
        r'plaintext',
        r'plaintextAuthFail',
        r'plaintextAuthPass',
        r'plaintextPercent',
        r'tlsPercent',
        r'totalInboundMX',
      },
      listKeys: {},
      context: r'InboundTransportSecurity',
    );
    return InboundTransportSecurity(
      overTls: _$values[r'overTLS'].decodeFormInt(
        context: r'InboundTransportSecurity.overTLS',
      ),
      plaintext: _$values[r'plaintext'].decodeFormInt(
        context: r'InboundTransportSecurity.plaintext',
      ),
      plaintextAuthFail: _$values[r'plaintextAuthFail'].decodeFormInt(
        context: r'InboundTransportSecurity.plaintextAuthFail',
      ),
      plaintextAuthPass: _$values[r'plaintextAuthPass'].decodeFormInt(
        context: r'InboundTransportSecurity.plaintextAuthPass',
      ),
      plaintextPercent: _$values[r'plaintextPercent'].decodeFormDouble(
        context: r'InboundTransportSecurity.plaintextPercent',
      ),
      tlsPercent: _$values[r'tlsPercent'].decodeFormDouble(
        context: r'InboundTransportSecurity.tlsPercent',
      ),
      totalInboundMx: _$values[r'totalInboundMX'].decodeFormInt(
        context: r'InboundTransportSecurity.totalInboundMX',
      ),
    );
  }

  final _i3.int overTls;

  final _i3.int plaintext;

  final _i3.int plaintextAuthFail;

  final _i3.int plaintextAuthPass;

  final _i3.double plaintextPercent;

  final _i3.double tlsPercent;

  final _i3.int totalInboundMx;

  @_i3.override
  _i3.Object? toJson() => {
    r'overTLS': overTls,
    r'plaintext': plaintext,
    r'plaintextAuthFail': plaintextAuthFail,
    r'plaintextAuthPass': plaintextAuthPass,
    r'plaintextPercent': plaintextPercent,
    r'tlsPercent': tlsPercent,
    r'totalInboundMX': totalInboundMx,
  };

  $$InboundTransportSecurityCopyWith<InboundTransportSecurity> get copyWith =>
      _InboundTransportSecurityCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is InboundTransportSecurity &&
        other.overTls == this.overTls &&
        other.plaintext == this.plaintext &&
        other.plaintextAuthFail == this.plaintextAuthFail &&
        other.plaintextAuthPass == this.plaintextAuthPass &&
        other.plaintextPercent == this.plaintextPercent &&
        other.tlsPercent == this.tlsPercent &&
        other.totalInboundMx == this.totalInboundMx;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      overTls,
      plaintext,
      plaintextAuthFail,
      plaintextAuthPass,
      plaintextPercent,
      tlsPercent,
      totalInboundMx,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'overTLS'] = _i1.PropertyValue.scalar(overTls.toString());
    _$result[r'plaintext'] = _i1.PropertyValue.scalar(plaintext.toString());
    _$result[r'plaintextAuthFail'] = _i1.PropertyValue.scalar(
      plaintextAuthFail.toString(),
    );
    _$result[r'plaintextAuthPass'] = _i1.PropertyValue.scalar(
      plaintextAuthPass.toString(),
    );
    _$result[r'plaintextPercent'] = _i1.PropertyValue.scalar(
      plaintextPercent.toString(),
    );
    _$result[r'tlsPercent'] = _i1.PropertyValue.scalar(tlsPercent.toString());
    _$result[r'totalInboundMX'] = _i1.PropertyValue.scalar(
      totalInboundMx.toString(),
    );
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
      r'Cannot uriEncode InboundTransportSecurity: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$InboundTransportSecurityCopyWith<$Res> {
  factory $$InboundTransportSecurityCopyWith(InboundTransportSecurity value) =
      _InboundTransportSecurityCopyWith<$Res>;

  $Res call({
    _i3.int? overTls,
    _i3.int? plaintext,
    _i3.int? plaintextAuthFail,
    _i3.int? plaintextAuthPass,
    _i3.double? plaintextPercent,
    _i3.double? tlsPercent,
    _i3.int? totalInboundMx,
  });
  _i3.int get overTls;
  _i3.int get plaintext;
  _i3.int get plaintextAuthFail;
  _i3.int get plaintextAuthPass;
  _i3.double get plaintextPercent;
  _i3.double get tlsPercent;
  _i3.int get totalInboundMx;
}

class _InboundTransportSecurityCopyWith<$Res>
    implements $$InboundTransportSecurityCopyWith<$Res> {
  _InboundTransportSecurityCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final InboundTransportSecurity _value;

  @_i3.override
  _i3.int get overTls => _value.overTls;

  @_i3.override
  _i3.int get plaintext => _value.plaintext;

  @_i3.override
  _i3.int get plaintextAuthFail => _value.plaintextAuthFail;

  @_i3.override
  _i3.int get plaintextAuthPass => _value.plaintextAuthPass;

  @_i3.override
  _i3.double get plaintextPercent => _value.plaintextPercent;

  @_i3.override
  _i3.double get tlsPercent => _value.tlsPercent;

  @_i3.override
  _i3.int get totalInboundMx => _value.totalInboundMx;

  @_i3.override
  $Res call({
    _i3.Object? overTls = _sentinel,
    _i3.Object? plaintext = _sentinel,
    _i3.Object? plaintextAuthFail = _sentinel,
    _i3.Object? plaintextAuthPass = _sentinel,
    _i3.Object? plaintextPercent = _sentinel,
    _i3.Object? tlsPercent = _sentinel,
    _i3.Object? totalInboundMx = _sentinel,
  }) {
    return (InboundTransportSecurity(
      overTls: _i3.identical(overTls, _sentinel)
          ? this.overTls
          : (overTls as _i3.int),
      plaintext: _i3.identical(plaintext, _sentinel)
          ? this.plaintext
          : (plaintext as _i3.int),
      plaintextAuthFail: _i3.identical(plaintextAuthFail, _sentinel)
          ? this.plaintextAuthFail
          : (plaintextAuthFail as _i3.int),
      plaintextAuthPass: _i3.identical(plaintextAuthPass, _sentinel)
          ? this.plaintextAuthPass
          : (plaintextAuthPass as _i3.int),
      plaintextPercent: _i3.identical(plaintextPercent, _sentinel)
          ? this.plaintextPercent
          : (plaintextPercent as _i3.double),
      tlsPercent: _i3.identical(tlsPercent, _sentinel)
          ? this.tlsPercent
          : (tlsPercent as _i3.double),
      totalInboundMx: _i3.identical(totalInboundMx, _sentinel)
          ? this.totalInboundMx
          : (totalInboundMx as _i3.int),
    ) as $Res);
  }
}
