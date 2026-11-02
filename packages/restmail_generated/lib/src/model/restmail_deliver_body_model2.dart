// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RestmailDeliverBodyModel2 extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RestmailDeliverBodyModel2({required this.recipients});

  factory RestmailDeliverBodyModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'recipients'},
      listKeys: {},
      context: r'RestmailDeliverBodyModel2',
    );
    return RestmailDeliverBodyModel2(recipients: _$values[r'recipients']);
  }

  factory RestmailDeliverBodyModel2.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RestmailDeliverBodyModel2');
    return RestmailDeliverBodyModel2(recipients: _$map[r'recipients']);
  }

  factory RestmailDeliverBodyModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'recipients'},
      listKeys: {},
      context: r'RestmailDeliverBodyModel2',
    );
    return RestmailDeliverBodyModel2(
      recipients: _$values[r'recipients'].decodeFormNullableString(
        context: r'RestmailDeliverBodyModel2.recipients',
      ),
    );
  }

  final _i3.Object? recipients;

  @_i3.override
  _i3.Object? toJson() => {
    r'recipients': _i1.encodeUnknownJson(
      recipients,
      context: r'RestmailDeliverBodyModel2.recipients',
    ),
  };

  $$RestmailDeliverBodyModel2CopyWith<RestmailDeliverBodyModel2> get copyWith =>
      _RestmailDeliverBodyModel2CopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDeliverBodyModel2 &&
        other.recipients == this.recipients;
  }

  @_i3.override
  _i3.int get hashCode => recipients.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (recipients != null) {
      _$result[r'recipients'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          recipients!,
          context: r'RestmailDeliverBodyModel2.recipients',
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
      r'Cannot uriEncode RestmailDeliverBodyModel2: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RestmailDeliverBodyModel2CopyWith<$Res> {
  factory $$RestmailDeliverBodyModel2CopyWith(RestmailDeliverBodyModel2 value) =
      _RestmailDeliverBodyModel2CopyWith<$Res>;

  $Res call({_i3.Object? recipients});
  _i3.Object? get recipients;
}

class _RestmailDeliverBodyModel2CopyWith<$Res>
    implements $$RestmailDeliverBodyModel2CopyWith<$Res> {
  _RestmailDeliverBodyModel2CopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RestmailDeliverBodyModel2 _value;

  @_i3.override
  _i3.Object? get recipients => _value.recipients;

  @_i3.override
  $Res call({_i3.Object? recipients = _sentinel}) {
    return (RestmailDeliverBodyModel2(
      recipients: _i3.identical(recipients, _sentinel)
          ? this.recipients
          : recipients,
    ) as $Res);
  }
}
