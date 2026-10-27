// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i10;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i9;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/message_trace_direction_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/message_trace_final_action_model.dart'
    as _i5;
import 'package:restmail_generated/src/model/message_trace_outcome_model.dart'
    as _i6;
import 'package:restmail_generated/src/model/message_trace_transport_model.dart'
    as _i8;
import 'package:restmail_generated/src/model/step_result.dart' as _i7;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class MessageTrace extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const MessageTrace({
    required this.clientIp,
    required this.createdAt,
    required this.direction,
    required this.durationMs,
    required this.finalAction,
    required this.id,
    required this.mailFrom,
    required this.messageId,
    required this.outcome,
    required this.pipelineId,
    required this.rcptTo,
    required this.reasonCode,
    required this.rfcMessageId,
    required this.sampled,
    required this.stages,
    required this.transport,
    this.expiresAt,
    this.spamScore,
  });

  factory MessageTrace.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for MessageTrace: contains complex types',
    );
  }

  factory MessageTrace.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'MessageTrace');
    return MessageTrace(
      clientIp: _$map[r'client_ip'].decodeJsonString(
        context: r'MessageTrace.client_ip',
      ),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'MessageTrace.created_at',
      ),
      direction: _i4.MessageTraceDirectionModel.fromJson(_$map[r'direction']),
      durationMs: _$map[r'duration_ms'].decodeJsonInt(
        context: r'MessageTrace.duration_ms',
      ),
      expiresAt: _$map[r'expires_at'].decodeJsonNullableDateTime(
        context: r'MessageTrace.expires_at',
      ),
      finalAction: _i5.MessageTraceFinalActionModel.fromJson(
        _$map[r'final_action'],
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'MessageTrace.id'),
      mailFrom: _$map[r'mail_from'].decodeJsonString(
        context: r'MessageTrace.mail_from',
      ),
      messageId: _$map[r'message_id'].decodeJsonNullableInt(
        context: r'MessageTrace.message_id',
      ),
      outcome: _i6.MessageTraceOutcomeModel.fromJson(_$map[r'outcome']),
      pipelineId: _$map[r'pipeline_id'].decodeJsonInt(
        context: r'MessageTrace.pipeline_id',
      ),
      rcptTo: _$map[r'rcpt_to'].decodeJsonString(
        context: r'MessageTrace.rcpt_to',
      ),
      reasonCode: _$map[r'reason_code'].decodeJsonString(
        context: r'MessageTrace.reason_code',
      ),
      rfcMessageId: _$map[r'rfc_message_id'].decodeJsonString(
        context: r'MessageTrace.rfc_message_id',
      ),
      sampled: _$map[r'sampled'].decodeJsonBool(
        context: r'MessageTrace.sampled',
      ),
      spamScore: _$map[r'spam_score'].decodeJsonNullableDouble(
        context: r'MessageTrace.spam_score',
      ),
      stages: _$map[r'stages']
          .decodeJsonNullableList<_i3.Object?>(context: r'MessageTrace.stages')
          ?.map(_i7.StepResult.fromJson)
          .toList(),
      transport: _i8.MessageTraceTransportModel.fromJson(_$map[r'transport']),
    );
  }

  factory MessageTrace.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for MessageTrace: contains complex types',
    );
  }

  final _i3.String clientIp;

  final _i3.DateTime createdAt;

  final _i4.MessageTraceDirectionModel direction;

  final _i3.int durationMs;

  final _i3.DateTime? expiresAt;

  final _i5.MessageTraceFinalActionModel finalAction;

  final _i3.int id;

  final _i3.String mailFrom;

  final _i3.int? messageId;

  final _i6.MessageTraceOutcomeModel outcome;

  final _i3.int pipelineId;

  final _i3.String rcptTo;

  final _i3.String reasonCode;

  final _i3.String rfcMessageId;

  final _i3.bool sampled;

  final _i3.double? spamScore;

  final _i3.List<_i7.StepResult>? stages;

  final _i8.MessageTraceTransportModel transport;

  @_i3.override
  _i3.Object? toJson() => {
    r'client_ip': clientIp,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'direction': direction.toJson(),
    r'duration_ms': durationMs,
    r'expires_at': expiresAt?.toTimeZonedIso8601String(),
    r'final_action': finalAction.toJson(),
    r'id': id,
    r'mail_from': mailFrom,
    r'message_id': messageId,
    r'outcome': outcome.toJson(),
    r'pipeline_id': pipelineId,
    r'rcpt_to': rcptTo,
    r'reason_code': reasonCode,
    r'rfc_message_id': rfcMessageId,
    r'sampled': sampled,
    r'spam_score': spamScore,
    r'stages': stages?.map((e) => e.toJson()).toList(),
    r'transport': transport.toJson(),
  };

  $$MessageTraceCopyWith<MessageTrace> get copyWith =>
      _MessageTraceCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i9.DeepCollectionEquality();
    return other is MessageTrace &&
        other.clientIp == this.clientIp &&
        other.createdAt == this.createdAt &&
        other.direction == this.direction &&
        other.durationMs == this.durationMs &&
        other.expiresAt == this.expiresAt &&
        other.finalAction == this.finalAction &&
        other.id == this.id &&
        other.mailFrom == this.mailFrom &&
        other.messageId == this.messageId &&
        other.outcome == this.outcome &&
        other.pipelineId == this.pipelineId &&
        other.rcptTo == this.rcptTo &&
        other.reasonCode == this.reasonCode &&
        other.rfcMessageId == this.rfcMessageId &&
        other.sampled == this.sampled &&
        other.spamScore == this.spamScore &&
        _$deepEquals.equals(other.stages, this.stages) &&
        other.transport == this.transport;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i9.DeepCollectionEquality();
    return _i3.Object.hashAll([
      clientIp,
      createdAt,
      direction,
      durationMs,
      expiresAt,
      finalAction,
      id,
      mailFrom,
      messageId,
      outcome,
      pipelineId,
      rcptTo,
      reasonCode,
      rfcMessageId,
      sampled,
      spamScore,
      deepEquals.hash(stages),
      transport,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for MessageTrace: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i10.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode MessageTrace: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$MessageTraceCopyWith<$Res> {
  factory $$MessageTraceCopyWith(MessageTrace value) =
      _MessageTraceCopyWith<$Res>;

  $Res call({
    _i3.String? clientIp,
    _i3.DateTime? createdAt,
    _i4.MessageTraceDirectionModel? direction,
    _i3.int? durationMs,
    _i3.DateTime? expiresAt,
    _i5.MessageTraceFinalActionModel? finalAction,
    _i3.int? id,
    _i3.String? mailFrom,
    _i3.int? messageId,
    _i6.MessageTraceOutcomeModel? outcome,
    _i3.int? pipelineId,
    _i3.String? rcptTo,
    _i3.String? reasonCode,
    _i3.String? rfcMessageId,
    _i3.bool? sampled,
    _i3.double? spamScore,
    _i3.List<_i7.StepResult>? stages,
    _i8.MessageTraceTransportModel? transport,
  });
  _i3.String get clientIp;
  _i3.DateTime get createdAt;
  _i4.MessageTraceDirectionModel get direction;
  _i3.int get durationMs;
  _i3.DateTime? get expiresAt;
  _i5.MessageTraceFinalActionModel get finalAction;
  _i3.int get id;
  _i3.String get mailFrom;
  _i3.int? get messageId;
  _i6.MessageTraceOutcomeModel get outcome;
  _i3.int get pipelineId;
  _i3.String get rcptTo;
  _i3.String get reasonCode;
  _i3.String get rfcMessageId;
  _i3.bool get sampled;
  _i3.double? get spamScore;
  _i3.List<_i7.StepResult>? get stages;
  _i8.MessageTraceTransportModel get transport;
}

class _MessageTraceCopyWith<$Res> implements $$MessageTraceCopyWith<$Res> {
  _MessageTraceCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final MessageTrace _value;

  @_i3.override
  _i3.String get clientIp => _value.clientIp;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i4.MessageTraceDirectionModel get direction => _value.direction;

  @_i3.override
  _i3.int get durationMs => _value.durationMs;

  @_i3.override
  _i3.DateTime? get expiresAt => _value.expiresAt;

  @_i3.override
  _i5.MessageTraceFinalActionModel get finalAction => _value.finalAction;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get mailFrom => _value.mailFrom;

  @_i3.override
  _i3.int? get messageId => _value.messageId;

  @_i3.override
  _i6.MessageTraceOutcomeModel get outcome => _value.outcome;

  @_i3.override
  _i3.int get pipelineId => _value.pipelineId;

  @_i3.override
  _i3.String get rcptTo => _value.rcptTo;

  @_i3.override
  _i3.String get reasonCode => _value.reasonCode;

  @_i3.override
  _i3.String get rfcMessageId => _value.rfcMessageId;

  @_i3.override
  _i3.bool get sampled => _value.sampled;

  @_i3.override
  _i3.double? get spamScore => _value.spamScore;

  @_i3.override
  _i3.List<_i7.StepResult>? get stages => _value.stages;

  @_i3.override
  _i8.MessageTraceTransportModel get transport => _value.transport;

  @_i3.override
  $Res call({
    _i3.Object? clientIp = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? direction = _sentinel,
    _i3.Object? durationMs = _sentinel,
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? finalAction = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? mailFrom = _sentinel,
    _i3.Object? messageId = _sentinel,
    _i3.Object? outcome = _sentinel,
    _i3.Object? pipelineId = _sentinel,
    _i3.Object? rcptTo = _sentinel,
    _i3.Object? reasonCode = _sentinel,
    _i3.Object? rfcMessageId = _sentinel,
    _i3.Object? sampled = _sentinel,
    _i3.Object? spamScore = _sentinel,
    _i3.Object? stages = _sentinel,
    _i3.Object? transport = _sentinel,
  }) {
    return (MessageTrace(
      clientIp: _i3.identical(clientIp, _sentinel)
          ? this.clientIp
          : (clientIp as _i3.String),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      direction: _i3.identical(direction, _sentinel)
          ? this.direction
          : (direction as _i4.MessageTraceDirectionModel),
      durationMs: _i3.identical(durationMs, _sentinel)
          ? this.durationMs
          : (durationMs as _i3.int),
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime?),
      finalAction: _i3.identical(finalAction, _sentinel)
          ? this.finalAction
          : (finalAction as _i5.MessageTraceFinalActionModel),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      mailFrom: _i3.identical(mailFrom, _sentinel)
          ? this.mailFrom
          : (mailFrom as _i3.String),
      messageId: _i3.identical(messageId, _sentinel)
          ? this.messageId
          : (messageId as _i3.int?),
      outcome: _i3.identical(outcome, _sentinel)
          ? this.outcome
          : (outcome as _i6.MessageTraceOutcomeModel),
      pipelineId: _i3.identical(pipelineId, _sentinel)
          ? this.pipelineId
          : (pipelineId as _i3.int),
      rcptTo: _i3.identical(rcptTo, _sentinel)
          ? this.rcptTo
          : (rcptTo as _i3.String),
      reasonCode: _i3.identical(reasonCode, _sentinel)
          ? this.reasonCode
          : (reasonCode as _i3.String),
      rfcMessageId: _i3.identical(rfcMessageId, _sentinel)
          ? this.rfcMessageId
          : (rfcMessageId as _i3.String),
      sampled: _i3.identical(sampled, _sentinel)
          ? this.sampled
          : (sampled as _i3.bool),
      spamScore: _i3.identical(spamScore, _sentinel)
          ? this.spamScore
          : (spamScore as _i3.double?),
      stages: _i3.identical(stages, _sentinel)
          ? this.stages
          : (stages as _i3.List<_i7.StepResult>?),
      transport: _i3.identical(transport, _sentinel)
          ? this.transport
          : (transport as _i8.MessageTraceTransportModel),
    ) as $Res);
  }
}
