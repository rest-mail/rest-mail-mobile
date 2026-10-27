// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:http/http.dart' as _i5;
import 'package:restmail_generated/src/model/data_delivery_processed.dart'
    as _i8;
import 'package:restmail_generated/src/model/data_message.dart' as _i9;
import 'package:restmail_generated/src/model/deliver_message_body.dart' as _i6;
import 'package:restmail_generated/src/model/error_response.dart' as _i10;
import 'package:restmail_generated/src/model/validation_error_response.dart'
    as _i11;
import 'package:restmail_generated/src/operation/http_operation.dart' as _i1;
import 'package:restmail_generated/src/response_wrapper/deliver_message_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class DeliverMessage
    extends _i1.HttpOperation<_i2.DeliverMessageResponse> {
  DeliverMessage(super.baseUrl, super.clientAccessor);

  _i3.Future<_i4.TonikResult<_i2.DeliverMessageResponse, _i5.Response>> call({
    required _i6.DeliverMessageBody body,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.HttpOperationRequest(
        method: 'POST',
        path: _path(),
        query: null,
        data: _data(body: body),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path() {
    return [r'api', r'v1', r'messages', r'deliver'];
  }

  _i3.Object? _data({required _i6.DeliverMessageBody body}) {
    return _i7.utf8.encode(_i7.jsonEncode(body.toJson()));
  }

  _i3.Map<_i3.String, _i3.String> _options() {
    final _$headers = <_i3.String, _i3.String>{};
    _$headers['Accept'] = r'application/json';
    _$headers[r'Content-Type'] = r'application/json';
    return _$headers;
  }

  _i2.DeliverMessageResponse _parseResponse(_i5.Response response) {
    final _$mediaType = _i4.extractMediaType(response.headers['content-type']);
    switch ((response.statusCode, _$mediaType)) {
      case (200, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i8.DataDeliveryProcessed.fromJson(_$json);
        return _i2.DeliverMessageResponse200(body: _$body);
      case (201, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i9.DataMessage.fromJson(_$json);
        return _i2.DeliverMessageResponse201(body: _$body);
      case (400, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.DeliverMessageResponse400(body: _$body);
      case (404, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.DeliverMessageResponse404(body: _$body);
      case (413, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.DeliverMessageResponse413(body: _$body);
      case (422, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i11.ValidationErrorResponse.fromJson(_$json);
        return _i2.DeliverMessageResponse422(body: _$body);
      case (451, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.DeliverMessageResponse451(body: _$body);
      case (500, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.DeliverMessageResponse500(body: _$body);
      case (550, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.DeliverMessageResponse550(body: _$body);
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
