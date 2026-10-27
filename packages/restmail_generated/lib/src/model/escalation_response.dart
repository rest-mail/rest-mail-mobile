// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/entry.dart' as _i5;
import 'package:restmail_generated/src/model/grant_response.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class EscalationResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const EscalationResponse({
    required this.capabilities,
    required this.grant,
    required this.scopedCapabilities,
  });

  factory EscalationResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for EscalationResponse: contains complex types',
    );
  }

  factory EscalationResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'EscalationResponse');
    return EscalationResponse(
      capabilities: _$map[r'capabilities'].decodeJsonList<_i3.String>(
        context: r'EscalationResponse.capabilities',
      ),
      grant: _i4.GrantResponse.fromJson(_$map[r'grant']),
      scopedCapabilities: _$map[r'scoped_capabilities']
          .decodeJsonList<_i3.Object?>(
            context: r'EscalationResponse.scoped_capabilities',
          )
          .map(_i5.Entry.fromJson)
          .toList(),
    );
  }

  factory EscalationResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for EscalationResponse: contains complex types',
    );
  }

  final _i3.List<_i3.String> capabilities;

  final _i4.GrantResponse grant;

  final _i3.List<_i5.Entry> scopedCapabilities;

  @_i3.override
  _i3.Object? toJson() => {
    r'capabilities': capabilities,
    r'grant': grant.toJson(),
    r'scoped_capabilities': scopedCapabilities.map((e) => e.toJson()).toList(),
  };

  $$EscalationResponseCopyWith<EscalationResponse> get copyWith =>
      _EscalationResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is EscalationResponse &&
        _$deepEquals.equals(other.capabilities, this.capabilities) &&
        other.grant == this.grant &&
        _$deepEquals.equals(other.scopedCapabilities, this.scopedCapabilities);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(capabilities),
      grant,
      deepEquals.hash(scopedCapabilities),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for EscalationResponse: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode EscalationResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$EscalationResponseCopyWith<$Res> {
  factory $$EscalationResponseCopyWith(EscalationResponse value) =
      _EscalationResponseCopyWith<$Res>;

  $Res call({
    _i3.List<_i3.String>? capabilities,
    _i4.GrantResponse? grant,
    _i3.List<_i5.Entry>? scopedCapabilities,
  });
  _i3.List<_i3.String> get capabilities;
  _i4.GrantResponse get grant;
  _i3.List<_i5.Entry> get scopedCapabilities;
}

class _EscalationResponseCopyWith<$Res>
    implements $$EscalationResponseCopyWith<$Res> {
  _EscalationResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final EscalationResponse _value;

  @_i3.override
  _i3.List<_i3.String> get capabilities => _value.capabilities;

  @_i3.override
  _i4.GrantResponse get grant => _value.grant;

  @_i3.override
  _i3.List<_i5.Entry> get scopedCapabilities => _value.scopedCapabilities;

  @_i3.override
  $Res call({
    _i3.Object? capabilities = _sentinel,
    _i3.Object? grant = _sentinel,
    _i3.Object? scopedCapabilities = _sentinel,
  }) {
    return (EscalationResponse(
      capabilities: _i3.identical(capabilities, _sentinel)
          ? this.capabilities
          : (capabilities as _i3.List<_i3.String>),
      grant: _i3.identical(grant, _sentinel)
          ? this.grant
          : (grant as _i4.GrantResponse),
      scopedCapabilities: _i3.identical(scopedCapabilities, _sentinel)
          ? this.scopedCapabilities
          : (scopedCapabilities as _i3.List<_i5.Entry>),
    ) as $Res);
  }
}
