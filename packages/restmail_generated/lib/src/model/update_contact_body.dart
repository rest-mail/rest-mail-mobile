// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/update_contact_body_trust_level_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UpdateContactBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UpdateContactBody({this.name, this.trustLevel});

  factory UpdateContactBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'name', r'trust_level'},
      listKeys: {},
      context: r'UpdateContactBody',
    );
    return UpdateContactBody(
      name: _$values[r'name'].decodeSimpleNullableString(
        context: r'UpdateContactBody.name',
      ),
      trustLevel: _$values[r'trust_level'] == null
          ? null
          : _i4.UpdateContactBodyTrustLevelModel.fromSimple(
              _$values[r'trust_level'],
              explode: explode,
            ),
    );
  }

  factory UpdateContactBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UpdateContactBody');
    return UpdateContactBody(
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'UpdateContactBody.name',
      ),
      trustLevel: _$map[r'trust_level'] == null
          ? null
          : _i4.UpdateContactBodyTrustLevelModel.fromJson(
              _$map[r'trust_level'],
            ),
    );
  }

  factory UpdateContactBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'name', r'trust_level'},
      listKeys: {},
      context: r'UpdateContactBody',
    );
    return UpdateContactBody(
      name: _$values[r'name'].decodeFormNullableString(
        context: r'UpdateContactBody.name',
      ),
      trustLevel: _$values[r'trust_level'] == null
          ? null
          : _i4.UpdateContactBodyTrustLevelModel.fromForm(
              _$values[r'trust_level'],
              explode: explode,
            ),
    );
  }

  final _i3.String? name;

  final _i4.UpdateContactBodyTrustLevelModel? trustLevel;

  @_i3.override
  _i3.Object? toJson() => {r'name': name, r'trust_level': trustLevel?.toJson()};

  $$UpdateContactBodyCopyWith<UpdateContactBody> get copyWith =>
      _UpdateContactBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateContactBody &&
        other.name == this.name &&
        other.trustLevel == this.trustLevel;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([name, trustLevel]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (name != null) {
      _$result[r'name'] = _i1.PropertyValue.scalar(name!);
    }
    if (trustLevel != null) {
      _$result[r'trust_level'] = _i1.PropertyValue.scalar(trustLevel!.toJson());
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
      r'Cannot uriEncode UpdateContactBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UpdateContactBodyCopyWith<$Res> {
  factory $$UpdateContactBodyCopyWith(UpdateContactBody value) =
      _UpdateContactBodyCopyWith<$Res>;

  $Res call({
    _i3.String? name,
    _i4.UpdateContactBodyTrustLevelModel? trustLevel,
  });
  _i3.String? get name;
  _i4.UpdateContactBodyTrustLevelModel? get trustLevel;
}

class _UpdateContactBodyCopyWith<$Res>
    implements $$UpdateContactBodyCopyWith<$Res> {
  _UpdateContactBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UpdateContactBody _value;

  @_i3.override
  _i3.String? get name => _value.name;

  @_i3.override
  _i4.UpdateContactBodyTrustLevelModel? get trustLevel => _value.trustLevel;

  @_i3.override
  $Res call({
    _i3.Object? name = _sentinel,
    _i3.Object? trustLevel = _sentinel,
  }) {
    return (UpdateContactBody(
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
      trustLevel: _i3.identical(trustLevel, _sentinel)
          ? this.trustLevel
          : (trustLevel as _i4.UpdateContactBodyTrustLevelModel?),
    ) as $Res);
  }
}
