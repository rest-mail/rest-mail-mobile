// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:http/http.dart' as _i5;
import 'package:restmail_generated/src/model/api_v1_admin_logs_delivery_parameters_model.dart'
    as _i6;
import 'package:restmail_generated/src/model/error_response.dart' as _i10;
import 'package:restmail_generated/src/model/list_delivery_log_entry.dart'
    as _i8;
import 'package:restmail_generated/src/model/validation_error_response.dart'
    as _i14;
import 'package:restmail_generated/src/operation/http_operation.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get200_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get401_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get403_response.dart'
    as _i12;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get413_response.dart'
    as _i13;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get422_response.dart'
    as _i15;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get500_response.dart'
    as _i16;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get503_response.dart'
    as _i17;
import 'package:restmail_generated/src/response_wrapper/get_delivery_logs_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class GetDeliveryLogs
    extends _i1.HttpOperation<_i2.GetDeliveryLogsResponse> {
  GetDeliveryLogs(super.baseUrl, super.clientAccessor);

  _i3.Future<_i4.TonikResult<_i2.GetDeliveryLogsResponse, _i5.Response>> call({
    _i3.int? limit,
    _i3.int? offset,
    _i6.ApiV1AdminLogsDeliveryParametersModel? status,
    _i3.String? domain,
    _i3.String? sender,
    _i3.String? recipient,
    _i3.DateTime? since,
    _i3.DateTime? until,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.HttpOperationRequest(
        method: 'GET',
        path: _path(),
        query: _queryParameters(
          limit: limit,
          offset: offset,
          status: status,
          domain: domain,
          sender: sender,
          recipient: recipient,
          since: since,
          until: until,
        ),
        data: _data(),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path() {
    return [r'api', r'v1', r'admin', r'logs', r'delivery'];
  }

  _i3.Object? _data() {
    return null;
  }

  _i3.String? _queryParameters({
    _i3.int? limit,
    _i3.int? offset,
    _i6.ApiV1AdminLogsDeliveryParametersModel? status,
    _i3.String? domain,
    _i3.String? sender,
    _i3.String? recipient,
    _i3.DateTime? since,
    _i3.DateTime? until,
  }) {
    final _$entries = <_i4.ParameterEntry>[];
    if (limit != null) {
      _$entries.addAll(
        limit.toForm(
          r'limit',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (offset != null) {
      _$entries.addAll(
        offset.toForm(
          r'offset',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (status != null) {
      _$entries.addAll(
        status.toForm(
          r'status',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (domain != null) {
      _$entries.addAll(
        domain.toForm(
          r'domain',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (sender != null) {
      _$entries.addAll(
        sender.toForm(
          r'sender',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (recipient != null) {
      _$entries.addAll(
        recipient.toForm(
          r'recipient',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (since != null) {
      _$entries.addAll(
        since.toForm(
          r'since',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
    if (until != null) {
      _$entries.addAll(
        until.toForm(
          r'until',
          explode: true,
          allowEmpty: false,
          textEncoding: _i7.utf8,
        ),
      );
    }
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

  _i2.GetDeliveryLogsResponse _parseResponse(_i5.Response response) {
    final _$mediaType = _i4.extractMediaType(response.headers['content-type']);
    switch ((response.statusCode, _$mediaType)) {
      case (200, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i8.ListDeliveryLogEntry.fromJson(_$json);
        return _i2.GetDeliveryLogsResponse200(
          body: _i9.ApiV1AdminLogsDeliveryGet200Response(
            body: _$body,
            contentSecurityPolicy:
                (response.headersSplitValues[r'content-security-policy']?.join(
                  ',',
                )).decodeSimpleString(context: r'Content-Security-Policy'),
            referrerPolicy:
                (response.headersSplitValues[r'referrer-policy']?.join(','))
                    .decodeSimpleString(context: r'Referrer-Policy'),
            strictTransportSecurity:
                (response.headersSplitValues[r'strict-transport-security']
                        ?.join(','))
                    .decodeSimpleString(context: r'Strict-Transport-Security'),
            xContentTypeOptions:
                (response.headersSplitValues[r'x-content-type-options']?.join(
                  ',',
                )).decodeSimpleString(context: r'X-Content-Type-Options'),
            xFrameOptions:
                (response.headersSplitValues[r'x-frame-options']?.join(','))
                    .decodeSimpleString(context: r'X-Frame-Options'),
          ),
        );
      case (401, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.GetDeliveryLogsResponse401(
          body: _i11.ApiV1AdminLogsDeliveryGet401Response(
            body: _$body,
            contentSecurityPolicy:
                (response.headersSplitValues[r'content-security-policy']?.join(
                  ',',
                )).decodeSimpleString(context: r'Content-Security-Policy'),
            referrerPolicy:
                (response.headersSplitValues[r'referrer-policy']?.join(','))
                    .decodeSimpleString(context: r'Referrer-Policy'),
            strictTransportSecurity:
                (response.headersSplitValues[r'strict-transport-security']
                        ?.join(','))
                    .decodeSimpleString(context: r'Strict-Transport-Security'),
            xContentTypeOptions:
                (response.headersSplitValues[r'x-content-type-options']?.join(
                  ',',
                )).decodeSimpleString(context: r'X-Content-Type-Options'),
            xFrameOptions:
                (response.headersSplitValues[r'x-frame-options']?.join(','))
                    .decodeSimpleString(context: r'X-Frame-Options'),
          ),
        );
      case (403, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.GetDeliveryLogsResponse403(
          body: _i12.ApiV1AdminLogsDeliveryGet403Response(
            body: _$body,
            contentSecurityPolicy:
                (response.headersSplitValues[r'content-security-policy']?.join(
                  ',',
                )).decodeSimpleString(context: r'Content-Security-Policy'),
            referrerPolicy:
                (response.headersSplitValues[r'referrer-policy']?.join(','))
                    .decodeSimpleString(context: r'Referrer-Policy'),
            strictTransportSecurity:
                (response.headersSplitValues[r'strict-transport-security']
                        ?.join(','))
                    .decodeSimpleString(context: r'Strict-Transport-Security'),
            xContentTypeOptions:
                (response.headersSplitValues[r'x-content-type-options']?.join(
                  ',',
                )).decodeSimpleString(context: r'X-Content-Type-Options'),
            xFrameOptions:
                (response.headersSplitValues[r'x-frame-options']?.join(','))
                    .decodeSimpleString(context: r'X-Frame-Options'),
          ),
        );
      case (413, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.GetDeliveryLogsResponse413(
          body: _i13.ApiV1AdminLogsDeliveryGet413Response(
            body: _$body,
            contentSecurityPolicy:
                (response.headersSplitValues[r'content-security-policy']?.join(
                  ',',
                )).decodeSimpleString(context: r'Content-Security-Policy'),
            referrerPolicy:
                (response.headersSplitValues[r'referrer-policy']?.join(','))
                    .decodeSimpleString(context: r'Referrer-Policy'),
            strictTransportSecurity:
                (response.headersSplitValues[r'strict-transport-security']
                        ?.join(','))
                    .decodeSimpleString(context: r'Strict-Transport-Security'),
            xContentTypeOptions:
                (response.headersSplitValues[r'x-content-type-options']?.join(
                  ',',
                )).decodeSimpleString(context: r'X-Content-Type-Options'),
            xFrameOptions:
                (response.headersSplitValues[r'x-frame-options']?.join(','))
                    .decodeSimpleString(context: r'X-Frame-Options'),
          ),
        );
      case (422, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i14.ValidationErrorResponse.fromJson(_$json);
        return _i2.GetDeliveryLogsResponse422(
          body: _i15.ApiV1AdminLogsDeliveryGet422Response(
            body: _$body,
            contentSecurityPolicy:
                (response.headersSplitValues[r'content-security-policy']?.join(
                  ',',
                )).decodeSimpleString(context: r'Content-Security-Policy'),
            referrerPolicy:
                (response.headersSplitValues[r'referrer-policy']?.join(','))
                    .decodeSimpleString(context: r'Referrer-Policy'),
            strictTransportSecurity:
                (response.headersSplitValues[r'strict-transport-security']
                        ?.join(','))
                    .decodeSimpleString(context: r'Strict-Transport-Security'),
            xContentTypeOptions:
                (response.headersSplitValues[r'x-content-type-options']?.join(
                  ',',
                )).decodeSimpleString(context: r'X-Content-Type-Options'),
            xFrameOptions:
                (response.headersSplitValues[r'x-frame-options']?.join(','))
                    .decodeSimpleString(context: r'X-Frame-Options'),
          ),
        );
      case (500, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.GetDeliveryLogsResponse500(
          body: _i16.ApiV1AdminLogsDeliveryGet500Response(
            body: _$body,
            contentSecurityPolicy:
                (response.headersSplitValues[r'content-security-policy']?.join(
                  ',',
                )).decodeSimpleString(context: r'Content-Security-Policy'),
            referrerPolicy:
                (response.headersSplitValues[r'referrer-policy']?.join(','))
                    .decodeSimpleString(context: r'Referrer-Policy'),
            strictTransportSecurity:
                (response.headersSplitValues[r'strict-transport-security']
                        ?.join(','))
                    .decodeSimpleString(context: r'Strict-Transport-Security'),
            xContentTypeOptions:
                (response.headersSplitValues[r'x-content-type-options']?.join(
                  ',',
                )).decodeSimpleString(context: r'X-Content-Type-Options'),
            xFrameOptions:
                (response.headersSplitValues[r'x-frame-options']?.join(','))
                    .decodeSimpleString(context: r'X-Frame-Options'),
          ),
        );
      case (503, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.GetDeliveryLogsResponse503(
          body: _i17.ApiV1AdminLogsDeliveryGet503Response(
            body: _$body,
            contentSecurityPolicy:
                (response.headersSplitValues[r'content-security-policy']?.join(
                  ',',
                )).decodeSimpleString(context: r'Content-Security-Policy'),
            referrerPolicy:
                (response.headersSplitValues[r'referrer-policy']?.join(','))
                    .decodeSimpleString(context: r'Referrer-Policy'),
            strictTransportSecurity:
                (response.headersSplitValues[r'strict-transport-security']
                        ?.join(','))
                    .decodeSimpleString(context: r'Strict-Transport-Security'),
            xContentTypeOptions:
                (response.headersSplitValues[r'x-content-type-options']?.join(
                  ',',
                )).decodeSimpleString(context: r'X-Content-Type-Options'),
            xFrameOptions:
                (response.headersSplitValues[r'x-frame-options']?.join(','))
                    .decodeSimpleString(context: r'X-Frame-Options'),
          ),
        );
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
