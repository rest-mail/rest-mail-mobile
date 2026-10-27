// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i10;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i9;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/auth_verdict_count.dart' as _i4;
import 'package:restmail_generated/src/model/reject_reason_count.dart' as _i8;
import 'package:restmail_generated/src/model/stage_decision_count.dart' as _i6;
import 'package:restmail_generated/src/model/terminal_count.dart' as _i7;
import 'package:restmail_generated/src/model/transport_count.dart' as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PipelineFunnel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PipelineFunnel({
    required this.authVerdicts,
    required this.received,
    required this.stageDecisions,
    required this.terminalOutcomes,
    required this.topRejectReasons,
  });

  factory PipelineFunnel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PipelineFunnel: contains complex types',
    );
  }

  factory PipelineFunnel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'PipelineFunnel');
    return PipelineFunnel(
      authVerdicts: _$map[r'auth_verdicts']
          .decodeJsonList<_i3.Object?>(context: r'PipelineFunnel.auth_verdicts')
          .map(_i4.AuthVerdictCount.fromJson)
          .toList(),
      received: _$map[r'received']
          .decodeJsonList<_i3.Object?>(context: r'PipelineFunnel.received')
          .map(_i5.TransportCount.fromJson)
          .toList(),
      stageDecisions: _$map[r'stage_decisions']
          .decodeJsonList<_i3.Object?>(
            context: r'PipelineFunnel.stage_decisions',
          )
          .map(_i6.StageDecisionCount.fromJson)
          .toList(),
      terminalOutcomes: _$map[r'terminal_outcomes']
          .decodeJsonList<_i3.Object?>(
            context: r'PipelineFunnel.terminal_outcomes',
          )
          .map(_i7.TerminalCount.fromJson)
          .toList(),
      topRejectReasons: _$map[r'top_reject_reasons']
          .decodeJsonList<_i3.Object?>(
            context: r'PipelineFunnel.top_reject_reasons',
          )
          .map(_i8.RejectReasonCount.fromJson)
          .toList(),
    );
  }

  factory PipelineFunnel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PipelineFunnel: contains complex types',
    );
  }

  final _i3.List<_i4.AuthVerdictCount> authVerdicts;

  final _i3.List<_i5.TransportCount> received;

  final _i3.List<_i6.StageDecisionCount> stageDecisions;

  final _i3.List<_i7.TerminalCount> terminalOutcomes;

  final _i3.List<_i8.RejectReasonCount> topRejectReasons;

  @_i3.override
  _i3.Object? toJson() => {
    r'auth_verdicts': authVerdicts.map((e) => e.toJson()).toList(),
    r'received': received.map((e) => e.toJson()).toList(),
    r'stage_decisions': stageDecisions.map((e) => e.toJson()).toList(),
    r'terminal_outcomes': terminalOutcomes.map((e) => e.toJson()).toList(),
    r'top_reject_reasons': topRejectReasons.map((e) => e.toJson()).toList(),
  };

  $$PipelineFunnelCopyWith<PipelineFunnel> get copyWith =>
      _PipelineFunnelCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i9.DeepCollectionEquality();
    return other is PipelineFunnel &&
        _$deepEquals.equals(other.authVerdicts, this.authVerdicts) &&
        _$deepEquals.equals(other.received, this.received) &&
        _$deepEquals.equals(other.stageDecisions, this.stageDecisions) &&
        _$deepEquals.equals(other.terminalOutcomes, this.terminalOutcomes) &&
        _$deepEquals.equals(other.topRejectReasons, this.topRejectReasons);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i9.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(authVerdicts),
      deepEquals.hash(received),
      deepEquals.hash(stageDecisions),
      deepEquals.hash(terminalOutcomes),
      deepEquals.hash(topRejectReasons),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PipelineFunnel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i10.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PipelineFunnel: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$PipelineFunnelCopyWith<$Res> {
  factory $$PipelineFunnelCopyWith(PipelineFunnel value) =
      _PipelineFunnelCopyWith<$Res>;

  $Res call({
    _i3.List<_i4.AuthVerdictCount>? authVerdicts,
    _i3.List<_i5.TransportCount>? received,
    _i3.List<_i6.StageDecisionCount>? stageDecisions,
    _i3.List<_i7.TerminalCount>? terminalOutcomes,
    _i3.List<_i8.RejectReasonCount>? topRejectReasons,
  });
  _i3.List<_i4.AuthVerdictCount> get authVerdicts;
  _i3.List<_i5.TransportCount> get received;
  _i3.List<_i6.StageDecisionCount> get stageDecisions;
  _i3.List<_i7.TerminalCount> get terminalOutcomes;
  _i3.List<_i8.RejectReasonCount> get topRejectReasons;
}

class _PipelineFunnelCopyWith<$Res> implements $$PipelineFunnelCopyWith<$Res> {
  _PipelineFunnelCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final PipelineFunnel _value;

  @_i3.override
  _i3.List<_i4.AuthVerdictCount> get authVerdicts => _value.authVerdicts;

  @_i3.override
  _i3.List<_i5.TransportCount> get received => _value.received;

  @_i3.override
  _i3.List<_i6.StageDecisionCount> get stageDecisions => _value.stageDecisions;

  @_i3.override
  _i3.List<_i7.TerminalCount> get terminalOutcomes => _value.terminalOutcomes;

  @_i3.override
  _i3.List<_i8.RejectReasonCount> get topRejectReasons =>
      _value.topRejectReasons;

  @_i3.override
  $Res call({
    _i3.Object? authVerdicts = _sentinel,
    _i3.Object? received = _sentinel,
    _i3.Object? stageDecisions = _sentinel,
    _i3.Object? terminalOutcomes = _sentinel,
    _i3.Object? topRejectReasons = _sentinel,
  }) {
    return (PipelineFunnel(
      authVerdicts: _i3.identical(authVerdicts, _sentinel)
          ? this.authVerdicts
          : (authVerdicts as _i3.List<_i4.AuthVerdictCount>),
      received: _i3.identical(received, _sentinel)
          ? this.received
          : (received as _i3.List<_i5.TransportCount>),
      stageDecisions: _i3.identical(stageDecisions, _sentinel)
          ? this.stageDecisions
          : (stageDecisions as _i3.List<_i6.StageDecisionCount>),
      terminalOutcomes: _i3.identical(terminalOutcomes, _sentinel)
          ? this.terminalOutcomes
          : (terminalOutcomes as _i3.List<_i7.TerminalCount>),
      topRejectReasons: _i3.identical(topRejectReasons, _sentinel)
          ? this.topRejectReasons
          : (topRejectReasons as _i3.List<_i8.RejectReasonCount>),
    ) as $Res);
  }
}
