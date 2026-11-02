// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UpdateServerCapabilitiesRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UpdateServerCapabilitiesRequest({this.capabilities});

  factory UpdateServerCapabilitiesRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'capabilities'},
      listKeys: {r'capabilities'},
      context: r'UpdateServerCapabilitiesRequest',
    );
    return UpdateServerCapabilitiesRequest(
      capabilities: _$values[r'capabilities'].decodeSimpleNullableStringList(
        context: r'UpdateServerCapabilitiesRequest.capabilities',
      ),
    );
  }

  factory UpdateServerCapabilitiesRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UpdateServerCapabilitiesRequest');
    return UpdateServerCapabilitiesRequest(
      capabilities: _$map[r'capabilities'].decodeJsonNullableList<_i3.String>(
        context: r'UpdateServerCapabilitiesRequest.capabilities',
      ),
    );
  }

  factory UpdateServerCapabilitiesRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'capabilities'},
      listKeys: {r'capabilities'},
      context: r'UpdateServerCapabilitiesRequest',
    );
    return UpdateServerCapabilitiesRequest(
      capabilities: _$values[r'capabilities'].decodeFormNullableStringList(
        context: r'UpdateServerCapabilitiesRequest.capabilities',
      ),
    );
  }

  final _i3.List<_i3.String>? capabilities;

  @_i3.override
  _i3.Object? toJson() => {r'capabilities': capabilities};

  $$UpdateServerCapabilitiesRequestCopyWith<UpdateServerCapabilitiesRequest>
  get copyWith => _UpdateServerCapabilitiesRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is UpdateServerCapabilitiesRequest &&
        _$deepEquals.equals(other.capabilities, this.capabilities);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return deepEquals.hash(capabilities);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (capabilities != null) {
      _$result[r'capabilities'] = _i1.PropertyValue.array(capabilities!);
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode UpdateServerCapabilitiesRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UpdateServerCapabilitiesRequestCopyWith<$Res> {
  factory $$UpdateServerCapabilitiesRequestCopyWith(
    UpdateServerCapabilitiesRequest value,
  ) = _UpdateServerCapabilitiesRequestCopyWith<$Res>;

  $Res call({_i3.List<_i3.String>? capabilities});
  _i3.List<_i3.String>? get capabilities;
}

class _UpdateServerCapabilitiesRequestCopyWith<$Res>
    implements $$UpdateServerCapabilitiesRequestCopyWith<$Res> {
  _UpdateServerCapabilitiesRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UpdateServerCapabilitiesRequest _value;

  @_i3.override
  _i3.List<_i3.String>? get capabilities => _value.capabilities;

  @_i3.override
  $Res call({_i3.Object? capabilities = _sentinel}) {
    return (UpdateServerCapabilitiesRequest(
      capabilities: _i3.identical(capabilities, _sentinel)
          ? this.capabilities
          : (capabilities as _i3.List<_i3.String>?),
    ) as $Res);
  }
}
