// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TlsReportStored extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TlsReportStored({required this.stored});

  factory TlsReportStored.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'stored'},
      listKeys: {},
      context: r'TlsReportStored',
    );
    return TlsReportStored(
      stored: _$values[r'stored'].decodeSimpleInt(
        context: r'TlsReportStored.stored',
      ),
    );
  }

  factory TlsReportStored.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TlsReportStored');
    return TlsReportStored(
      stored: _$map[r'stored'].decodeJsonInt(
        context: r'TlsReportStored.stored',
      ),
    );
  }

  factory TlsReportStored.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'stored'},
      listKeys: {},
      context: r'TlsReportStored',
    );
    return TlsReportStored(
      stored: _$values[r'stored'].decodeFormInt(
        context: r'TlsReportStored.stored',
      ),
    );
  }

  final _i3.int stored;

  @_i3.override
  _i3.Object? toJson() => {r'stored': stored};

  $$TlsReportStoredCopyWith<TlsReportStored> get copyWith =>
      _TlsReportStoredCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TlsReportStored && other.stored == this.stored;
  }

  @_i3.override
  _i3.int get hashCode => stored.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'stored'] = _i1.PropertyValue.scalar(stored.toString());
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
      r'Cannot uriEncode TlsReportStored: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TlsReportStoredCopyWith<$Res> {
  factory $$TlsReportStoredCopyWith(TlsReportStored value) =
      _TlsReportStoredCopyWith<$Res>;

  $Res call({_i3.int? stored});
  _i3.int get stored;
}

class _TlsReportStoredCopyWith<$Res>
    implements $$TlsReportStoredCopyWith<$Res> {
  _TlsReportStoredCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TlsReportStored _value;

  @_i3.override
  _i3.int get stored => _value.stored;

  @_i3.override
  $Res call({_i3.Object? stored = _sentinel}) {
    return (TlsReportStored(
      stored: _i3.identical(stored, _sentinel)
          ? this.stored
          : (stored as _i3.int),
    ) as $Res);
  }
}
