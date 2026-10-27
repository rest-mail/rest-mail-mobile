// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:http/http.dart' as _i5;
import 'package:restmail_generated/src/model/api_v1_admin_audit_parameters_model.dart'
    as _i6;
import 'package:restmail_generated/src/model/api_v1_admin_audit_parameters_model2.dart'
    as _i7;
import 'package:restmail_generated/src/model/error_response.dart' as _i11;
import 'package:restmail_generated/src/model/list_audit_entry.dart' as _i9;
import 'package:restmail_generated/src/model/validation_error_response.dart'
    as _i15;
import 'package:restmail_generated/src/operation/http_operation.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get200_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get401_response.dart'
    as _i12;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get403_response.dart'
    as _i13;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get413_response.dart'
    as _i14;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get422_response.dart'
    as _i16;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get500_response.dart'
    as _i17;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get503_response.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/list_audit_entries_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class ListAuditEntries
    extends _i1.HttpOperation<_i2.ListAuditEntriesResponse> {
  ListAuditEntries(super.baseUrl, super.clientAccessor);

  _i3.Future<_i4.TonikResult<_i2.ListAuditEntriesResponse, _i5.Response>> call({
    _i6.ApiV1AdminAuditParametersModel? actorKind,
    _i3.int? actorId,
    _i3.String? actor,
    _i3.String? action,
    _i7.ApiV1AdminAuditParametersModel2? outcome,
    _i3.DateTime? since,
    _i3.DateTime? until,
    _i3.int? beforeSeq,
    _i3.int? limit,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.HttpOperationRequest(
        method: 'GET',
        path: _path(),
        query: _queryParameters(
          actorKind: actorKind,
          actorId: actorId,
          actor: actor,
          action: action,
          outcome: outcome,
          since: since,
          until: until,
          beforeSeq: beforeSeq,
          limit: limit,
        ),
        data: _data(),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path() {
    return [r'api', r'v1', r'admin', r'audit'];
  }

  _i3.Object? _data() {
    return null;
  }

  _i3.String? _queryParameters({
    _i6.ApiV1AdminAuditParametersModel? actorKind,
    _i3.int? actorId,
    _i3.String? actor,
    _i3.String? action,
    _i7.ApiV1AdminAuditParametersModel2? outcome,
    _i3.DateTime? since,
    _i3.DateTime? until,
    _i3.int? beforeSeq,
    _i3.int? limit,
  }) {
    final _$entries = <_i4.ParameterEntry>[];
    if (actorKind != null) {
      _$entries.addAll(
        actorKind.toForm(
          r'actor_kind',
          explode: true,
          allowEmpty: false,
          textEncoding: _i8.utf8,
        ),
      );
    }
    if (actorId != null) {
      _$entries.addAll(
        actorId.toForm(
          r'actor_id',
          explode: true,
          allowEmpty: false,
          textEncoding: _i8.utf8,
        ),
      );
    }
    if (actor != null) {
      _$entries.addAll(
        actor.toForm(
          r'actor',
          explode: true,
          allowEmpty: false,
          textEncoding: _i8.utf8,
        ),
      );
    }
    if (action != null) {
      _$entries.addAll(
        action.toForm(
          r'action',
          explode: true,
          allowEmpty: false,
          textEncoding: _i8.utf8,
        ),
      );
    }
    if (outcome != null) {
      _$entries.addAll(
        outcome.toForm(
          r'outcome',
          explode: true,
          allowEmpty: false,
          textEncoding: _i8.utf8,
        ),
      );
    }
    if (since != null) {
      _$entries.addAll(
        since.toForm(
          r'since',
          explode: true,
          allowEmpty: false,
          textEncoding: _i8.utf8,
        ),
      );
    }
    if (until != null) {
      _$entries.addAll(
        until.toForm(
          r'until',
          explode: true,
          allowEmpty: false,
          textEncoding: _i8.utf8,
        ),
      );
    }
    if (beforeSeq != null) {
      _$entries.addAll(
        beforeSeq.toForm(
          r'before_seq',
          explode: true,
          allowEmpty: false,
          textEncoding: _i8.utf8,
        ),
      );
    }
    if (limit != null) {
      _$entries.addAll(
        limit.toForm(
          r'limit',
          explode: true,
          allowEmpty: false,
          textEncoding: _i8.utf8,
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

  _i2.ListAuditEntriesResponse _parseResponse(_i5.Response response) {
    final _$mediaType = _i4.extractMediaType(response.headers['content-type']);
    switch ((response.statusCode, _$mediaType)) {
      case (200, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i9.ListAuditEntry.fromJson(_$json);
        return _i2.ListAuditEntriesResponse200(
          body: _i10.ApiV1AdminAuditGet200Response(
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
        final _$body = _i11.ErrorResponse.fromJson(_$json);
        return _i2.ListAuditEntriesResponse401(
          body: _i12.ApiV1AdminAuditGet401Response(
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
        final _$body = _i11.ErrorResponse.fromJson(_$json);
        return _i2.ListAuditEntriesResponse403(
          body: _i13.ApiV1AdminAuditGet403Response(
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
        final _$body = _i11.ErrorResponse.fromJson(_$json);
        return _i2.ListAuditEntriesResponse413(
          body: _i14.ApiV1AdminAuditGet413Response(
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
        final _$body = _i15.ValidationErrorResponse.fromJson(_$json);
        return _i2.ListAuditEntriesResponse422(
          body: _i16.ApiV1AdminAuditGet422Response(
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
        final _$body = _i11.ErrorResponse.fromJson(_$json);
        return _i2.ListAuditEntriesResponse500(
          body: _i17.ApiV1AdminAuditGet500Response(
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
        final _$body = _i11.ErrorResponse.fromJson(_$json);
        return _i2.ListAuditEntriesResponse503(
          body: _i18.ApiV1AdminAuditGet503Response(
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
