// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/api_v1_accounts_id_threads_thread_id_due_post_body_body_due_source_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel({
    required this.due,
    required this.dueSource,
  });

  factory ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'due', r'due_source'},
      listKeys: {},
      context: r'ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel',
    );
    return ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel(
      due: _$values[r'due'].decodeSimpleNullableDateTime(
        context: r'ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel.due',
      ),
      dueSource:
          _i4.ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyDueSourceModel.fromSimple(
            _$values[r'due_source'],
            explode: explode,
          ),
    );
  }

  factory ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel',
    );
    return ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel(
      due: _$map[r'due'].decodeJsonNullableDateTime(
        context: r'ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel.due',
      ),
      dueSource:
          _i4.ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyDueSourceModel.fromJson(
            _$map[r'due_source'],
          ),
    );
  }

  factory ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'due', r'due_source'},
      listKeys: {},
      context: r'ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel',
    );
    return ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel(
      due: _$values[r'due'].decodeFormNullableDateTime(
        context: r'ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel.due',
      ),
      dueSource:
          _i4.ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyDueSourceModel.fromForm(
            _$values[r'due_source'],
            explode: explode,
          ),
    );
  }

  final _i3.DateTime? due;

  final _i4.ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyDueSourceModel
  dueSource;

  @_i3.override
  _i3.Object? toJson() => {
    r'due': due?.toTimeZonedIso8601String(),
    r'due_source': dueSource.toJson(),
  };

  $$ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModelCopyWith<
    ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel
  >
  get copyWith =>
      _ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModelCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel &&
        other.due == this.due &&
        other.dueSource == this.dueSource;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([due, dueSource]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (due != null) {
      _$result[r'due'] = _i1.PropertyValue.scalar(
        due!.toTimeZonedIso8601String(),
      );
    }
    _$result[r'due_source'] = _i1.PropertyValue.scalar(dueSource.toJson());
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
      r'Cannot uriEncode ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModelCopyWith<
  $Res
> {
  factory $$ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModelCopyWith(
    ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel value,
  ) = _ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModelCopyWith<$Res>;

  $Res call({
    _i3.DateTime? due,
    _i4.ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyDueSourceModel? dueSource,
  });
  _i3.DateTime? get due;
  _i4.ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyDueSourceModel get dueSource;
}

class _ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModelCopyWith<$Res>
    implements
        $$ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModelCopyWith<$Res> {
  _ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModelCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel _value;

  @_i3.override
  _i3.DateTime? get due => _value.due;

  @_i3.override
  _i4.ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyDueSourceModel
  get dueSource => _value.dueSource;

  @_i3.override
  $Res call({_i3.Object? due = _sentinel, _i3.Object? dueSource = _sentinel}) {
    return (ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel(
      due: _i3.identical(due, _sentinel) ? this.due : (due as _i3.DateTime?),
      dueSource: _i3.identical(dueSource, _sentinel)
          ? this.dueSource
          : (dueSource
                as _i4.ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyDueSourceModel),
    ) as $Res);
  }
}
