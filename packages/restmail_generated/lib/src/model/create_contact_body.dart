// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreateContactBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreateContactBody({required this.email, this.name, this.trustLevel});

  factory CreateContactBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'email', r'name', r'trust_level'},
      listKeys: {},
      context: r'CreateContactBody',
    );
    return CreateContactBody(
      email: _$values[r'email'].decodeSimpleString(
        context: r'CreateContactBody.email',
      ),
      name: _$values[r'name'].decodeSimpleNullableString(
        context: r'CreateContactBody.name',
      ),
      trustLevel: _$values[r'trust_level'].decodeSimpleNullableString(
        context: r'CreateContactBody.trust_level',
      ),
    );
  }

  factory CreateContactBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreateContactBody');
    return CreateContactBody(
      email: _$map[r'email'].decodeJsonString(
        context: r'CreateContactBody.email',
      ),
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'CreateContactBody.name',
      ),
      trustLevel: _$map[r'trust_level'].decodeJsonNullableString(
        context: r'CreateContactBody.trust_level',
      ),
    );
  }

  factory CreateContactBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'email', r'name', r'trust_level'},
      listKeys: {},
      context: r'CreateContactBody',
    );
    return CreateContactBody(
      email: _$values[r'email'].decodeFormString(
        context: r'CreateContactBody.email',
      ),
      name: _$values[r'name'].decodeFormNullableString(
        context: r'CreateContactBody.name',
      ),
      trustLevel: _$values[r'trust_level'].decodeFormNullableString(
        context: r'CreateContactBody.trust_level',
      ),
    );
  }

  final _i3.String email;

  final _i3.String? name;

  final _i3.String? trustLevel;

  @_i3.override
  _i3.Object? toJson() => {
    r'email': email,
    if (name != null) r'name': name,
    r'trust_level': trustLevel,
  };

  $$CreateContactBodyCopyWith<CreateContactBody> get copyWith =>
      _CreateContactBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateContactBody &&
        other.email == this.email &&
        other.name == this.name &&
        other.trustLevel == this.trustLevel;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([email, name, trustLevel]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'email'] = _i1.PropertyValue.scalar(email);
    if (name != null) {
      _$result[r'name'] = _i1.PropertyValue.scalar(name!);
    }
    if (trustLevel != null) {
      _$result[r'trust_level'] = _i1.PropertyValue.scalar(trustLevel!);
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
      r'Cannot uriEncode CreateContactBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreateContactBodyCopyWith<$Res> {
  factory $$CreateContactBodyCopyWith(CreateContactBody value) =
      _CreateContactBodyCopyWith<$Res>;

  $Res call({_i3.String? email, _i3.String? name, _i3.String? trustLevel});
  _i3.String get email;
  _i3.String? get name;
  _i3.String? get trustLevel;
}

class _CreateContactBodyCopyWith<$Res>
    implements $$CreateContactBodyCopyWith<$Res> {
  _CreateContactBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreateContactBody _value;

  @_i3.override
  _i3.String get email => _value.email;

  @_i3.override
  _i3.String? get name => _value.name;

  @_i3.override
  _i3.String? get trustLevel => _value.trustLevel;

  @_i3.override
  $Res call({
    _i3.Object? email = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? trustLevel = _sentinel,
  }) {
    return (CreateContactBody(
      email: _i3.identical(email, _sentinel)
          ? this.email
          : (email as _i3.String),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
      trustLevel: _i3.identical(trustLevel, _sentinel)
          ? this.trustLevel
          : (trustLevel as _i3.String?),
    ) as $Res);
  }
}
