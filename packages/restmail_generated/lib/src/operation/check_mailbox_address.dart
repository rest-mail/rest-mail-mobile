// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:http/http.dart' as _i5;
import 'package:restmail_generated/src/model/data_address_check.dart' as _i7;
import 'package:restmail_generated/src/model/error_response.dart' as _i8;
import 'package:restmail_generated/src/model/validation_error_response.dart'
    as _i9;
import 'package:restmail_generated/src/operation/http_operation.dart' as _i1;
import 'package:restmail_generated/src/response_wrapper/check_mailbox_address_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class CheckMailboxAddress
    extends _i1.HttpOperation<_i2.CheckMailboxAddressResponse> {
  CheckMailboxAddress(super.baseUrl, super.clientAccessor);

  _i3.Future<_i4.TonikResult<_i2.CheckMailboxAddressResponse, _i5.Response>>
  call({required _i3.String address, _i4.TonikCancellation? cancellation}) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.HttpOperationRequest(
        method: 'GET',
        path: _path(),
        query: _queryParameters(address: address),
        data: _data(),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path() {
    return [r'api', r'mailboxes'];
  }

  _i3.Object? _data() {
    return null;
  }

  _i3.String? _queryParameters({required _i3.String address}) {
    final _$entries = <_i4.ParameterEntry>[];
    _$entries.addAll(
      address.toForm(
        r'address',
        explode: true,
        allowEmpty: false,
        textEncoding: _i6.utf8,
      ),
    );
    if (_$entries.isEmpty) {
      return null;
    }
    return _$entries
        .map((e) => e.name.isEmpty ? e.value : '${e.name}=${e.value}')
        .join('&');
  }

  _i3.Map<_i3.String, _i3.String> _options() {
    final _$headers = <_i3.String, _i3.String>{};
    _$headers['Accept'] = r'application/json';
    return _$headers;
  }

  _i2.CheckMailboxAddressResponse _parseResponse(_i5.Response response) {
    final _$mediaType = _i4.extractMediaType(response.headers['content-type']);
    switch ((response.statusCode, _$mediaType)) {
      case (200, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i7.DataAddressCheck.fromJson(_$json);
        return _i2.CheckMailboxAddressResponse200(body: _$body);
      case (400, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i8.ErrorResponse.fromJson(_$json);
        return _i2.CheckMailboxAddressResponse400(body: _$body);
      case (422, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i9.ValidationErrorResponse.fromJson(_$json);
        return _i2.CheckMailboxAddressResponse422(body: _$body);
      case (500, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i8.ErrorResponse.fromJson(_$json);
        return _i2.CheckMailboxAddressResponse500(body: _$body);
      default:
        final _$content = response.headers['content-type'] ?? 'not specified';
        final _$matched = _$mediaType ?? 'none';
        final _$status = response.statusCode;
        throw _i4.ResponseDecodingException(
          'Unexpected content type: ${_$content} (matched as: ${_$matched}) for status code: ${_$status}',
        );
    }
  }
}
