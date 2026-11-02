// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RestmailDeliverBodyModel3 extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RestmailDeliverBodyModel3({required this.to});

  factory RestmailDeliverBodyModel3.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'to'},
      listKeys: {},
      context: r'RestmailDeliverBodyModel3',
    );
    return RestmailDeliverBodyModel3(to: _$values[r'to']);
  }

  factory RestmailDeliverBodyModel3.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RestmailDeliverBodyModel3');
    return RestmailDeliverBodyModel3(to: _$map[r'to']);
  }

  factory RestmailDeliverBodyModel3.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'to'},
      listKeys: {},
      context: r'RestmailDeliverBodyModel3',
    );
    return RestmailDeliverBodyModel3(
      to: _$values[r'to'].decodeFormNullableString(
        context: r'RestmailDeliverBodyModel3.to',
      ),
    );
  }

  final _i3.Object? to;

  @_i3.override
  _i3.Object? toJson() => {
    r'to': _i1.encodeUnknownJson(to, context: r'RestmailDeliverBodyModel3.to'),
  };

  $$RestmailDeliverBodyModel3CopyWith<RestmailDeliverBodyModel3> get copyWith =>
      _RestmailDeliverBodyModel3CopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDeliverBodyModel3 && other.to == this.to;
  }

  @_i3.override
  _i3.int get hashCode => to.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (to != null) {
      _$result[r'to'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          to!,
          context: r'RestmailDeliverBodyModel3.to',
        ),
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
      r'Cannot uriEncode RestmailDeliverBodyModel3: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RestmailDeliverBodyModel3CopyWith<$Res> {
  factory $$RestmailDeliverBodyModel3CopyWith(RestmailDeliverBodyModel3 value) =
      _RestmailDeliverBodyModel3CopyWith<$Res>;

  $Res call({_i3.Object? to});
  _i3.Object? get to;
}

class _RestmailDeliverBodyModel3CopyWith<$Res>
    implements $$RestmailDeliverBodyModel3CopyWith<$Res> {
  _RestmailDeliverBodyModel3CopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RestmailDeliverBodyModel3 _value;

  @_i3.override
  _i3.Object? get to => _value.to;

  @_i3.override
  $Res call({_i3.Object? to = _sentinel}) {
    return (RestmailDeliverBodyModel3(
      to: _i3.identical(to, _sentinel) ? this.to : to,
    ) as $Res);
  }
}
