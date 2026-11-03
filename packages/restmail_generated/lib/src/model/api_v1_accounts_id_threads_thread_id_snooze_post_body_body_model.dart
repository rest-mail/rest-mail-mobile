// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel({
    required this.snoozedUntil,
  });

  factory ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'snoozed_until'},
      listKeys: {},
      context: r'ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel',
    );
    return ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel(
      snoozedUntil: _$values[r'snoozed_until'].decodeSimpleNullableDateTime(
        context: r'ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel.snoozed_until',
      ),
    );
  }

  factory ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel',
    );
    return ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel(
      snoozedUntil: _$map[r'snoozed_until'].decodeJsonNullableDateTime(
        context: r'ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel.snoozed_until',
      ),
    );
  }

  factory ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'snoozed_until'},
      listKeys: {},
      context: r'ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel',
    );
    return ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel(
      snoozedUntil: _$values[r'snoozed_until'].decodeFormNullableDateTime(
        context: r'ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel.snoozed_until',
      ),
    );
  }

  final _i3.DateTime? snoozedUntil;

  @_i3.override
  _i3.Object? toJson() => {
    r'snoozed_until': snoozedUntil?.toTimeZonedIso8601String(),
  };

  $$ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModelCopyWith<
    ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel
  >
  get copyWith =>
      _ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModelCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel &&
        other.snoozedUntil == this.snoozedUntil;
  }

  @_i3.override
  _i3.int get hashCode => snoozedUntil.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (snoozedUntil != null) {
      _$result[r'snoozed_until'] = _i1.PropertyValue.scalar(
        snoozedUntil!.toTimeZonedIso8601String(),
      );
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
      r'Cannot uriEncode ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModelCopyWith<
  $Res
> {
  factory $$ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModelCopyWith(
    ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel value,
  ) = _ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModelCopyWith<$Res>;

  $Res call({_i3.DateTime? snoozedUntil});
  _i3.DateTime? get snoozedUntil;
}

class _ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModelCopyWith<$Res>
    implements
        $$ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModelCopyWith<$Res> {
  _ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModelCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel _value;

  @_i3.override
  _i3.DateTime? get snoozedUntil => _value.snoozedUntil;

  @_i3.override
  $Res call({_i3.Object? snoozedUntil = _sentinel}) {
    return (ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel(
      snoozedUntil: _i3.identical(snoozedUntil, _sentinel)
          ? this.snoozedUntil
          : (snoozedUntil as _i3.DateTime?),
    ) as $Res);
  }
}
