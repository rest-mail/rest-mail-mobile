// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:http/http.dart' as _i5;
import 'package:restmail_generated/src/model/disable_request.dart' as _i6;
import 'package:restmail_generated/src/model/error_response.dart' as _i9;
import 'package:restmail_generated/src/model/validation_error_response.dart'
    as _i14;
import 'package:restmail_generated/src/operation/http_operation.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post204_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post400_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post401_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post403_response.dart'
    as _i12;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post413_response.dart'
    as _i13;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post422_response.dart'
    as _i15;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post429_response.dart'
    as _i16;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post500_response.dart'
    as _i17;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post503_response.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/disable_two_factor_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class DisableTwoFactor
    extends _i1.HttpOperation<_i2.DisableTwoFactorResponse> {
  DisableTwoFactor(super.baseUrl, super.clientAccessor);

  _i3.Future<_i4.TonikResult<_i2.DisableTwoFactorResponse, _i5.Response>> call({
    required _i6.DisableRequest body,
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
    return [r'api', r'v1', r'auth', r'2fa', r'disable'];
  }

  _i3.Object? _data({required _i6.DisableRequest body}) {
    return _i7.utf8.encode(_i7.jsonEncode(body.toJson()));
  }

  _i3.Map<_i3.String, _i3.String> _options() {
    final _$headers = <_i3.String, _i3.String>{};
    _$headers['Accept'] = r'application/json';
    _$headers[r'Content-Type'] = r'application/json';
    return _$headers;
  }

  _i2.DisableTwoFactorResponse _parseResponse(_i5.Response response) {
    final _$mediaType = _i4.extractMediaType(response.headers['content-type']);
    switch ((response.statusCode, _$mediaType)) {
      case (204, _):
        return _i2.DisableTwoFactorResponse204(
          body: _i8.ApiV1Auth2faDisablePost204Response(
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
        final _$body = _i9.ErrorResponse.fromJson(_$json);
        return _i2.DisableTwoFactorResponse400(
          body: _i10.ApiV1Auth2faDisablePost400Response(
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
        final _$body = _i9.ErrorResponse.fromJson(_$json);
        return _i2.DisableTwoFactorResponse401(
          body: _i11.ApiV1Auth2faDisablePost401Response(
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
        final _$body = _i9.ErrorResponse.fromJson(_$json);
        return _i2.DisableTwoFactorResponse403(
          body: _i12.ApiV1Auth2faDisablePost403Response(
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
        final _$body = _i9.ErrorResponse.fromJson(_$json);
        return _i2.DisableTwoFactorResponse413(
          body: _i13.ApiV1Auth2faDisablePost413Response(
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
        return _i2.DisableTwoFactorResponse422(
          body: _i15.ApiV1Auth2faDisablePost422Response(
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
        final _$body = _i9.ErrorResponse.fromJson(_$json);
        return _i2.DisableTwoFactorResponse429(
          body: _i16.ApiV1Auth2faDisablePost429Response(
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
        final _$body = _i9.ErrorResponse.fromJson(_$json);
        return _i2.DisableTwoFactorResponse500(
          body: _i17.ApiV1Auth2faDisablePost500Response(
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
        final _$body = _i9.ErrorResponse.fromJson(_$json);
        return _i2.DisableTwoFactorResponse503(
          body: _i18.ApiV1Auth2faDisablePost503Response(
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
