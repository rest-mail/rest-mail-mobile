// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:http/http.dart' as _i5;
import 'package:restmail_generated/src/model/data_contact.dart' as _i8;
import 'package:restmail_generated/src/model/error_response.dart' as _i10;
import 'package:restmail_generated/src/model/update_contact_body.dart' as _i6;
import 'package:restmail_generated/src/model/validation_error_response.dart'
    as _i16;
import 'package:restmail_generated/src/operation/http_operation.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch200_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch400_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch401_response.dart'
    as _i12;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch403_response.dart'
    as _i13;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch404_response.dart'
    as _i14;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch413_response.dart'
    as _i15;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch422_response.dart'
    as _i17;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch429_response.dart'
    as _i18;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch500_response.dart'
    as _i19;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch503_response.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/update_contact_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class UpdateContact extends _i1.HttpOperation<_i2.UpdateContactResponse> {
  UpdateContact(super.baseUrl, super.clientAccessor);

  _i3.Future<_i4.TonikResult<_i2.UpdateContactResponse, _i5.Response>> call({
    required _i6.UpdateContactBody body,
    required _i3.int id,
    required _i3.int cid,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.HttpOperationRequest(
        method: 'PATCH',
        path: _path(id: id, cid: cid),
        query: null,
        data: _data(body: body),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path({required _i3.int id, required _i3.int cid}) {
    return [
      r'api',
      r'v1',
      r'accounts',
      id.toSimple(explode: false, allowEmpty: false),
      r'contacts',
      cid.toSimple(explode: false, allowEmpty: false),
    ];
  }

  _i3.Object? _data({required _i6.UpdateContactBody body}) {
    return _i7.utf8.encode(_i7.jsonEncode(body.toJson()));
  }

  _i3.Map<_i3.String, _i3.String> _options() {
    final _$headers = <_i3.String, _i3.String>{};
    _$headers['Accept'] = r'application/json';
    _$headers[r'Content-Type'] = r'application/json';
    return _$headers;
  }

  _i2.UpdateContactResponse _parseResponse(_i5.Response response) {
    final _$mediaType = _i4.extractMediaType(response.headers['content-type']);
    switch ((response.statusCode, _$mediaType)) {
      case (200, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i8.DataContact.fromJson(_$json);
        return _i2.UpdateContactResponse200(
          body: _i9.ApiV1AccountsIdContactsCidPatch200Response(
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
        return _i2.UpdateContactResponse400(
          body: _i11.ApiV1AccountsIdContactsCidPatch400Response(
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
        return _i2.UpdateContactResponse401(
          body: _i12.ApiV1AccountsIdContactsCidPatch401Response(
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
        return _i2.UpdateContactResponse403(
          body: _i13.ApiV1AccountsIdContactsCidPatch403Response(
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
        final _$body = _i10.ErrorResponse.fromJson(_$json);
        return _i2.UpdateContactResponse404(
          body: _i14.ApiV1AccountsIdContactsCidPatch404Response(
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
        return _i2.UpdateContactResponse413(
          body: _i15.ApiV1AccountsIdContactsCidPatch413Response(
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
        final _$body = _i16.ValidationErrorResponse.fromJson(_$json);
        return _i2.UpdateContactResponse422(
          body: _i17.ApiV1AccountsIdContactsCidPatch422Response(
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
        return _i2.UpdateContactResponse429(
          body: _i18.ApiV1AccountsIdContactsCidPatch429Response(
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
        return _i2.UpdateContactResponse500(
          body: _i19.ApiV1AccountsIdContactsCidPatch500Response(
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
        return _i2.UpdateContactResponse503(
          body: _i20.ApiV1AccountsIdContactsCidPatch503Response(
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
