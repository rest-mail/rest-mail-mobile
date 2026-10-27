// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/credential_response.dart' as _i4;
import 'package:restmail_generated/src/model/list_credential_response_pagination_one_of_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ListCredentialResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ListCredentialResponse({required this.data, this.pagination});

  factory ListCredentialResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ListCredentialResponse: contains complex types',
    );
  }

  factory ListCredentialResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ListCredentialResponse');
    return ListCredentialResponse(
      data: _$map[r'data']
          .decodeJsonList<_i3.Object?>(context: r'ListCredentialResponse.data')
          .map(_i4.CredentialResponse.fromJson)
          .toList(),
      pagination: _$map[r'pagination'] == null
          ? null
          : _i5.ListCredentialResponsePaginationOneOfModel.fromJson(
              _$map[r'pagination'],
            ),
    );
  }

  factory ListCredentialResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ListCredentialResponse: contains complex types',
    );
  }

  final _i3.List<_i4.CredentialResponse> data;

  final _i5.ListCredentialResponsePaginationOneOfModel? pagination;

  @_i3.override
  _i3.Object? toJson() => {
    r'data': data.map((e) => e.toJson()).toList(),
    if (pagination != null) r'pagination': pagination?.toJson(),
  };

  $$ListCredentialResponseCopyWith<ListCredentialResponse> get copyWith =>
      _ListCredentialResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is ListCredentialResponse &&
        _$deepEquals.equals(other.data, this.data) &&
        other.pagination == this.pagination;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([deepEquals.hash(data), pagination]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ListCredentialResponse: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ListCredentialResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ListCredentialResponseCopyWith<$Res> {
  factory $$ListCredentialResponseCopyWith(ListCredentialResponse value) =
      _ListCredentialResponseCopyWith<$Res>;

  $Res call({
    _i3.List<_i4.CredentialResponse>? data,
    _i5.ListCredentialResponsePaginationOneOfModel? pagination,
  });
  _i3.List<_i4.CredentialResponse> get data;
  _i5.ListCredentialResponsePaginationOneOfModel? get pagination;
}

class _ListCredentialResponseCopyWith<$Res>
    implements $$ListCredentialResponseCopyWith<$Res> {
  _ListCredentialResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ListCredentialResponse _value;

  @_i3.override
  _i3.List<_i4.CredentialResponse> get data => _value.data;

  @_i3.override
  _i5.ListCredentialResponsePaginationOneOfModel? get pagination =>
      _value.pagination;

  @_i3.override
  $Res call({
    _i3.Object? data = _sentinel,
    _i3.Object? pagination = _sentinel,
  }) {
    return (ListCredentialResponse(
      data: _i3.identical(data, _sentinel)
          ? this.data
          : (data as _i3.List<_i4.CredentialResponse>),
      pagination: _i3.identical(pagination, _sentinel)
          ? this.pagination
          : (pagination as _i5.ListCredentialResponsePaginationOneOfModel?),
    ) as $Res);
  }
}
