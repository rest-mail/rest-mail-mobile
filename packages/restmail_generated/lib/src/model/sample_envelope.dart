// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SampleEnvelope extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SampleEnvelope({
    this.clientHostname,
    this.clientIp,
    this.direction,
    this.helo,
    this.mailFrom,
    this.rcptTo,
    this.tls,
  });

  factory SampleEnvelope.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'client_hostname',
        r'client_ip',
        r'direction',
        r'helo',
        r'mail_from',
        r'rcpt_to',
        r'tls',
      },
      listKeys: {r'rcpt_to'},
      context: r'SampleEnvelope',
    );
    return SampleEnvelope(
      clientHostname: _$values[r'client_hostname'].decodeSimpleNullableString(
        context: r'SampleEnvelope.client_hostname',
      ),
      clientIp: _$values[r'client_ip'].decodeSimpleNullableString(
        context: r'SampleEnvelope.client_ip',
      ),
      direction: _$values[r'direction'].decodeSimpleNullableString(
        context: r'SampleEnvelope.direction',
      ),
      helo: _$values[r'helo'].decodeSimpleNullableString(
        context: r'SampleEnvelope.helo',
      ),
      mailFrom: _$values[r'mail_from'].decodeSimpleNullableString(
        context: r'SampleEnvelope.mail_from',
      ),
      rcptTo: _$values[r'rcpt_to'].decodeSimpleNullableStringList(
        context: r'SampleEnvelope.rcpt_to',
      ),
      tls: _$values[r'tls'].decodeSimpleNullableBool(
        context: r'SampleEnvelope.tls',
      ),
    );
  }

  factory SampleEnvelope.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SampleEnvelope');
    return SampleEnvelope(
      clientHostname: _$map[r'client_hostname'].decodeJsonNullableString(
        context: r'SampleEnvelope.client_hostname',
      ),
      clientIp: _$map[r'client_ip'].decodeJsonNullableString(
        context: r'SampleEnvelope.client_ip',
      ),
      direction: _$map[r'direction'].decodeJsonNullableString(
        context: r'SampleEnvelope.direction',
      ),
      helo: _$map[r'helo'].decodeJsonNullableString(
        context: r'SampleEnvelope.helo',
      ),
      mailFrom: _$map[r'mail_from'].decodeJsonNullableString(
        context: r'SampleEnvelope.mail_from',
      ),
      rcptTo: _$map[r'rcpt_to'].decodeJsonNullableList<_i3.String>(
        context: r'SampleEnvelope.rcpt_to',
      ),
      tls: _$map[r'tls'].decodeJsonNullableBool(context: r'SampleEnvelope.tls'),
    );
  }

  factory SampleEnvelope.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'client_hostname',
        r'client_ip',
        r'direction',
        r'helo',
        r'mail_from',
        r'rcpt_to',
        r'tls',
      },
      listKeys: {r'rcpt_to'},
      context: r'SampleEnvelope',
    );
    return SampleEnvelope(
      clientHostname: _$values[r'client_hostname'].decodeFormNullableString(
        context: r'SampleEnvelope.client_hostname',
      ),
      clientIp: _$values[r'client_ip'].decodeFormNullableString(
        context: r'SampleEnvelope.client_ip',
      ),
      direction: _$values[r'direction'].decodeFormNullableString(
        context: r'SampleEnvelope.direction',
      ),
      helo: _$values[r'helo'].decodeFormNullableString(
        context: r'SampleEnvelope.helo',
      ),
      mailFrom: _$values[r'mail_from'].decodeFormNullableString(
        context: r'SampleEnvelope.mail_from',
      ),
      rcptTo: _$values[r'rcpt_to'].decodeFormNullableStringList(
        context: r'SampleEnvelope.rcpt_to',
      ),
      tls: _$values[r'tls'].decodeFormNullableBool(
        context: r'SampleEnvelope.tls',
      ),
    );
  }

  final _i3.String? clientHostname;

  final _i3.String? clientIp;

  final _i3.String? direction;

  final _i3.String? helo;

  final _i3.String? mailFrom;

  final _i3.List<_i3.String>? rcptTo;

  final _i3.bool? tls;

  @_i3.override
  _i3.Object? toJson() => {
    r'client_hostname': clientHostname,
    r'client_ip': clientIp,
    r'direction': direction,
    r'helo': helo,
    r'mail_from': mailFrom,
    r'rcpt_to': rcptTo,
    r'tls': tls,
  };

  $$SampleEnvelopeCopyWith<SampleEnvelope> get copyWith =>
      _SampleEnvelopeCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is SampleEnvelope &&
        other.clientHostname == this.clientHostname &&
        other.clientIp == this.clientIp &&
        other.direction == this.direction &&
        other.helo == this.helo &&
        other.mailFrom == this.mailFrom &&
        _$deepEquals.equals(other.rcptTo, this.rcptTo) &&
        other.tls == this.tls;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      clientHostname,
      clientIp,
      direction,
      helo,
      mailFrom,
      deepEquals.hash(rcptTo),
      tls,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (clientHostname != null) {
      _$result[r'client_hostname'] = _i1.PropertyValue.scalar(clientHostname!);
    }
    if (clientIp != null) {
      _$result[r'client_ip'] = _i1.PropertyValue.scalar(clientIp!);
    }
    if (direction != null) {
      _$result[r'direction'] = _i1.PropertyValue.scalar(direction!);
    }
    if (helo != null) {
      _$result[r'helo'] = _i1.PropertyValue.scalar(helo!);
    }
    if (mailFrom != null) {
      _$result[r'mail_from'] = _i1.PropertyValue.scalar(mailFrom!);
    }
    if (rcptTo != null) {
      _$result[r'rcpt_to'] = _i1.PropertyValue.array(rcptTo!);
    }
    if (tls != null) {
      _$result[r'tls'] = _i1.PropertyValue.scalar(tls!.toString());
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
      r'Cannot uriEncode SampleEnvelope: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SampleEnvelopeCopyWith<$Res> {
  factory $$SampleEnvelopeCopyWith(SampleEnvelope value) =
      _SampleEnvelopeCopyWith<$Res>;

  $Res call({
    _i3.String? clientHostname,
    _i3.String? clientIp,
    _i3.String? direction,
    _i3.String? helo,
    _i3.String? mailFrom,
    _i3.List<_i3.String>? rcptTo,
    _i3.bool? tls,
  });
  _i3.String? get clientHostname;
  _i3.String? get clientIp;
  _i3.String? get direction;
  _i3.String? get helo;
  _i3.String? get mailFrom;
  _i3.List<_i3.String>? get rcptTo;
  _i3.bool? get tls;
}

