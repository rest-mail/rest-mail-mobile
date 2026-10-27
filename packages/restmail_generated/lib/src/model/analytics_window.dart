// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class AnalyticsWindow extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const AnalyticsWindow({required this.since, required this.until, this.label});

  factory AnalyticsWindow.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'label', r'since', r'until'},
      listKeys: {},
      context: r'AnalyticsWindow',
    );
    return AnalyticsWindow(
      label: _$values[r'label'].decodeSimpleNullableString(
        context: r'AnalyticsWindow.label',
      ),
      since: _$values[r'since'].decodeSimpleDateTime(
        context: r'AnalyticsWindow.since',
      ),
      until: _$values[r'until'].decodeSimpleDateTime(
        context: r'AnalyticsWindow.until',
      ),
    );
  }

  factory AnalyticsWindow.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'AnalyticsWindow');
    return AnalyticsWindow(
      label: _$map[r'label'].decodeJsonNullableString(
        context: r'AnalyticsWindow.label',
      ),
      since: _$map[r'since'].decodeJsonDateTime(
        context: r'AnalyticsWindow.since',
      ),
      until: _$map[r'until'].decodeJsonDateTime(
        context: r'AnalyticsWindow.until',
      ),
    );
  }

  factory AnalyticsWindow.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'label', r'since', r'until'},
      listKeys: {},
      context: r'AnalyticsWindow',
    );
    return AnalyticsWindow(
      label: _$values[r'label'].decodeFormNullableString(
        context: r'AnalyticsWindow.label',
      ),
      since: _$values[r'since'].decodeFormDateTime(
        context: r'AnalyticsWindow.since',
      ),
      until: _$values[r'until'].decodeFormDateTime(
        context: r'AnalyticsWindow.until',
      ),
    );
  }

  final _i3.String? label;

  final _i3.DateTime since;

  final _i3.DateTime until;

  @_i3.override
  _i3.Object? toJson() => {
    if (label != null) r'label': label,
    r'since': since.toTimeZonedIso8601String(),
    r'until': until.toTimeZonedIso8601String(),
  };

  $$AnalyticsWindowCopyWith<AnalyticsWindow> get copyWith =>
      _AnalyticsWindowCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AnalyticsWindow &&
        other.label == this.label &&
        other.since == this.since &&
        other.until == this.until;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([label, since, until]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (label != null) {
      _$result[r'label'] = _i1.PropertyValue.scalar(label!);
    }
    _$result[r'since'] = _i1.PropertyValue.scalar(
      since.toTimeZonedIso8601String(),
    );
    _$result[r'until'] = _i1.PropertyValue.scalar(
      until.toTimeZonedIso8601String(),
    );
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
      r'Cannot uriEncode AnalyticsWindow: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AnalyticsWindowCopyWith<$Res> {
  factory $$AnalyticsWindowCopyWith(AnalyticsWindow value) =
      _AnalyticsWindowCopyWith<$Res>;

  $Res call({_i3.String? label, _i3.DateTime? since, _i3.DateTime? until});
  _i3.String? get label;
  _i3.DateTime get since;
  _i3.DateTime get until;
}

class _AnalyticsWindowCopyWith<$Res>
    implements $$AnalyticsWindowCopyWith<$Res> {
  _AnalyticsWindowCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final AnalyticsWindow _value;

  @_i3.override
  _i3.String? get label => _value.label;

  @_i3.override
  _i3.DateTime get since => _value.since;

  @_i3.override
  _i3.DateTime get until => _value.until;

  @_i3.override
  $Res call({
    _i3.Object? label = _sentinel,
    _i3.Object? since = _sentinel,
    _i3.Object? until = _sentinel,
  }) {
    return (AnalyticsWindow(
      label: _i3.identical(label, _sentinel)
          ? this.label
          : (label as _i3.String?),
      since: _i3.identical(since, _sentinel)
          ? this.since
          : (since as _i3.DateTime),
      until: _i3.identical(until, _sentinel)
          ? this.until
          : (until as _i3.DateTime),
    ) as $Res);
  }
}
