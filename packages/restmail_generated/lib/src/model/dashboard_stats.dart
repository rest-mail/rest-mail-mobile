// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i9;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i8;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/inbound_transport_security.dart'
    as _i4;
import 'package:restmail_generated/src/model/message_volume_data.dart' as _i5;
import 'package:restmail_generated/src/model/queue_stats.dart' as _i6;
import 'package:restmail_generated/src/model/recent_activity.dart' as _i7;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DashboardStats extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DashboardStats({
    required this.domainCount,
    required this.inboundTransportSecurity,
    required this.mailboxCount,
    required this.messageVolume,
    required this.queueStats,
    required this.recentActivity,
  });

  factory DashboardStats.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DashboardStats: contains complex types',
    );
  }

  factory DashboardStats.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DashboardStats');
    return DashboardStats(
      domainCount: _$map[r'domainCount'].decodeJsonInt(
        context: r'DashboardStats.domainCount',
      ),
      inboundTransportSecurity: _i4.InboundTransportSecurity.fromJson(
        _$map[r'inboundTransportSecurity'],
      ),
      mailboxCount: _$map[r'mailboxCount'].decodeJsonInt(
        context: r'DashboardStats.mailboxCount',
      ),
      messageVolume: _$map[r'messageVolume']
          .decodeJsonList<_i3.Object?>(context: r'DashboardStats.messageVolume')
          .map(_i5.MessageVolumeData.fromJson)
          .toList(),
      queueStats: _i6.QueueStats.fromJson(_$map[r'queueStats']),
      recentActivity: _$map[r'recentActivity']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'DashboardStats.recentActivity',
          )
          ?.map(_i7.RecentActivity.fromJson)
          .toList(),
    );
  }

  factory DashboardStats.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DashboardStats: contains complex types',
    );
  }

  final _i3.int domainCount;

  final _i4.InboundTransportSecurity inboundTransportSecurity;

  final _i3.int mailboxCount;

  final _i3.List<_i5.MessageVolumeData> messageVolume;

  final _i6.QueueStats queueStats;

  final _i3.List<_i7.RecentActivity>? recentActivity;

  @_i3.override
  _i3.Object? toJson() => {
    r'domainCount': domainCount,
    r'inboundTransportSecurity': inboundTransportSecurity.toJson(),
    r'mailboxCount': mailboxCount,
    r'messageVolume': messageVolume.map((e) => e.toJson()).toList(),
    r'queueStats': queueStats.toJson(),
    r'recentActivity': recentActivity?.map((e) => e.toJson()).toList(),
  };

  $$DashboardStatsCopyWith<DashboardStats> get copyWith =>
      _DashboardStatsCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i8.DeepCollectionEquality();
    return other is DashboardStats &&
        other.domainCount == this.domainCount &&
        other.inboundTransportSecurity == this.inboundTransportSecurity &&
        other.mailboxCount == this.mailboxCount &&
        _$deepEquals.equals(other.messageVolume, this.messageVolume) &&
        other.queueStats == this.queueStats &&
        _$deepEquals.equals(other.recentActivity, this.recentActivity);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i8.DeepCollectionEquality();
    return _i3.Object.hashAll([
      domainCount,
      inboundTransportSecurity,
      mailboxCount,
      deepEquals.hash(messageVolume),
      queueStats,
      deepEquals.hash(recentActivity),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DashboardStats: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i9.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DashboardStats: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DashboardStatsCopyWith<$Res> {
  factory $$DashboardStatsCopyWith(DashboardStats value) =
      _DashboardStatsCopyWith<$Res>;

  $Res call({
    _i3.int? domainCount,
    _i4.InboundTransportSecurity? inboundTransportSecurity,
    _i3.int? mailboxCount,
    _i3.List<_i5.MessageVolumeData>? messageVolume,
    _i6.QueueStats? queueStats,
    _i3.List<_i7.RecentActivity>? recentActivity,
  });
  _i3.int get domainCount;
  _i4.InboundTransportSecurity get inboundTransportSecurity;
  _i3.int get mailboxCount;
  _i3.List<_i5.MessageVolumeData> get messageVolume;
  _i6.QueueStats get queueStats;
  _i3.List<_i7.RecentActivity>? get recentActivity;
}

class _DashboardStatsCopyWith<$Res> implements $$DashboardStatsCopyWith<$Res> {
  _DashboardStatsCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DashboardStats _value;

  @_i3.override
  _i3.int get domainCount => _value.domainCount;

  @_i3.override
  _i4.InboundTransportSecurity get inboundTransportSecurity =>
      _value.inboundTransportSecurity;

  @_i3.override
  _i3.int get mailboxCount => _value.mailboxCount;

  @_i3.override
  _i3.List<_i5.MessageVolumeData> get messageVolume => _value.messageVolume;

  @_i3.override
  _i6.QueueStats get queueStats => _value.queueStats;

  @_i3.override
  _i3.List<_i7.RecentActivity>? get recentActivity => _value.recentActivity;

  @_i3.override
  $Res call({
    _i3.Object? domainCount = _sentinel,
    _i3.Object? inboundTransportSecurity = _sentinel,
    _i3.Object? mailboxCount = _sentinel,
    _i3.Object? messageVolume = _sentinel,
    _i3.Object? queueStats = _sentinel,
    _i3.Object? recentActivity = _sentinel,
  }) {
    return (DashboardStats(
      domainCount: _i3.identical(domainCount, _sentinel)
          ? this.domainCount
          : (domainCount as _i3.int),
      inboundTransportSecurity:
          _i3.identical(inboundTransportSecurity, _sentinel)
          ? this.inboundTransportSecurity
          : (inboundTransportSecurity as _i4.InboundTransportSecurity),
      mailboxCount: _i3.identical(mailboxCount, _sentinel)
          ? this.mailboxCount
          : (mailboxCount as _i3.int),
      messageVolume: _i3.identical(messageVolume, _sentinel)
          ? this.messageVolume
          : (messageVolume as _i3.List<_i5.MessageVolumeData>),
      queueStats: _i3.identical(queueStats, _sentinel)
          ? this.queueStats
          : (queueStats as _i6.QueueStats),
      recentActivity: _i3.identical(recentActivity, _sentinel)
          ? this.recentActivity
          : (recentActivity as _i3.List<_i7.RecentActivity>?),
    ) as $Res);
  }
}