class _SampleEnvelopeCopyWith<$Res> implements $$SampleEnvelopeCopyWith<$Res> {
  _SampleEnvelopeCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SampleEnvelope _value;

  @_i3.override
  _i3.String? get clientHostname => _value.clientHostname;

  @_i3.override
  _i3.String? get clientIp => _value.clientIp;

  @_i3.override
  _i3.String? get direction => _value.direction;

  @_i3.override
  _i3.String? get helo => _value.helo;

  @_i3.override
  _i3.String? get mailFrom => _value.mailFrom;

  @_i3.override
  _i3.List<_i3.String>? get rcptTo => _value.rcptTo;

  @_i3.override
  _i3.bool? get tls => _value.tls;

  @_i3.override
  $Res call({
    _i3.Object? clientHostname = _sentinel,
    _i3.Object? clientIp = _sentinel,
    _i3.Object? direction = _sentinel,
    _i3.Object? helo = _sentinel,
    _i3.Object? mailFrom = _sentinel,
    _i3.Object? rcptTo = _sentinel,
    _i3.Object? tls = _sentinel,
  }) {
    return (SampleEnvelope(
      clientHostname: _i3.identical(clientHostname, _sentinel)
          ? this.clientHostname
          : (clientHostname as _i3.String?),
      clientIp: _i3.identical(clientIp, _sentinel)
          ? this.clientIp
          : (clientIp as _i3.String?),
      direction: _i3.identical(direction, _sentinel)
          ? this.direction
          : (direction as _i3.String?),
      helo: _i3.identical(helo, _sentinel) ? this.helo : (helo as _i3.String?),
      mailFrom: _i3.identical(mailFrom, _sentinel)
          ? this.mailFrom
          : (mailFrom as _i3.String?),
      rcptTo: _i3.identical(rcptTo, _sentinel)
          ? this.rcptTo
          : (rcptTo as _i3.List<_i3.String>?),
      tls: _i3.identical(tls, _sentinel) ? this.tls : (tls as _i3.bool?),
    ) as $Res);
  }
}
