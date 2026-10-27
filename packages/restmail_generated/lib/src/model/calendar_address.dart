// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CalendarAddress extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CalendarAddress({
    required this.address,
    this.name,
    this.partstat,
    this.role,
    this.rsvp,
  });

  factory CalendarAddress.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'address', r'name', r'partstat', r'role', r'rsvp'},
      listKeys: {},
      context: r'CalendarAddress',
    );
    return CalendarAddress(
      address: _$values[r'address'].decodeSimpleString(
        context: r'CalendarAddress.address',
      ),
      name: _$values[r'name'].decodeSimpleNullableString(
        context: r'CalendarAddress.name',
      ),
      partstat: _$values[r'partstat'].decodeSimpleNullableString(
        context: r'CalendarAddress.partstat',
      ),
      role: _$values[r'role'].decodeSimpleNullableString(
        context: r'CalendarAddress.role',
      ),
      rsvp: _$values[r'rsvp'].decodeSimpleNullableBool(
        context: r'CalendarAddress.rsvp',
      ),
    );
  }

  factory CalendarAddress.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CalendarAddress');
    return CalendarAddress(
      address: _$map[r'address'].decodeJsonString(
        context: r'CalendarAddress.address',
      ),
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'CalendarAddress.name',
      ),
      partstat: _$map[r'partstat'].decodeJsonNullableString(
        context: r'CalendarAddress.partstat',
      ),
      role: _$map[r'role'].decodeJsonNullableString(
        context: r'CalendarAddress.role',
      ),
      rsvp: _$map[r'rsvp'].decodeJsonNullableBool(
        context: r'CalendarAddress.rsvp',
      ),
    );
  }

  factory CalendarAddress.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'address', r'name', r'partstat', r'role', r'rsvp'},
      listKeys: {},
      context: r'CalendarAddress',
    );
    return CalendarAddress(
      address: _$values[r'address'].decodeFormString(
        context: r'CalendarAddress.address',
      ),
      name: _$values[r'name'].decodeFormNullableString(
        context: r'CalendarAddress.name',
      ),
      partstat: _$values[r'partstat'].decodeFormNullableString(
        context: r'CalendarAddress.partstat',
      ),
      role: _$values[r'role'].decodeFormNullableString(
        context: r'CalendarAddress.role',
      ),
      rsvp: _$values[r'rsvp'].decodeFormNullableBool(
        context: r'CalendarAddress.rsvp',
      ),
    );
  }

  final _i3.String address;

  final _i3.String? name;

  final _i3.String? partstat;

  final _i3.String? role;

  final _i3.bool? rsvp;

  @_i3.override
  _i3.Object? toJson() => {
    r'address': address,
    if (name != null) r'name': name,
    if (partstat != null) r'partstat': partstat,
    if (role != null) r'role': role,
    if (rsvp != null) r'rsvp': rsvp,
  };

  $$CalendarAddressCopyWith<CalendarAddress> get copyWith =>
      _CalendarAddressCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CalendarAddress &&
        other.address == this.address &&
        other.name == this.name &&
        other.partstat == this.partstat &&
        other.role == this.role &&
        other.rsvp == this.rsvp;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([address, name, partstat, role, rsvp]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'address'] = _i1.PropertyValue.scalar(address);
    if (name != null) {
      _$result[r'name'] = _i1.PropertyValue.scalar(name!);
    }
    if (partstat != null) {
      _$result[r'partstat'] = _i1.PropertyValue.scalar(partstat!);
    }
    if (role != null) {
      _$result[r'role'] = _i1.PropertyValue.scalar(role!);
    }
    if (rsvp != null) {
      _$result[r'rsvp'] = _i1.PropertyValue.scalar(rsvp!.toString());
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
      r'Cannot uriEncode CalendarAddress: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CalendarAddressCopyWith<$Res> {
  factory $$CalendarAddressCopyWith(CalendarAddress value) =
      _CalendarAddressCopyWith<$Res>;

  $Res call({
    _i3.String? address,
    _i3.String? name,
    _i3.String? partstat,
    _i3.String? role,
    _i3.bool? rsvp,
  });
  _i3.String get address;
  _i3.String? get name;
  _i3.String? get partstat;
  _i3.String? get role;
  _i3.bool? get rsvp;
}

class _CalendarAddressCopyWith<$Res>
    implements $$CalendarAddressCopyWith<$Res> {
  _CalendarAddressCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CalendarAddress _value;

  @_i3.override
  _i3.String get address => _value.address;

  @_i3.override
  _i3.String? get name => _value.name;

  @_i3.override
  _i3.String? get partstat => _value.partstat;

  @_i3.override
  _i3.String? get role => _value.role;

  @_i3.override
  _i3.bool? get rsvp => _value.rsvp;

  @_i3.override
  $Res call({
    _i3.Object? address = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? partstat = _sentinel,
    _i3.Object? role = _sentinel,
    _i3.Object? rsvp = _sentinel,
  }) {
    return (CalendarAddress(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
      partstat: _i3.identical(partstat, _sentinel)
          ? this.partstat
          : (partstat as _i3.String?),
      role: _i3.identical(role, _sentinel) ? this.role : (role as _i3.String?),
      rsvp: _i3.identical(rsvp, _sentinel) ? this.rsvp : (rsvp as _i3.bool?),
    ) as $Res);
  }
}
