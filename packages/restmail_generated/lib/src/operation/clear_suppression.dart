// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:http/http.dart' as _i5;
import 'package:restmail_generated/src/model/error_response.dart' as _i7;
import 'package:restmail_generated/src/model/validation_error_response.dart'
    as _i12;
import 'package:restmail_generated/src/operation/http_operation.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete204_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete401_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete403_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete404_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete413_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete422_response.dart'
    as _i13;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete500_response.dart'
    as _i14;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete503_response.dart'
    as _i15;
import 'package:restmail_generated/src/response_wrapper/clear_suppression_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class ClearSuppression
    extends _i1.HttpOperation<_i2.ClearSuppressionResponse> {
  ClearSuppression(super.baseUrl, super.clientAccessor);

  _i3.Future<_i4.TonikResult<_i2.ClearSuppressionResponse, _i5.Response>> call({
    required _i3.int id,
    required _i3.int sid,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.HttpOperationRequest(
        method: 'DELETE',
        path: _path(id: id, sid: sid),
        query: null,
        data: _data(),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path({required _i3.int id, required _i3.int sid}) {
    return [
      r'api',
      r'v1',
      r'admin',
      r'domains',
      id.toSimple(explode: false, allowEmpty: false),
      r'suppressions',
      sid.toSimple(explode: false, allowEmpty: false),
    ];
  }

  _i3.Object? _data() {
    return null;
  }

  _i3.Map<_i3.String, _i3.String> _options() {
    final _$headers = <_i3.String, _i3.String>{};
    _$headers['Accept'] = r'application/json';
    return _$headers;
  }

  _i2.ClearSuppressionResponse _parseResponse(_i5.Response response) {
    final _$mediaType = _i4.extractMediaType(response.headers['content-type']);
    switch ((response.statusCode, _$mediaType)) {
      case (204, _):
        return _i2.ClearSuppressionResponse204(
          body: _i6.ApiV1AdminDomainsIdSuppressionsSidDelete204Response(
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
        final _$body = _i7.ErrorResponse.fromJson(_$json);
        return _i2.ClearSuppressionResponse401(
          body: _i8.ApiV1AdminDomainsIdSuppressionsSidDelete401Response(
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
        final _$body = _i7.ErrorResponse.fromJson(_$json);
        return _i2.ClearSuppressionResponse403(
          body: _i9.ApiV1AdminDomainsIdSuppressionsSidDelete403Response(
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
      case (404, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i7.ErrorResponse.fromJson(_$json);
        return _i2.ClearSuppressionResponse404(
          body: _i10.ApiV1AdminDomainsIdSuppressionsSidDelete404Response(
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
        final _$body = _i7.ErrorResponse.fromJson(_$json);
        return _i2.ClearSuppressionResponse413(
          body: _i11.ApiV1AdminDomainsIdSuppressionsSidDelete413Response(
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
        final _$body = _i12.ValidationErrorResponse.fromJson(_$json);
        return _i2.ClearSuppressionResponse422(
          body: _i13.ApiV1AdminDomainsIdSuppressionsSidDelete422Response(
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
        final _$body = _i7.ErrorResponse.fromJson(_$json);
        return _i2.ClearSuppressionResponse500(
          body: _i14.ApiV1AdminDomainsIdSuppressionsSidDelete500Response(
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
        final _$body = _i7.ErrorResponse.fromJson(_$json);
        return _i2.ClearSuppressionResponse503(
          body: _i15.ApiV1AdminDomainsIdSuppressionsSidDelete503Response(
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
