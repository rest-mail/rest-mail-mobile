// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/cert_warning.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Health extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Health({required this.db, required this.status, this.certWarnings});

  factory Health.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for Health: contains complex types',
    );
  }

  factory Health.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Health');
    return Health(
      certWarnings: _$map[r'cert_warnings']
          .decodeJsonNullableList<_i3.Object?>(context: r'Health.cert_warnings')
          ?.map(_i4.CertWarning.fromJson)
          .toList(),
      db: _$map[r'db'].decodeJsonString(context: r'Health.db'),
      status: _$map[r'status'].decodeJsonString(context: r'Health.status'),
    );
  }

  factory Health.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for Health: contains complex types',
    );
  }

  final _i3.List<_i4.CertWarning>? certWarnings;

  final _i3.String db;

  final _i3.String status;

  @_i3.override
  _i3.Object? toJson() => {
    if (certWarnings != null)
      r'cert_warnings': certWarnings?.map((e) => e.toJson()).toList(),
    r'db': db,
    r'status': status,
  };

  $$HealthCopyWith<Health> get copyWith => _HealthCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is Health &&
        _$deepEquals.equals(other.certWarnings, this.certWarnings) &&
        other.db == this.db &&
        other.status == this.status;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([deepEquals.hash(certWarnings), db, status]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for Health: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode Health: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$HealthCopyWith<$Res> {
  factory $$HealthCopyWith(Health value) = _HealthCopyWith<$Res>;

  $Res call({
    _i3.List<_i4.CertWarning>? certWarnings,
    _i3.String? db,
    _i3.String? status,
  });
  _i3.List<_i4.CertWarning>? get certWarnings;
  _i3.String get db;
  _i3.String get status;
}

class _HealthCopyWith<$Res> implements $$HealthCopyWith<$Res> {
  _HealthCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Health _value;

  @_i3.override
  _i3.List<_i4.CertWarning>? get certWarnings => _value.certWarnings;

  @_i3.override
  _i3.String get db => _value.db;

  @_i3.override
  _i3.String get status => _value.status;

  @_i3.override
  $Res call({
    _i3.Object? certWarnings = _sentinel,
    _i3.Object? db = _sentinel,
    _i3.Object? status = _sentinel,
  }) {
    return (Health(
      certWarnings: _i3.identical(certWarnings, _sentinel)
          ? this.certWarnings
          : (certWarnings as _i3.List<_i4.CertWarning>?),
      db: _i3.identical(db, _sentinel) ? this.db : (db as _i3.String),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i3.String),
    ) as $Res);
  }
}
