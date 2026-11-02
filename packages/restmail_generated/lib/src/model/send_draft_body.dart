// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/send_draft_body_list_unsubscribe_one_of_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SendDraftBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SendDraftBody({this.listUnsubscribe, this.onBehalf});

  factory SendDraftBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for SendDraftBody: contains complex types',
    );
  }

  factory SendDraftBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SendDraftBody');
    return SendDraftBody(
      listUnsubscribe: _$map[r'list_unsubscribe'] == null
          ? null
          : _i4.SendDraftBodyListUnsubscribeOneOfModel.fromJson(
              _$map[r'list_unsubscribe'],
            ),
      onBehalf: _$map[r'on_behalf'].decodeJsonNullableBool(
        context: r'SendDraftBody.on_behalf',
      ),
    );
  }

  factory SendDraftBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for SendDraftBody: contains complex types',
    );
  }

  final _i4.SendDraftBodyListUnsubscribeOneOfModel? listUnsubscribe;

  final _i3.bool? onBehalf;

  @_i3.override
  _i3.Object? toJson() => {
    if (listUnsubscribe != null) r'list_unsubscribe': listUnsubscribe?.toJson(),
    if (onBehalf != null) r'on_behalf': onBehalf,
  };

  $$SendDraftBodyCopyWith<SendDraftBody> get copyWith =>
      _SendDraftBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftBody &&
        other.listUnsubscribe == this.listUnsubscribe &&
        other.onBehalf == this.onBehalf;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([listUnsubscribe, onBehalf]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for SendDraftBody: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SendDraftBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SendDraftBodyCopyWith<$Res> {
  factory $$SendDraftBodyCopyWith(SendDraftBody value) =
      _SendDraftBodyCopyWith<$Res>;

  $Res call({
    _i4.SendDraftBodyListUnsubscribeOneOfModel? listUnsubscribe,
    _i3.bool? onBehalf,
  });
  _i4.SendDraftBodyListUnsubscribeOneOfModel? get listUnsubscribe;
  _i3.bool? get onBehalf;
}

class _SendDraftBodyCopyWith<$Res> implements $$SendDraftBodyCopyWith<$Res> {
  _SendDraftBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SendDraftBody _value;

  @_i3.override
  _i4.SendDraftBodyListUnsubscribeOneOfModel? get listUnsubscribe =>
      _value.listUnsubscribe;

  @_i3.override
  _i3.bool? get onBehalf => _value.onBehalf;

  @_i3.override
  $Res call({
    _i3.Object? listUnsubscribe = _sentinel,
    _i3.Object? onBehalf = _sentinel,
  }) {
    return (SendDraftBody(
      listUnsubscribe: _i3.identical(listUnsubscribe, _sentinel)
          ? this.listUnsubscribe
          : (listUnsubscribe as _i4.SendDraftBodyListUnsubscribeOneOfModel?),
      onBehalf: _i3.identical(onBehalf, _sentinel)
          ? this.onBehalf
          : (onBehalf as _i3.bool?),
    ) as $Res);
  }
}
