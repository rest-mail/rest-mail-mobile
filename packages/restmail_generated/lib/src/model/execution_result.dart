// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/auth_result.dart' as _i4;
import 'package:restmail_generated/src/model/execution_result_final_email_one_of_model.dart'
    as _i5;
import 'package:restmail_generated/src/model/step_result.dart' as _i6;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ExecutionResult extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ExecutionResult({
    required this.durationMs,
    required this.finalAction,
    required this.finalEmail,
    required this.steps,
    this.authResults,
    this.rejectMessage,
  });

  factory ExecutionResult.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ExecutionResult: contains complex types',
    );
  }

  factory ExecutionResult.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ExecutionResult');
    return ExecutionResult(
      authResults: _$map[r'auth_results']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'ExecutionResult.auth_results',
          )
          ?.map(_i4.AuthResult.fromJson)
          .toList(),
      durationMs: _$map[r'duration_ms'].decodeJsonInt(
        context: r'ExecutionResult.duration_ms',
      ),
      finalAction: _$map[r'final_action'].decodeJsonString(
        context: r'ExecutionResult.final_action',
      ),
      finalEmail: _$map[r'final_email'] == null
          ? null
          : _i5.ExecutionResultFinalEmailOneOfModel.fromJson(
              _$map[r'final_email'],
            ),
      rejectMessage: _$map[r'reject_message'].decodeJsonNullableString(
        context: r'ExecutionResult.reject_message',
      ),
      steps: _$map[r'steps']
          .decodeJsonList<_i3.Object?>(context: r'ExecutionResult.steps')
          .map(_i6.StepResult.fromJson)
          .toList(),
    );
  }

  factory ExecutionResult.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ExecutionResult: contains complex types',
    );
  }

  final _i3.List<_i4.AuthResult>? authResults;

  final _i3.int durationMs;

  final _i3.String finalAction;

  final _i5.ExecutionResultFinalEmailOneOfModel finalEmail;

  final _i3.String? rejectMessage;

  final _i3.List<_i6.StepResult> steps;

  @_i3.override
  _i3.Object? toJson() => {
    if (authResults != null)
      r'auth_results': authResults?.map((e) => e.toJson()).toList(),
    r'duration_ms': durationMs,
    r'final_action': finalAction,
    r'final_email': finalEmail?.toJson(),
    if (rejectMessage != null) r'reject_message': rejectMessage,
    r'steps': steps.map((e) => e.toJson()).toList(),
  };

  $$ExecutionResultCopyWith<ExecutionResult> get copyWith =>
      _ExecutionResultCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other is ExecutionResult &&
        _$deepEquals.equals(other.authResults, this.authResults) &&
        other.durationMs == this.durationMs &&
        other.finalAction == this.finalAction &&
        other.finalEmail == this.finalEmail &&
        other.rejectMessage == this.rejectMessage &&
        _$deepEquals.equals(other.steps, this.steps);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(authResults),
      durationMs,
      finalAction,
      finalEmail,
      rejectMessage,
      deepEquals.hash(steps),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ExecutionResult: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ExecutionResult: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ExecutionResultCopyWith<$Res> {
  factory $$ExecutionResultCopyWith(ExecutionResult value) =
      _ExecutionResultCopyWith<$Res>;

  $Res call({
    _i3.List<_i4.AuthResult>? authResults,
    _i3.int? durationMs,
    _i3.String? finalAction,
    _i5.ExecutionResultFinalEmailOneOfModel? finalEmail,
    _i3.String? rejectMessage,
    _i3.List<_i6.StepResult>? steps,
  });
  _i3.List<_i4.AuthResult>? get authResults;
  _i3.int get durationMs;
  _i3.String get finalAction;
  _i5.ExecutionResultFinalEmailOneOfModel get finalEmail;
  _i3.String? get rejectMessage;
  _i3.List<_i6.StepResult> get steps;
}

class _ExecutionResultCopyWith<$Res>
    implements $$ExecutionResultCopyWith<$Res> {
  _ExecutionResultCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ExecutionResult _value;

  @_i3.override
  _i3.List<_i4.AuthResult>? get authResults => _value.authResults;

  @_i3.override
  _i3.int get durationMs => _value.durationMs;

  @_i3.override
  _i3.String get finalAction => _value.finalAction;

  @_i3.override
  _i5.ExecutionResultFinalEmailOneOfModel get finalEmail => _value.finalEmail;

  @_i3.override
  _i3.String? get rejectMessage => _value.rejectMessage;

  @_i3.override
  _i3.List<_i6.StepResult> get steps => _value.steps;

  @_i3.override
  $Res call({
    _i3.Object? authResults = _sentinel,
    _i3.Object? durationMs = _sentinel,
    _i3.Object? finalAction = _sentinel,
    _i3.Object? finalEmail = _sentinel,
    _i3.Object? rejectMessage = _sentinel,
    _i3.Object? steps = _sentinel,
  }) {
    return (ExecutionResult(
      authResults: _i3.identical(authResults, _sentinel)
          ? this.authResults
          : (authResults as _i3.List<_i4.AuthResult>?),
      durationMs: _i3.identical(durationMs, _sentinel)
          ? this.durationMs
          : (durationMs as _i3.int),
      finalAction: _i3.identical(finalAction, _sentinel)
          ? this.finalAction
          : (finalAction as _i3.String),
      finalEmail: _i3.identical(finalEmail, _sentinel)
          ? this.finalEmail
          : (finalEmail as _i5.ExecutionResultFinalEmailOneOfModel),
      rejectMessage: _i3.identical(rejectMessage, _sentinel)
          ? this.rejectMessage
          : (rejectMessage as _i3.String?),
      steps: _i3.identical(steps, _sentinel)
          ? this.steps
          : (steps as _i3.List<_i6.StepResult>),
    ) as $Res);
  }
}
