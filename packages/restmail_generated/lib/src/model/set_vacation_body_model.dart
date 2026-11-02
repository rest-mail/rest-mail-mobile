// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetVacationBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SetVacationBodyModel({required this.body, required this.subject});

  factory SetVacationBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'body', r'subject'},
      listKeys: {},
      context: r'SetVacationBodyModel',
    );
    return SetVacationBodyModel(
      body: _$values[r'body'],
      subject: _$values[r'subject'],
    );
  }

  factory SetVacationBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SetVacationBodyModel');
    return SetVacationBodyModel(
      body: _$map[r'body'],
      subject: _$map[r'subject'],
    );
  }

  factory SetVacationBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'body', r'subject'},
      listKeys: {},
      context: r'SetVacationBodyModel',
    );
    return SetVacationBodyModel(
      body: _$values[r'body'].decodeFormNullableString(
        context: r'SetVacationBodyModel.body',
      ),
      subject: _$values[r'subject'].decodeFormNullableString(
        context: r'SetVacationBodyModel.subject',
      ),
    );
  }

  final _i3.Object? body;

  final _i3.Object? subject;

  @_i3.override
  _i3.Object? toJson() => {
    r'body': _i1.encodeUnknownJson(body, context: r'SetVacationBodyModel.body'),
    r'subject': _i1.encodeUnknownJson(
      subject,
      context: r'SetVacationBodyModel.subject',
    ),
  };

  $$SetVacationBodyModelCopyWith<SetVacationBodyModel> get copyWith =>
      _SetVacationBodyModelCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationBodyModel &&
        other.body == this.body &&
        other.subject == this.subject;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([body, subject]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (body != null) {
      _$result[r'body'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          body!,
          context: r'SetVacationBodyModel.body',
        ),
      );
    }
    if (subject != null) {
      _$result[r'subject'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          subject!,
          context: r'SetVacationBodyModel.subject',
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
      r'Cannot uriEncode SetVacationBodyModel: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SetVacationBodyModelCopyWith<$Res> {
  factory $$SetVacationBodyModelCopyWith(SetVacationBodyModel value) =
      _SetVacationBodyModelCopyWith<$Res>;

  $Res call({_i3.Object? body, _i3.Object? subject});
  _i3.Object? get body;
  _i3.Object? get subject;
}

class _SetVacationBodyModelCopyWith<$Res>
    implements $$SetVacationBodyModelCopyWith<$Res> {
  _SetVacationBodyModelCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SetVacationBodyModel _value;

  @_i3.override
  _i3.Object? get body => _value.body;

  @_i3.override
  _i3.Object? get subject => _value.subject;

  @_i3.override
  $Res call({_i3.Object? body = _sentinel, _i3.Object? subject = _sentinel}) {
    return (SetVacationBodyModel(
      body: _i3.identical(body, _sentinel) ? this.body : body,
      subject: _i3.identical(subject, _sentinel) ? this.subject : subject,
    ) as $Res);
  }
}
