// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Envelope extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const Envelope({
    required this.direction,
    required this.mailFrom,
    required this.rcptTo,
    required this.tls,
    this.clientHostname,
    this.clientIp,
    this.helo,
  });

  factory Envelope.fromSimple(_i3.String? value, {required _i3.bool explode}) {
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
      context: r'Envelope',
    );
    return Envelope(
      clientHostname: _$values[r'client_hostname'].decodeSimpleNullableString(
        context: r'Envelope.client_hostname',
      ),
      clientIp: _$values[r'client_ip'].decodeSimpleNullableString(
        context: r'Envelope.client_ip',
      ),
      direction: _$values[r'direction'].decodeSimpleString(
        context: r'Envelope.direction',
      ),
      helo: _$values[r'helo'].decodeSimpleNullableString(
        context: r'Envelope.helo',
      ),
      mailFrom: _$values[r'mail_from'].decodeSimpleString(
        context: r'Envelope.mail_from',
      ),
      rcptTo: _$values[r'rcpt_to'].decodeSimpleStringList(
        context: r'Envelope.rcpt_to',
      ),
      tls: _$values[r'tls'].decodeSimpleBool(context: r'Envelope.tls'),
    );
  }

  factory Envelope.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Envelope');
    return Envelope(
      clientHostname: _$map[r'client_hostname'].decodeJsonNullableString(
        context: r'Envelope.client_hostname',
      ),
      clientIp: _$map[r'client_ip'].decodeJsonNullableString(
        context: r'Envelope.client_ip',
      ),
      direction: _$map[r'direction'].decodeJsonString(
        context: r'Envelope.direction',
      ),
      helo: _$map[r'helo'].decodeJsonNullableString(context: r'Envelope.helo'),
      mailFrom: _$map[r'mail_from'].decodeJsonString(
        context: r'Envelope.mail_from',
      ),
      rcptTo: _$map[r'rcpt_to'].decodeJsonList<_i3.String>(
        context: r'Envelope.rcpt_to',
      ),
      tls: _$map[r'tls'].decodeJsonBool(context: r'Envelope.tls'),
    );
  }

  factory Envelope.fromForm(_i3.String? value, {required _i3.bool explode}) {
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
      context: r'Envelope',
    );
    return Envelope(
      clientHostname: _$values[r'client_hostname'].decodeFormNullableString(
        context: r'Envelope.client_hostname',
      ),
      clientIp: _$values[r'client_ip'].decodeFormNullableString(
        context: r'Envelope.client_ip',
      ),
      direction: _$values[r'direction'].decodeFormString(
        context: r'Envelope.direction',
      ),
      helo: _$values[r'helo'].decodeFormNullableString(
        context: r'Envelope.helo',
      ),
      mailFrom: _$values[r'mail_from'].decodeFormString(
        context: r'Envelope.mail_from',
      ),
      rcptTo: _$values[r'rcpt_to'].decodeFormStringList(
        context: r'Envelope.rcpt_to',
      ),
      tls: _$values[r'tls'].decodeFormBool(context: r'Envelope.tls'),
    );
  }

  final _i3.String? clientHostname;

  final _i3.String? clientIp;

  final _i3.String direction;

  final _i3.String? helo;

  final _i3.String mailFrom;

  final _i3.List<_i3.String> rcptTo;

  final _i3.bool tls;

  @_i3.override
  _i3.Object? toJson() => {
    if (clientHostname != null) r'client_hostname': clientHostname,
    if (clientIp != null) r'client_ip': clientIp,
    r'direction': direction,
    if (helo != null) r'helo': helo,
    r'mail_from': mailFrom,
    r'rcpt_to': rcptTo,
    r'tls': tls,
  };

  $$EnvelopeCopyWith<Envelope> get copyWith => _EnvelopeCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is Envelope &&
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
    _$result[r'direction'] = _i1.PropertyValue.scalar(direction);
    if (helo != null) {
      _$result[r'helo'] = _i1.PropertyValue.scalar(helo!);
    }
    _$result[r'mail_from'] = _i1.PropertyValue.scalar(mailFrom);
    _$result[r'rcpt_to'] = _i1.PropertyValue.array(rcptTo);
    _$result[r'tls'] = _i1.PropertyValue.scalar(tls.toString());
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
      r'Cannot uriEncode Envelope: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$EnvelopeCopyWith<$Res> {
  factory $$EnvelopeCopyWith(Envelope value) = _EnvelopeCopyWith<$Res>;

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
  _i3.String get direction;
  _i3.String? get helo;
  _i3.String get mailFrom;
  _i3.List<_i3.String> get rcptTo;
  _i3.bool get tls;
}

class _EnvelopeCopyWith<$Res> implements $$EnvelopeCopyWith<$Res> {
  _EnvelopeCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Envelope _value;

  @_i3.override
  _i3.String? get clientHostname => _value.clientHostname;

  @_i3.override
  _i3.String? get clientIp => _value.clientIp;

  @_i3.override
  _i3.String get direction => _value.direction;

  @_i3.override
  _i3.String? get helo => _value.helo;

  @_i3.override
  _i3.String get mailFrom => _value.mailFrom;

  @_i3.override
  _i3.List<_i3.String> get rcptTo => _value.rcptTo;

  @_i3.override
  _i3.bool get tls => _value.tls;

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
    return (Envelope(
      clientHostname: _i3.identical(clientHostname, _sentinel)
          ? this.clientHostname
          : (clientHostname as _i3.String?),
      clientIp: _i3.identical(clientIp, _sentinel)
          ? this.clientIp
          : (clientIp as _i3.String?),
      direction: _i3.identical(direction, _sentinel)
          ? this.direction
          : (direction as _i3.String),
      helo: _i3.identical(helo, _sentinel) ? this.helo : (helo as _i3.String?),
      mailFrom: _i3.identical(mailFrom, _sentinel)
          ? this.mailFrom
          : (mailFrom as _i3.String),
      rcptTo: _i3.identical(rcptTo, _sentinel)
          ? this.rcptTo
          : (rcptTo as _i3.List<_i3.String>),
      tls: _i3.identical(tls, _sentinel) ? this.tls : (tls as _i3.bool),
    ) as $Res);
  }
}
