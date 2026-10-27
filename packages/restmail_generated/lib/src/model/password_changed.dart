// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PasswordChanged extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PasswordChanged({required this.message});

  factory PasswordChanged.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'message'},
      listKeys: {},
      context: r'PasswordChanged',
    );
    return PasswordChanged(
      message: _$values[r'message'].decodeSimpleString(
        context: r'PasswordChanged.message',
      ),
    );
  }

  factory PasswordChanged.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'PasswordChanged');
    return PasswordChanged(
      message: _$map[r'message'].decodeJsonString(
        context: r'PasswordChanged.message',
      ),
    );
  }

  factory PasswordChanged.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'message'},
      listKeys: {},
      context: r'PasswordChanged',
    );
    return PasswordChanged(
      message: _$values[r'message'].decodeFormString(
        context: r'PasswordChanged.message',
      ),
    );
  }

  final _i3.String message;

  @_i3.override
  _i3.Object? toJson() => {r'message': message};

  $$PasswordChangedCopyWith<PasswordChanged> get copyWith =>
      _PasswordChangedCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PasswordChanged && other.message == this.message;
  }

  @_i3.override
  _i3.int get hashCode => message.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'message'] = _i1.PropertyValue.scalar(message);
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
      r'Cannot uriEncode PasswordChanged: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$PasswordChangedCopyWith<$Res> {
  factory $$PasswordChangedCopyWith(PasswordChanged value) =
      _PasswordChangedCopyWith<$Res>;

  $Res call({_i3.String? message});
  _i3.String get message;
}

class _PasswordChangedCopyWith<$Res>
    implements $$PasswordChangedCopyWith<$Res> {
  _PasswordChangedCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final PasswordChanged _value;

  @_i3.override
  _i3.String get message => _value.message;

  @_i3.override
  $Res call({_i3.Object? message = _sentinel}) {
    return (PasswordChanged(
      message: _i3.identical(message, _sentinel)
          ? this.message
          : (message as _i3.String),
    ) as $Res);
  }
}
