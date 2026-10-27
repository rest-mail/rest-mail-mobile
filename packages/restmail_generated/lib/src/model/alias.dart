// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/alias_domain_one_of_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Alias extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Alias({
    required this.active,
    required this.createdAt,
    required this.destinationAddress,
    required this.domainId,
    required this.id,
    required this.sourceAddress,
    this.domain,
  });

  factory Alias.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for Alias: contains complex types',
    );
  }

  factory Alias.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Alias');
    return Alias(
      active: _$map[r'active'].decodeJsonBool(context: r'Alias.active'),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'Alias.created_at',
      ),
      destinationAddress: _$map[r'destination_address'].decodeJsonString(
        context: r'Alias.destination_address',
      ),
      domain: _$map[r'domain'] == null
          ? null
          : _i4.AliasDomainOneOfModel.fromJson(_$map[r'domain']),
      domainId: _$map[r'domain_id'].decodeJsonInt(context: r'Alias.domain_id'),
      id: _$map[r'id'].decodeJsonInt(context: r'Alias.id'),
      sourceAddress: _$map[r'source_address'].decodeJsonString(
        context: r'Alias.source_address',
      ),
    );
  }

  factory Alias.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for Alias: contains complex types',
    );
  }

  final _i3.bool active;

  final _i3.DateTime createdAt;

  final _i3.String destinationAddress;

  final _i4.AliasDomainOneOfModel? domain;

  final _i3.int domainId;

  final _i3.int id;

  final _i3.String sourceAddress;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'destination_address': destinationAddress,
    if (domain != null) r'domain': domain?.toJson(),
    r'domain_id': domainId,
    r'id': id,
    r'source_address': sourceAddress,
  };

  $$AliasCopyWith<Alias> get copyWith => _AliasCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Alias &&
        other.active == this.active &&
        other.createdAt == this.createdAt &&
        other.destinationAddress == this.destinationAddress &&
        other.domain == this.domain &&
        other.domainId == this.domainId &&
        other.id == this.id &&
        other.sourceAddress == this.sourceAddress;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      active,
      createdAt,
      destinationAddress,
      domain,
      domainId,
      id,
      sourceAddress,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for Alias: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode Alias: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AliasCopyWith<$Res> {
  factory $$AliasCopyWith(Alias value) = _AliasCopyWith<$Res>;

  $Res call({
    _i3.bool? active,
    _i3.DateTime? createdAt,
    _i3.String? destinationAddress,
    _i4.AliasDomainOneOfModel? domain,
    _i3.int? domainId,
    _i3.int? id,
    _i3.String? sourceAddress,
  });
  _i3.bool get active;
  _i3.DateTime get createdAt;
  _i3.String get destinationAddress;
  _i4.AliasDomainOneOfModel? get domain;
  _i3.int get domainId;
  _i3.int get id;
  _i3.String get sourceAddress;
}

class _AliasCopyWith<$Res> implements $$AliasCopyWith<$Res> {
  _AliasCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Alias _value;

  @_i3.override
  _i3.bool get active => _value.active;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.String get destinationAddress => _value.destinationAddress;

  @_i3.override
  _i4.AliasDomainOneOfModel? get domain => _value.domain;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get sourceAddress => _value.sourceAddress;

  @_i3.override
  $Res call({
    _i3.Object? active = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? destinationAddress = _sentinel,
    _i3.Object? domain = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? sourceAddress = _sentinel,
  }) {
    return (Alias(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      destinationAddress: _i3.identical(destinationAddress, _sentinel)
          ? this.destinationAddress
          : (destinationAddress as _i3.String),
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i4.AliasDomainOneOfModel?),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      sourceAddress: _i3.identical(sourceAddress, _sentinel)
          ? this.sourceAddress
          : (sourceAddress as _i3.String),
    ) as $Res);
  }
}
