// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/filter_log.dart' as _i4;
import 'package:restmail_generated/src/model/filter_result_message_one_of_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FilterResult extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FilterResult({
    required this.action,
    required this.log,
    required this.$type,
    this.message,
    this.rejectMessage,
    this.skipFilters,
  });

  factory FilterResult.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FilterResult: contains complex types',
    );
  }

  factory FilterResult.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'FilterResult');
    return FilterResult(
      action: _$map[r'action'].decodeJsonString(
        context: r'FilterResult.action',
      ),
      log: _i4.FilterLog.fromJson(_$map[r'log']),
      message: _$map[r'message'] == null
          ? null
          : _i5.FilterResultMessageOneOfModel.fromJson(_$map[r'message']),
      rejectMessage: _$map[r'reject_message'].decodeJsonNullableString(
        context: r'FilterResult.reject_message',
      ),
      skipFilters: _$map[r'skip_filters'].decodeJsonNullableList<_i3.String>(
        context: r'FilterResult.skip_filters',
      ),
      $type: _$map[r'type'].decodeJsonString(context: r'FilterResult.type'),
    );
  }

  factory FilterResult.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FilterResult: contains complex types',
    );
  }

  final _i3.String action;

  final _i4.FilterLog log;

  final _i5.FilterResultMessageOneOfModel? message;

  final _i3.String? rejectMessage;

  final _i3.List<_i3.String>? skipFilters;

  final _i3.String $type;

  @_i3.override
  _i3.Object? toJson() => {
    r'action': action,
    r'log': log.toJson(),
    if (message != null) r'message': message?.toJson(),
    if (rejectMessage != null) r'reject_message': rejectMessage,
    if (skipFilters != null) r'skip_filters': skipFilters,
    r'type': $type,
  };

  $$FilterResultCopyWith<FilterResult> get copyWith =>
      _FilterResultCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is FilterResult &&
        other.action == this.action &&
        other.log == this.log &&
        other.message == this.message &&
        other.rejectMessage == this.rejectMessage &&
        _$deepEquals.equals(other.skipFilters, this.skipFilters) &&
        other.$type == this.$type;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      action,
      log,
      message,
      rejectMessage,
      deepEquals.hash(skipFilters),
      $type,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FilterResult: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FilterResult: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$FilterResultCopyWith<$Res> {
  factory $$FilterResultCopyWith(FilterResult value) =
      _FilterResultCopyWith<$Res>;

  $Res call({
    _i3.String? action,
    _i4.FilterLog? log,
    _i5.FilterResultMessageOneOfModel? message,
    _i3.String? rejectMessage,
    _i3.List<_i3.String>? skipFilters,
    _i3.String? $type,
  });
  _i3.String get action;
  _i4.FilterLog get log;
  _i5.FilterResultMessageOneOfModel? get message;
  _i3.String? get rejectMessage;
  _i3.List<_i3.String>? get skipFilters;
  _i3.String get $type;
}

class _FilterResultCopyWith<$Res> implements $$FilterResultCopyWith<$Res> {
  _FilterResultCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final FilterResult _value;

  @_i3.override
  _i3.String get action => _value.action;

  @_i3.override
  _i4.FilterLog get log => _value.log;

  @_i3.override
  _i5.FilterResultMessageOneOfModel? get message => _value.message;

  @_i3.override
  _i3.String? get rejectMessage => _value.rejectMessage;

  @_i3.override
  _i3.List<_i3.String>? get skipFilters => _value.skipFilters;

  @_i3.override
  _i3.String get $type => _value.$type;

  @_i3.override
  $Res call({
    _i3.Object? action = _sentinel,
    _i3.Object? log = _sentinel,
    _i3.Object? message = _sentinel,
    _i3.Object? rejectMessage = _sentinel,
    _i3.Object? skipFilters = _sentinel,
    _i3.Object? $type = _sentinel,
  }) {
    return (FilterResult(
      action: _i3.identical(action, _sentinel)
          ? this.action
          : (action as _i3.String),
      log: _i3.identical(log, _sentinel) ? this.log : (log as _i4.FilterLog),
      message: _i3.identical(message, _sentinel)
          ? this.message
          : (message as _i5.FilterResultMessageOneOfModel?),
      rejectMessage: _i3.identical(rejectMessage, _sentinel)
          ? this.rejectMessage
          : (rejectMessage as _i3.String?),
      skipFilters: _i3.identical(skipFilters, _sentinel)
          ? this.skipFilters
          : (skipFilters as _i3.List<_i3.String>?),
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type as _i3.String),
    ) as $Res);
  }
}
