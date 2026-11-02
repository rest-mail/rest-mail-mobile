// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ContactReplyTimeSetting extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ContactReplyTimeSetting({required this.enabled});

  factory ContactReplyTimeSetting.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'enabled'},
      listKeys: {},
      context: r'ContactReplyTimeSetting',
    );
    return ContactReplyTimeSetting(
      enabled: _$values[r'enabled'].decodeSimpleBool(
        context: r'ContactReplyTimeSetting.enabled',
      ),
    );
  }

  factory ContactReplyTimeSetting.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ContactReplyTimeSetting');
    return ContactReplyTimeSetting(
      enabled: _$map[r'enabled'].decodeJsonBool(
        context: r'ContactReplyTimeSetting.enabled',
      ),
    );
  }

  factory ContactReplyTimeSetting.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'enabled'},
      listKeys: {},
      context: r'ContactReplyTimeSetting',
    );
    return ContactReplyTimeSetting(
      enabled: _$values[r'enabled'].decodeFormBool(
        context: r'ContactReplyTimeSetting.enabled',
      ),
    );
  }

  final _i3.bool enabled;

  @_i3.override
  _i3.Object? toJson() => {r'enabled': enabled};

  $$ContactReplyTimeSettingCopyWith<ContactReplyTimeSetting> get copyWith =>
      _ContactReplyTimeSettingCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ContactReplyTimeSetting && other.enabled == this.enabled;
  }

  @_i3.override
  _i3.int get hashCode => enabled.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'enabled'] = _i1.PropertyValue.scalar(enabled.toString());
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
      r'Cannot uriEncode ContactReplyTimeSetting: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ContactReplyTimeSettingCopyWith<$Res> {
  factory $$ContactReplyTimeSettingCopyWith(ContactReplyTimeSetting value) =
      _ContactReplyTimeSettingCopyWith<$Res>;

  $Res call({_i3.bool? enabled});
  _i3.bool get enabled;
}

class _ContactReplyTimeSettingCopyWith<$Res>
    implements $$ContactReplyTimeSettingCopyWith<$Res> {
  _ContactReplyTimeSettingCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ContactReplyTimeSetting _value;

  @_i3.override
  _i3.bool get enabled => _value.enabled;

  @_i3.override
  $Res call({_i3.Object? enabled = _sentinel}) {
    return (ContactReplyTimeSetting(
      enabled: _i3.identical(enabled, _sentinel)
          ? this.enabled
          : (enabled as _i3.bool),
    ) as $Res);
  }
}
