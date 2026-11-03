// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UpdateServerLimitsRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UpdateServerLimitsRequest({required this.contactImportMaxBytes});

  factory UpdateServerLimitsRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'contact_import_max_bytes'},
      listKeys: {},
      context: r'UpdateServerLimitsRequest',
    );
    return UpdateServerLimitsRequest(
      contactImportMaxBytes: _$values[r'contact_import_max_bytes']
          .decodeSimpleInt(
            context: r'UpdateServerLimitsRequest.contact_import_max_bytes',
          ),
    );
  }

  factory UpdateServerLimitsRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UpdateServerLimitsRequest');
    return UpdateServerLimitsRequest(
      contactImportMaxBytes: _$map[r'contact_import_max_bytes'].decodeJsonInt(
        context: r'UpdateServerLimitsRequest.contact_import_max_bytes',
      ),
    );
  }

  factory UpdateServerLimitsRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'contact_import_max_bytes'},
      listKeys: {},
      context: r'UpdateServerLimitsRequest',
    );
    return UpdateServerLimitsRequest(
      contactImportMaxBytes: _$values[r'contact_import_max_bytes']
          .decodeFormInt(
            context: r'UpdateServerLimitsRequest.contact_import_max_bytes',
          ),
    );
  }

  final _i3.int contactImportMaxBytes;

  @_i3.override
  _i3.Object? toJson() => {r'contact_import_max_bytes': contactImportMaxBytes};

  $$UpdateServerLimitsRequestCopyWith<UpdateServerLimitsRequest> get copyWith =>
      _UpdateServerLimitsRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerLimitsRequest &&
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
      r'Cannot uriEncode UpdateServerLimitsRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UpdateServerLimitsRequestCopyWith<$Res> {
  factory $$UpdateServerLimitsRequestCopyWith(UpdateServerLimitsRequest value) =
      _UpdateServerLimitsRequestCopyWith<$Res>;

  $Res call({_i3.int? contactImportMaxBytes});
  _i3.int get contactImportMaxBytes;
}

class _UpdateServerLimitsRequestCopyWith<$Res>
    implements $$UpdateServerLimitsRequestCopyWith<$Res> {
  _UpdateServerLimitsRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UpdateServerLimitsRequest _value;

  @_i3.override
  _i3.int get contactImportMaxBytes => _value.contactImportMaxBytes;

  @_i3.override
  $Res call({_i3.Object? contactImportMaxBytes = _sentinel}) {
    return (UpdateServerLimitsRequest(
      contactImportMaxBytes: _i3.identical(contactImportMaxBytes, _sentinel)
          ? this.contactImportMaxBytes
          : (contactImportMaxBytes as _i3.int),
    ) as $Res);
  }
}
