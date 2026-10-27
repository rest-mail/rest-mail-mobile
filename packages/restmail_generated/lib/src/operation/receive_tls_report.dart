// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:http/http.dart' as _i5;
import 'package:restmail_generated/src/model/data_tls_report_stored.dart'
    as _i8;
import 'package:restmail_generated/src/model/error_response.dart' as _i10;
import 'package:restmail_generated/src/model/tls_report_unprocessable.dart'
    as _i14;
import 'package:restmail_generated/src/operation/http_operation.dart' as _i1;
import 'package:restmail_generated/src/request_body/well_known_smtp_tlsrpt_post_body_request_body.dart'
    as _i6;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post201_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post400_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post413_response.dart'
    as _i12;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post415_response.dart'
    as _i13;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post422_response.dart'
    as _i15;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post429_response.dart'
    as _i16;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post500_response.dart'
    as _i17;
import 'package:restmail_generated/src/response_wrapper/receive_tls_report_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class ReceiveTlsReport
    extends _i1.HttpOperation<_i2.ReceiveTlsReportResponse> {
  ReceiveTlsReport(super.baseUrl, super.clientAccessor);

  _i3.Future<_i4.TonikResult<_i2.ReceiveTlsReportResponse, _i5.Response>> call({
    required _i6.WellKnownSmtpTlsrptPostBodyRequestBody body,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.HttpOperationRequest(
        method: 'POST',
        path: _path(),
        query: null,
        data: _data(body: body),
        options: _options(body: body),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path() {
    return [r'.well-known', r'smtp-tlsrpt'];
  }

  _i3.Object? _data({
    required _i6.WellKnownSmtpTlsrptPostBodyRequestBody body,
  }) {
    return switch (body) {
      final _i6.WellKnownSmtpTlsrptPostBodyRequestBodyJson value =>
        _i7.utf8.encode(_i7.jsonEncode(value.value.toJson())),
      final _i6.WellKnownSmtpTlsrptPostBodyRequestBodyTlsrptGzip value =>
        value.value.toBytes(),
      final _i6.WellKnownSmtpTlsrptPostBodyRequestBodyTlsrptJson value =>
        _i7.utf8.encode(_i7.jsonEncode(value.value.toJson())),
    };
  }

  _i3.Map<_i3.String, _i3.String> _options({
    required _i6.WellKnownSmtpTlsrptPostBodyRequestBody body,
  }) {
    final _$contentType = switch (body) {
      _i6.WellKnownSmtpTlsrptPostBodyRequestBodyJson _ => r'application/json',

      _i6.WellKnownSmtpTlsrptPostBodyRequestBodyTlsrptGzip _ =>
        r'application/tlsrpt+gzip',

      _i6.WellKnownSmtpTlsrptPostBodyRequestBodyTlsrptJson _ =>
        r'application/tlsrpt+json',
    };
    final _$headers = <_i3.String, _i3.String>{};
    _$headers['Accept'] = r'application/json';
    _$headers[r'Content-Type'] = _$contentType;
    return _$headers;
  }

  _i2.ReceiveTlsReportResponse _parseResponse(_i5.Response response) {
    final _$mediaType = _i4.extractMediaType(response.headers['content-type']);
    switch ((response.statusCode, _$mediaType)) {
      case (201, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i8.DataTlsReportStored.fromJson(_$json);
        return _i2.ReceiveTlsReportResponse201(
          body: _i9.WellKnownSmtpTlsrptPost201Response(
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
      case (400, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.ReceiveTlsReportResponse400(
          body: _i11.WellKnownSmtpTlsrptPost400Response(
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
        return _i2.ReceiveTlsReportResponse413(
          body: _i12.WellKnownSmtpTlsrptPost413Response(
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
      case (415, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.ReceiveTlsReportResponse415(
          body: _i13.WellKnownSmtpTlsrptPost415Response(
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
        final _$body = _i14.TlsReportUnprocessable.fromJson(_$json);
        return _i2.ReceiveTlsReportResponse422(
          body: _i15.WellKnownSmtpTlsrptPost422Response(
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
      case (429, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.ReceiveTlsReportResponse429(
          body: _i16.WellKnownSmtpTlsrptPost429Response(
            body: _$body,
            contentSecurityPolicy:
                (response.headersSplitValues[r'content-security-policy']?.join(
                  ',',
                )).decodeSimpleString(context: r'Content-Security-Policy'),
            referrerPolicy:
                (response.headersSplitValues[r'referrer-policy']?.join(','))
                    .decodeSimpleString(context: r'Referrer-Policy'),
            retryAfter: (response.headersSplitValues[r'retry-after']?.join(','))
                .decodeSimpleInt(context: r'Retry-After'),
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
        return _i2.ReceiveTlsReportResponse500(
          body: _i17.WellKnownSmtpTlsrptPost500Response(
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
