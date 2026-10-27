// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i9;
import 'dart:core' as _i3;

import 'package:http/http.dart' as _i5;
import 'package:restmail_generated/src/model/api_v1_admin_pipelines_logs_parameters_model.dart'
    as _i7;
import 'package:restmail_generated/src/model/api_v1_admin_pipelines_logs_parameters_model2.dart'
    as _i8;
import 'package:restmail_generated/src/model/api_v1_admin_pipelines_logs_parameters_model3.dart'
    as _i6;
import 'package:restmail_generated/src/model/error_response.dart' as _i12;
import 'package:restmail_generated/src/model/list_message_trace.dart' as _i10;
import 'package:restmail_generated/src/model/validation_error_response.dart'
    as _i16;
import 'package:restmail_generated/src/operation/http_operation.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get200_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get401_response.dart'
    as _i13;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get403_response.dart'
    as _i14;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get413_response.dart'
    as _i15;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get422_response.dart'
    as _i17;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get500_response.dart'
    as _i18;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get503_response.dart'
    as _i19;
import 'package:restmail_generated/src/response_wrapper/list_pipeline_logs_response.dart'
    as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

final class ListPipelineLogs
    extends _i1.HttpOperation<_i2.ListPipelineLogsResponse> {
  ListPipelineLogs(super.baseUrl, super.clientAccessor);

  _i3.Future<_i4.TonikResult<_i2.ListPipelineLogsResponse, _i5.Response>> call({
    _i3.int? pipelineId,
    _i3.int? limit,
    _i3.int? offset,
    _i6.ApiV1AdminPipelinesLogsParametersModel3? direction,
    _i7.ApiV1AdminPipelinesLogsParametersModel? action,
    _i8.ApiV1AdminPipelinesLogsParametersModel2? outcome,
    _i3.String? reasonCode,
    _i3.String? rfcMessageId,
    _i4.TonikCancellation? cancellation,
  }) {
    return this.execute(
      cancellation: cancellation,
      prepare: () => _i1.HttpOperationRequest(
        method: 'GET',
        path: _path(),
        query: _queryParameters(
          pipelineId: pipelineId,
          limit: limit,
          offset: offset,
          direction: direction,
          action: action,
          outcome: outcome,
          reasonCode: reasonCode,
          rfcMessageId: rfcMessageId,
        ),
        data: _data(),
        options: _options(),
      ),
      decode: _parseResponse,
    );
  }

  _i3.List<_i3.String> _path() {
    return [r'api', r'v1', r'admin', r'pipelines', r'logs'];
  }

  _i3.Object? _data() {
    return null;
  }

  _i3.String? _queryParameters({
    _i3.int? pipelineId,
    _i3.int? limit,
    _i3.int? offset,
    _i6.ApiV1AdminPipelinesLogsParametersModel3? direction,
    _i7.ApiV1AdminPipelinesLogsParametersModel? action,
    _i8.ApiV1AdminPipelinesLogsParametersModel2? outcome,
    _i3.String? reasonCode,
    _i3.String? rfcMessageId,
  }) {
    final _$entries = <_i4.ParameterEntry>[];
    if (pipelineId != null) {
      _$entries.addAll(
        pipelineId.toForm(
          r'pipeline_id',
          explode: true,
          allowEmpty: false,
          textEncoding: _i9.utf8,
        ),
      );
    }
    if (limit != null) {
      _$entries.addAll(
        limit.toForm(
          r'limit',
          explode: true,
          allowEmpty: false,
          textEncoding: _i9.utf8,
        ),
      );
    }
    if (offset != null) {
      _$entries.addAll(
        offset.toForm(
          r'offset',
          explode: true,
          allowEmpty: false,
          textEncoding: _i9.utf8,
        ),
      );
    }
    if (direction != null) {
      _$entries.addAll(
        direction.toForm(
          r'direction',
          explode: true,
          allowEmpty: false,
          textEncoding: _i9.utf8,
        ),
      );
    }
    if (action != null) {
      _$entries.addAll(
        action.toForm(
          r'action',
          explode: true,
          allowEmpty: false,
          textEncoding: _i9.utf8,
        ),
      );
    }
    if (outcome != null) {
      _$entries.addAll(
        outcome.toForm(
          r'outcome',
          explode: true,
          allowEmpty: false,
          textEncoding: _i9.utf8,
        ),
      );
    }
    if (reasonCode != null) {
      _$entries.addAll(
        reasonCode.toForm(
          r'reason_code',
          explode: true,
          allowEmpty: false,
          textEncoding: _i9.utf8,
        ),
      );
    }
    if (rfcMessageId != null) {
      _$entries.addAll(
        rfcMessageId.toForm(
          r'rfc_message_id',
          explode: true,
          allowEmpty: false,
          textEncoding: _i9.utf8,
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

  _i2.ListPipelineLogsResponse _parseResponse(_i5.Response response) {
    final _$mediaType = _i4.extractMediaType(response.headers['content-type']);
    switch ((response.statusCode, _$mediaType)) {
      case (200, r'application/json'):
        final _$json = _i4.decodeResponseJson<_i3.Object?>(response.bodyBytes);
        final _$body = _i10.ListMessageTrace.fromJson(_$json);
        return _i2.ListPipelineLogsResponse200(
          body: _i11.ApiV1AdminPipelinesLogsGet200Response(
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
        final _$body = _i12.ErrorResponse.fromJson(_$json);
        return _i2.ListPipelineLogsResponse401(
          body: _i13.ApiV1AdminPipelinesLogsGet401Response(
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
        final _$body = _i12.ErrorResponse.fromJson(_$json);
        return _i2.ListPipelineLogsResponse403(
          body: _i14.ApiV1AdminPipelinesLogsGet403Response(
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
        final _$body = _i12.ErrorResponse.fromJson(_$json);
        return _i2.ListPipelineLogsResponse413(
          body: _i15.ApiV1AdminPipelinesLogsGet413Response(
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
        return _i2.ListPipelineLogsResponse422(
          body: _i17.ApiV1AdminPipelinesLogsGet422Response(
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
        final _$body = _i12.ErrorResponse.fromJson(_$json);
        return _i2.ListPipelineLogsResponse500(
          body: _i18.ApiV1AdminPipelinesLogsGet500Response(
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
        final _$body = _i12.ErrorResponse.fromJson(_$json);
        return _i2.ListPipelineLogsResponse503(
          body: _i19.ApiV1AdminPipelinesLogsGet503Response(
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
