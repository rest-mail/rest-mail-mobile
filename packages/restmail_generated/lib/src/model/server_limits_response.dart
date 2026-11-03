// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServerLimitsResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServerLimitsResponse({required this.contactImportMaxBytes});

  factory ServerLimitsResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'contact_import_max_bytes'},
      listKeys: {},
      context: r'ServerLimitsResponse',
    );
    return ServerLimitsResponse(
      contactImportMaxBytes: _$values[r'contact_import_max_bytes']
          .decodeSimpleInt(
            context: r'ServerLimitsResponse.contact_import_max_bytes',
          ),
    );
  }

  factory ServerLimitsResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ServerLimitsResponse');
    return ServerLimitsResponse(
      contactImportMaxBytes: _$map[r'contact_import_max_bytes'].decodeJsonInt(
        context: r'ServerLimitsResponse.contact_import_max_bytes',
      ),
    );
  }

  factory ServerLimitsResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'contact_import_max_bytes'},
      listKeys: {},
      context: r'ServerLimitsResponse',
    );
    return ServerLimitsResponse(
      contactImportMaxBytes: _$values[r'contact_import_max_bytes']
          .decodeFormInt(
            context: r'ServerLimitsResponse.contact_import_max_bytes',
          ),
    );
  }

  /// **Example**:
  /// ```json
  /// 10485760
  /// ```
  final _i3.int contactImportMaxBytes;

  @_i3.override
  _i3.Object? toJson() => {r'contact_import_max_bytes': contactImportMaxBytes};

  $$ServerLimitsResponseCopyWith<ServerLimitsResponse> get copyWith =>
      _ServerLimitsResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServerLimitsResponse &&
        other.contactImportMaxBytes == this.contactImportMaxBytes;
  }

  @_i3.override
  _i3.int get hashCode => contactImportMaxBytes.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'contact_import_max_bytes'] = _i1.PropertyValue.scalar(
      contactImportMaxBytes.toString(),
    );
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
      r'Cannot uriEncode ServerLimitsResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ServerLimitsResponseCopyWith<$Res> {
  factory $$ServerLimitsResponseCopyWith(ServerLimitsResponse value) =
      _ServerLimitsResponseCopyWith<$Res>;

  $Res call({_i3.int? contactImportMaxBytes});
  _i3.int get contactImportMaxBytes;
}

class _ServerLimitsResponseCopyWith<$Res>
    implements $$ServerLimitsResponseCopyWith<$Res> {
  _ServerLimitsResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ServerLimitsResponse _value;

  @_i3.override
  _i3.int get contactImportMaxBytes => _value.contactImportMaxBytes;

  @_i3.override
  $Res call({_i3.Object? contactImportMaxBytes = _sentinel}) {
    return (ServerLimitsResponse(
      contactImportMaxBytes: _i3.identical(contactImportMaxBytes, _sentinel)
          ? this.contactImportMaxBytes
          : (contactImportMaxBytes as _i3.int),
    ) as $Res);
  }
}
