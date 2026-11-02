// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DeliverMessageBodyModel2 extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DeliverMessageBodyModel2({required this.mailboxId});

  factory DeliverMessageBodyModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'mailbox_id'},
      listKeys: {},
      context: r'DeliverMessageBodyModel2',
    );
    return DeliverMessageBodyModel2(mailboxId: _$values[r'mailbox_id']);
  }

  factory DeliverMessageBodyModel2.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DeliverMessageBodyModel2');
    return DeliverMessageBodyModel2(mailboxId: _$map[r'mailbox_id']);
  }

  factory DeliverMessageBodyModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'mailbox_id'},
      listKeys: {},
      context: r'DeliverMessageBodyModel2',
    );
    return DeliverMessageBodyModel2(
      mailboxId: _$values[r'mailbox_id'].decodeFormNullableString(
        context: r'DeliverMessageBodyModel2.mailbox_id',
      ),
    );
  }

  final _i3.Object? mailboxId;

  @_i3.override
  _i3.Object? toJson() => {
    r'mailbox_id': _i1.encodeUnknownJson(
      mailboxId,
      context: r'DeliverMessageBodyModel2.mailbox_id',
    ),
  };

  $$DeliverMessageBodyModel2CopyWith<DeliverMessageBodyModel2> get copyWith =>
      _DeliverMessageBodyModel2CopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageBodyModel2 &&
        other.mailboxId == this.mailboxId;
  }

  @_i3.override
  _i3.int get hashCode => mailboxId.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (mailboxId != null) {
      _$result[r'mailbox_id'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          mailboxId!,
          context: r'DeliverMessageBodyModel2.mailbox_id',
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
      r'Cannot uriEncode DeliverMessageBodyModel2: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DeliverMessageBodyModel2CopyWith<$Res> {
  factory $$DeliverMessageBodyModel2CopyWith(DeliverMessageBodyModel2 value) =
      _DeliverMessageBodyModel2CopyWith<$Res>;

  $Res call({_i3.Object? mailboxId});
  _i3.Object? get mailboxId;
}

class _DeliverMessageBodyModel2CopyWith<$Res>
    implements $$DeliverMessageBodyModel2CopyWith<$Res> {
  _DeliverMessageBodyModel2CopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DeliverMessageBodyModel2 _value;

  @_i3.override
  _i3.Object? get mailboxId => _value.mailboxId;

  @_i3.override
  $Res call({_i3.Object? mailboxId = _sentinel}) {
    return (DeliverMessageBodyModel2(
      mailboxId: _i3.identical(mailboxId, _sentinel)
          ? this.mailboxId
          : mailboxId,
    ) as $Res);
  }
}
