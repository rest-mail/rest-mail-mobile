// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i18;

import 'package:http/http.dart' as _i21;
import 'package:restmail_generated/src/model/api_v1_admin_custom_filters_id_test_post_body_body_one_of_model.dart'
    as _i31;
import 'package:restmail_generated/src/model/api_v1_admin_pipelines_logs_parameters_model.dart'
    as _i39;
import 'package:restmail_generated/src/model/api_v1_admin_pipelines_logs_parameters_model2.dart'
    as _i40;
import 'package:restmail_generated/src/model/api_v1_admin_pipelines_logs_parameters_model3.dart'
    as _i38;
import 'package:restmail_generated/src/model/create_custom_filter_request_body.dart'
    as _i23;
import 'package:restmail_generated/src/model/create_pipeline_request_body.dart'
    as _i35;
import 'package:restmail_generated/src/model/test_filter_request_body.dart'
    as _i44;
import 'package:restmail_generated/src/model/test_pipeline_request_body.dart'
    as _i42;
import 'package:restmail_generated/src/model/update_custom_filter_request_body.dart'
    as _i29;
import 'package:restmail_generated/src/model/update_pipeline_request_body.dart'
    as _i47;
import 'package:restmail_generated/src/model/validate_custom_filter_request_body.dart'
    as _i25;
import 'package:restmail_generated/src/operation/create_custom_filter.dart'
    as _i3;
import 'package:restmail_generated/src/operation/create_pipeline.dart' as _i11;
import 'package:restmail_generated/src/operation/delete_custom_filter.dart'
    as _i6;
import 'package:restmail_generated/src/operation/delete_pipeline.dart' as _i16;
import 'package:restmail_generated/src/operation/get_custom_filter.dart' as _i5;
import 'package:restmail_generated/src/operation/get_message_trace.dart' as _i9;
import 'package:restmail_generated/src/operation/get_pipeline_analytics.dart'
    as _i12;
import 'package:restmail_generated/src/operation/list_custom_filters.dart'
    as _i2;
import 'package:restmail_generated/src/operation/list_pipeline_logs.dart'
    as _i13;
import 'package:restmail_generated/src/operation/list_pipelines.dart' as _i10;
import 'package:restmail_generated/src/operation/test_custom_filter.dart'
    as _i8;
import 'package:restmail_generated/src/operation/test_filter.dart' as _i15;
import 'package:restmail_generated/src/operation/test_pipeline.dart' as _i14;
import 'package:restmail_generated/src/operation/update_custom_filter.dart'
    as _i7;
import 'package:restmail_generated/src/operation/update_pipeline.dart' as _i17;
import 'package:restmail_generated/src/operation/validate_custom_filter.dart'
    as _i4;
import 'package:restmail_generated/src/response_wrapper/create_custom_filter_response.dart'
    as _i22;
import 'package:restmail_generated/src/response_wrapper/create_pipeline_response.dart'
    as _i34;
import 'package:restmail_generated/src/response_wrapper/delete_custom_filter_response.dart'
    as _i27;
import 'package:restmail_generated/src/response_wrapper/delete_pipeline_response.dart'
    as _i45;
import 'package:restmail_generated/src/response_wrapper/get_custom_filter_response.dart'
    as _i26;
import 'package:restmail_generated/src/response_wrapper/get_message_trace_response.dart'
    as _i32;
import 'package:restmail_generated/src/response_wrapper/get_pipeline_analytics_response.dart'
    as _i36;
import 'package:restmail_generated/src/response_wrapper/list_custom_filters_response.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/list_pipeline_logs_response.dart'
    as _i37;
import 'package:restmail_generated/src/response_wrapper/list_pipelines_response.dart'
    as _i33;
import 'package:restmail_generated/src/response_wrapper/test_custom_filter_response.dart'
    as _i30;
import 'package:restmail_generated/src/response_wrapper/test_filter_response.dart'
    as _i43;
import 'package:restmail_generated/src/response_wrapper/test_pipeline_response.dart'
    as _i41;
import 'package:restmail_generated/src/response_wrapper/update_custom_filter_response.dart'
    as _i28;
import 'package:restmail_generated/src/response_wrapper/update_pipeline_response.dart'
    as _i46;
import 'package:restmail_generated/src/response_wrapper/validate_custom_filter_response.dart'
    as _i24;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i19;

class AdminPipelinesApi {
  AdminPipelinesApi(_i1.Server server)
    : _listCustomFilters = _i2.ListCustomFilters(
        server.baseUrl,
        () => server.client,
      ),
      _createCustomFilter = _i3.CreateCustomFilter(
        server.baseUrl,
        () => server.client,
      ),
      _validateCustomFilter = _i4.ValidateCustomFilter(
        server.baseUrl,
        () => server.client,
      ),
      _getCustomFilter = _i5.GetCustomFilter(
        server.baseUrl,
        () => server.client,
      ),
      _deleteCustomFilter = _i6.DeleteCustomFilter(
        server.baseUrl,
        () => server.client,
      ),
      _updateCustomFilter = _i7.UpdateCustomFilter(
        server.baseUrl,
        () => server.client,
      ),
      _testCustomFilter = _i8.TestCustomFilter(
        server.baseUrl,
        () => server.client,
      ),
      _getMessageTrace = _i9.GetMessageTrace(
        server.baseUrl,
        () => server.client,
      ),
      _listPipelines = _i10.ListPipelines(server.baseUrl, () => server.client),
      _createPipeline = _i11.CreatePipeline(
        server.baseUrl,
        () => server.client,
      ),
      _getPipelineAnalytics = _i12.GetPipelineAnalytics(
        server.baseUrl,
        () => server.client,
      ),
      _listPipelineLogs = _i13.ListPipelineLogs(
        server.baseUrl,
        () => server.client,
      ),
      _testPipeline = _i14.TestPipeline(server.baseUrl, () => server.client),
      _testFilter = _i15.TestFilter(server.baseUrl, () => server.client),
      _deletePipeline = _i16.DeletePipeline(
        server.baseUrl,
        () => server.client,
      ),
      _updatePipeline = _i17.UpdatePipeline(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListCustomFilters _listCustomFilters;

  final _i3.CreateCustomFilter _createCustomFilter;

  final _i4.ValidateCustomFilter _validateCustomFilter;

  final _i5.GetCustomFilter _getCustomFilter;

  final _i6.DeleteCustomFilter _deleteCustomFilter;

  final _i7.UpdateCustomFilter _updateCustomFilter;

  final _i8.TestCustomFilter _testCustomFilter;

  final _i9.GetMessageTrace _getMessageTrace;

  final _i10.ListPipelines _listPipelines;

  final _i11.CreatePipeline _createPipeline;

  final _i12.GetPipelineAnalytics _getPipelineAnalytics;

  final _i13.ListPipelineLogs _listPipelineLogs;

  final _i14.TestPipeline _testPipeline;

  final _i15.TestFilter _testFilter;

  final _i16.DeletePipeline _deletePipeline;

  final _i17.UpdatePipeline _updatePipeline;

  /// List custom filters
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — The permitted list is empty:
  /// A current, setup-complete session with the required capability reads an empty database snapshot through the production handler. Pagination and response metadata are preserved.
  ///
  /// ```json
  /// {
  ///   "data": [],
  ///   "pagination": {
  ///     "has_more": false
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
  /// No Authorization header or access cookie is sent. The production JWT middleware refuses the request.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "setup_required" — The account has not completed setup:
  /// The signed session is current but still requires initial account setup. The production SetupDone middleware refuses the request before reading data.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// A current session sends Content-Length above APIMaxBodyBytes, including on this GET. The focused Vertrag test supplies a real oversized body; no typed body is declared.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_limit" — The page size cannot bind to an integer:
  /// The limit query parameter is a string that cannot bind to the registered integer page size. The typed binder refuses it before any database read.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "limit": "must be an integer"
  ///       }
  ///     },
  ///     "message": "Query parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The list dependency fails:
  /// Session and permission checks pass, but the list dependency fails. The production handler and error writer produce this refusal without exposing dependency details.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list custom filters"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// The database-backed current-session lookup fails. The production session-cache builder and stale-session middleware produce this refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i20.ListCustomFiltersResponse, _i21.Response>>
  listCustomFilters({
    _i18.int? domainId,
    _i18.int? limit,
    _i18.int? offset,
    _i19.TonikCancellation? cancellation,
  }) async => _listCustomFilters(
    domainId: domainId,
    limit: limit,
    offset: offset,
    cancellation: cancellation,
  );

  /// Create custom filter
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "config_array":
  /// ```json
  /// {
  ///   "config": [],
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "enabled_default":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "WriteFailure"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "enabled_default":
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {
  ///       "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///     },
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "description": "Tags mail about invoices",
  ///     "direction": "inbound",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "0001-01-01T00:00:00Z",
  ///       "default_quota_bytes": 0,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "",
  ///       "id": 0,
  ///       "name": "",
  ///       "sending_policy": "",
  ///       "server_type": "",
  ///       "updated_at": "0001-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "enabled": true,
  ///     "filter_type": "action",
  ///     "id": 1,
  ///     "name": "tag-invoices",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "config_array":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "config": "must be an object"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to create custom filter"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i22.CreateCustomFilterResponse, _i21.Response>>
  createCustomFilter({
    required _i23.CreateCustomFilterRequestBody body,
    _i19.TonikCancellation? cancellation,
  }) async => _createCustomFilter(body: body, cancellation: cancellation);

  /// Validate custom filter
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "script_empty":
  /// ```json
  /// {
  ///   "script": ""
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "sidecar_invalid_json":
  /// ```json
  /// {
  ///   "script": "invalid-json"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "valid": true
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "script_empty":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "script": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "sidecar_invalid_json":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Invalid sidecar response"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<
    _i19.TonikResult<_i24.ValidateCustomFilterResponse, _i21.Response>
  >
  validateCustomFilter({
    required _i25.ValidateCustomFilterRequestBody body,
    _i19.TonikCancellation? cancellation,
  }) async => _validateCustomFilter(body: body, cancellation: cancellation);

  /// Get custom filter
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — The full public resource is returned:
  /// A current session holds the installation-wide read capability. Stored public fields pass through the production mapper; private certificate and signing keys have no response field.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {
  ///       "prefix": "[REST Mail] "
  ///     },
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "description": "Add a public subject marker",
  ///     "direction": "both",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "0001-01-01T00:00:00Z",
  ///       "default_quota_bytes": 0,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "",
  ///       "id": 0,
  ///       "name": "",
  ///       "sending_policy": "",
  ///       "server_type": "",
  ///       "updated_at": "0001-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "enabled": true,
  ///     "filter_type": "transform",
  ///     "id": 1,
  ///     "name": "Subject café",
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "domain_scope" — A grant on another domain cannot read this custom filter:
  /// Custom filter 1 belongs to example.com. A grant on another domain does not satisfy read access to it; a grant on example.com does.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing" — The requested custom filter does not exist:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Custom filter not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// A current session sends Content-Length above APIMaxBodyBytes, including on this GET. The focused Vertrag test supplies a real oversized body; no typed body is declared.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — A database fault is not a missing resource:
  /// A controlled dependency error exercises the real GORM lookup. The production error writer omits internal fault detail.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to get custom filter"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// The database-backed current-session lookup fails. The production session-cache builder and stale-session middleware produce this refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i26.GetCustomFilterResponse, _i21.Response>>
  getCustomFilter({
    required _i18.int id,
    _i19.TonikCancellation? cancellation,
  }) async => _getCustomFilter(id: id, cancellation: cancellation);

  /// Delete custom filter
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "found":
  /// Production JWT/session and capability middleware precede the real GORM resource deletion. Controlled SQL captures exact table/ID predicates, mutation failures, missing-row responses and refusal-before-database boundaries. No live resource is removed; PostgreSQL constraints/transactions and audit persistence are outside this proof.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Custom filter not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to delete custom filter"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i27.DeleteCustomFilterResponse, _i21.Response>>
  deleteCustomFilter({
    required _i18.int id,
    _i19.TonikCancellation? cancellation,
  }) async => _deleteCustomFilter(id: id, cancellation: cancellation);

  /// Update custom filter
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) { return { action: \"continue\" }; }"
  ///   },
  ///   "description": "Tags mail about invoices and receipts",
  ///   "enabled": true
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {
  ///       "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///     },
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "description": "Tags mail about invoices",
  ///     "direction": "inbound",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "0001-01-01T00:00:00Z",
  ///       "default_quota_bytes": 0,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "",
  ///       "id": 0,
  ///       "name": "",
  ///       "sending_policy": "",
  ///       "server_type": "",
  ///       "updated_at": "0001-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "enabled": false,
  ///     "filter_type": "action",
  ///     "id": 1,
  ///     "name": "tag-invoices",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Custom filter not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_id":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to get custom filter"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i28.UpdateCustomFilterResponse, _i21.Response>>
  updateCustomFilter({
    required _i29.UpdateCustomFilterRequestBody body,
    required _i18.int id,
    _i19.TonikCancellation? cancellation,
  }) async =>
      _updateCustomFilter(body: body, id: id, cancellation: cancellation);

  /// Test custom filter
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "body_boundary" — Body boundary:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "invalid_id":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "malformed_json" — Malformed json:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "sidecar_timeout":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {}
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "body_boundary" — Body boundary:
  /// ```json
  /// {
  ///   "logs": [],
  ///   "result": {
  ///     "action": "continue"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json" — Malformed json:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Custom filter not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 408 (application/json):
  /// **Example** "sidecar_timeout":
  /// ```json
  /// {
  ///   "error": "Execution timed out"
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_id":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i30.TestCustomFilterResponse, _i21.Response>>
  testCustomFilter({
    required _i18.int id,
    _i31.ApiV1AdminCustomFiltersIdTestPostBodyBodyOneOfModel? body,
    _i19.TonikCancellation? cancellation,
  }) async => _testCustomFilter(body: body, id: id, cancellation: cancellation);

  /// Get message trace
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — The full stored resource is mapped to public fields:
  /// A current session holds the required installation-wide read capability. The trace path binds a delivered message ID, not the separate trace ID; queue null associations remain explicit.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "client_ip": "192.0.2.10",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "direction": "inbound",
  ///     "duration_ms": 12,
  ///     "expires_at": "2026-10-21T00:00:00Z",
  ///     "final_action": "continue",
  ///     "id": 101,
  ///     "mail_from": "sender@example.com",
  ///     "message_id": 1,
  ///     "outcome": "delivered",
  ///     "pipeline_id": 7,
  ///     "rcpt_to": "recipient@example.com",
  ///     "reason_code": "",
  ///     "rfc_message_id": "<fixture@example.com>",
  ///     "sampled": true,
  ///     "spam_score": 2.5,
  ///     "stages": [
  ///       {
  ///         "action": "continue",
  ///         "duration_ms": 3,
  ///         "filter_name": "header_validate",
  ///         "filter_type": "action",
  ///         "log": {
  ///           "detail": "Headers accepted",
  ///           "duration_ms": 2,
  ///           "filter": "header_validate",
  ///           "result": "pass"
  ///         }
  ///       }
  ///     ],
  ///     "transport": "tls"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "domain_scope" — A domain-scoped grant does not satisfy installation-wide reads:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing" — An absent resource keeps its not-found response:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No pipeline trace for this message"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// A current session sends Content-Length above APIMaxBodyBytes, including on this GET. The focused Vertrag test supplies a real oversized body; no typed body is declared.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — A database failure is not a missing resource:
  /// The production lookup encounters a controlled database fault. Its private error detail is omitted from the public500 response.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to get message trace"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// The database-backed current-session lookup fails. The production session-cache builder and stale-session middleware produce this refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i32.GetMessageTraceResponse, _i21.Response>>
  getMessageTrace({
    required _i18.int id,
    _i19.TonikCancellation? cancellation,
  }) async => _getMessageTrace(id: id, cancellation: cancellation);

  /// List pipelines
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — The permitted list is empty:
  /// A current, setup-complete session with the required capability reads an empty database snapshot through the production handler. Pagination and response metadata are preserved.
  ///
  /// ```json
  /// {
  ///   "data": [],
  ///   "pagination": {
  ///     "has_more": false
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
  /// No Authorization header or access cookie is sent. The production JWT middleware refuses the request.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "setup_required" — The account has not completed setup:
  /// The signed session is current but still requires initial account setup. The production SetupDone middleware refuses the request before reading data.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// A current session sends Content-Length above APIMaxBodyBytes, including on this GET. The focused Vertrag test supplies a real oversized body; no typed body is declared.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_limit" — The page size cannot bind to an integer:
  /// The limit query parameter is a string that cannot bind to the registered integer page size. The typed binder refuses it before any database read.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "limit": "must be an integer"
  ///       }
  ///     },
  ///     "message": "Query parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The list dependency fails:
  /// Session and permission checks pass, but the list dependency fails. The production handler and error writer produce this refusal without exposing dependency details.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list pipelines"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// The database-backed current-session lookup fails. The production session-cache builder and stale-session middleware produce this refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i33.ListPipelinesResponse, _i21.Response>>
  listPipelines({
    _i18.int? domainId,
    _i18.int? limit,
    _i18.int? offset,
    _i19.TonikCancellation? cancellation,
  }) async => _listPipelines(
    domainId: domainId,
    limit: limit,
    offset: offset,
    cancellation: cancellation,
  );

  /// Create pipeline
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "active_wrong_type":
  /// ```json
  /// {
  ///   "active": "yes",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": []
  /// }
  /// ```
  ///
  /// **Example** "cancelled_after_lookup" — Cancelled after lookup:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "header_validate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "header_validate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "header_validate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "malformed_json" — Malformed json:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "header_validate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "header_validate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "header_validate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "header_validate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "header_validate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "direction": "inbound",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "0001-01-01T00:00:00Z",
  ///       "default_quota_bytes": 0,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "",
  ///       "id": 0,
  ///       "name": "",
  ///       "sending_policy": "",
  ///       "server_type": "",
  ///       "updated_at": "0001-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "filters": [
  ///       {
  ///         "config": {},
  ///         "name": "header_validate"
  ///       }
  ///     ],
  ///     "id": 1,
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json" — Malformed json:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "active_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "active": "must be a boolean"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "cancelled_after_lookup" — Cancelled after lookup:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to create pipeline"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i34.CreatePipelineResponse, _i21.Response>>
  createPipeline({
    required _i35.CreatePipelineRequestBody body,
    _i19.TonikCancellation? cancellation,
  }) async => _createPipeline(body: body, cancellation: cancellation);

  /// Windowed pipeline analytics
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — A permitted session reads the one-hour funnel:
  /// A current, setup-complete session with the observability capability reads empty durable rollups and an empty live metrics snapshot. The timestamps illustrate a one-hour moving window; the actual route test verifies the window at request time.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "funnel": {
  ///       "auth_verdicts": [],
  ///       "received": [],
  ///       "stage_decisions": [],
  ///       "terminal_outcomes": [],
  ///       "top_reject_reasons": []
  ///     },
  ///     "live_totals": {
  ///       "auth_verdicts": [],
  ///       "received": [],
  ///       "stage_decisions": [],
  ///       "terminal_outcomes": [],
  ///       "top_reject_reasons": []
  ///     },
  ///     "window": {
  ///       "label": "1h",
  ///       "since": "2026-10-25T12:00:00Z",
  ///       "until": "2026-10-25T13:00:00Z"
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
  /// No Authorization header or access cookie is sent. The production JWT middleware refuses the request.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "setup_required" — The account has not completed setup:
  /// The signed session is current but still requires initial account setup. The real SetupDone middleware refuses it before querying rollups.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The transport body cap is exceeded:
  /// A current session sends Content-Length above APIMaxBodyBytes, including on this GET. The focused Vertrag hook supplies a real oversized body.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The rollup query fails:
  /// Session and permission checks pass, but the rollup database query fails. The actual handler produces this refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to aggregate pipeline analytics"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// The database-backed current-session lookup fails. The production session-cache builder and stale-session middleware produce this refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<
    _i19.TonikResult<_i36.GetPipelineAnalyticsResponse, _i21.Response>
  >
  getPipelineAnalytics({
    _i18.String? since,
    _i18.String? window,
    _i19.TonikCancellation? cancellation,
  }) async => _getPipelineAnalytics(
    since: since,
    window: window,
    cancellation: cancellation,
  );

  /// List pipeline logs
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — The permitted list is empty:
  /// A current, setup-complete session with the required capability reads an empty database snapshot through the production handler. Pagination and response metadata are preserved.
  ///
  /// ```json
  /// {
  ///   "data": [],
  ///   "pagination": {
  ///     "has_more": false
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
  /// No Authorization header or access cookie is sent. The production JWT middleware refuses the request.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "setup_required" — The account has not completed setup:
  /// The signed session is current but still requires initial account setup. The production SetupDone middleware refuses the request before reading data.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// A current session sends Content-Length above APIMaxBodyBytes, including on this GET. The focused Vertrag test supplies a real oversized body; no typed body is declared.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_limit" — The page size cannot bind to an integer:
  /// The limit query parameter is a string that cannot bind to the registered integer page size. The typed binder refuses it before any database read.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "limit": "must be an integer"
  ///       }
  ///     },
  ///     "message": "Query parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The list dependency fails:
  /// Session and permission checks pass, but the list dependency fails. The production handler and error writer produce this refusal without exposing dependency details.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list pipeline traces"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// The database-backed current-session lookup fails. The production session-cache builder and stale-session middleware produce this refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i37.ListPipelineLogsResponse, _i21.Response>>
  listPipelineLogs({
    _i18.int? pipelineId,
    _i18.int? limit,
    _i18.int? offset,
    _i38.ApiV1AdminPipelinesLogsParametersModel3? direction,
    _i39.ApiV1AdminPipelinesLogsParametersModel? action,
    _i40.ApiV1AdminPipelinesLogsParametersModel2? outcome,
    _i18.String? reasonCode,
    _i18.String? rfcMessageId,
    _i19.TonikCancellation? cancellation,
  }) async => _listPipelineLogs(
    pipelineId: pipelineId,
    limit: limit,
    offset: offset,
    direction: direction,
    action: action,
    outcome: outcome,
    reasonCode: reasonCode,
    rfcMessageId: rfcMessageId,
    cancellation: cancellation,
  );

  /// Test pipeline
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "accepted_email" — Accepted email:
  /// ```json
  /// {
  ///   "email": {
  ///     "body": {
  ///       "content": "Hello.",
  ///       "content_type": "text/plain"
  ///     },
  ///     "envelope": {
  ///       "mail_from": "someone@example.com",
  ///       "rcpt_to": [
  ///         "eve@restmail.test"
  ///       ]
  ///     },
  ///     "headers": {
  ///       "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///       "from": [
  ///         {
  ///           "address": "someone@example.com",
  ///           "name": "Someone"
  ///         }
  ///       ],
  ///       "message-id": "<filter-test@example.com>",
  ///       "subject": "A filter test",
  ///       "to": [
  ///         {
  ///           "address": "eve@restmail.test"
  ///         }
  ///       ]
  ///     }
  ///   },
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "email_missing":
  /// ```json
  /// {
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable" — Lookup unavailable:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 3
  /// }
  /// ```
  ///
  /// **Example** "malformed_json" — Malformed json:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 2147483647
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "accepted_email" — Accepted email:
  /// ```json
  /// {
  ///   "data": {
  ///     "duration_ms": 0,
  ///     "final_action": "continue",
  ///     "final_email": {
  ///       "body": {
  ///         "content": "Hello.",
  ///         "content_type": "text/plain"
  ///       },
  ///       "envelope": {
  ///         "direction": "",
  ///         "mail_from": "someone@example.com",
  ///         "rcpt_to": [
  ///           "eve@restmail.test"
  ///         ],
  ///         "tls": false
  ///       },
  ///       "headers": {
  ///         "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///         "from": [
  ///           {
  ///             "address": "someone@example.com",
  ///             "name": "Someone"
  ///           }
  ///         ],
  ///         "message-id": "<filter-test@example.com>",
  ///         "subject": "A filter test",
  ///         "to": [
  ///           {
  ///             "address": "eve@restmail.test"
  ///           }
  ///         ]
  ///       }
  ///     },
  ///     "steps": [
  ///       {
  ///         "action": "continue",
  ///         "duration_ms": 0,
  ///         "filter_name": "header_validate",
  ///         "filter_type": "action",
  ///         "log": {
  ///           "detail": "all headers valid",
  ///           "filter": "header_validate",
  ///           "result": "pass"
  ///         }
  ///       }
  ///     ]
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json" — Malformed json:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Pipeline not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "email_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "email": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "lookup_unavailable" — Lookup unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i41.TestPipelineResponse, _i21.Response>>
  testPipeline({
    required _i42.TestPipelineRequestBody body,
    _i19.TonikCancellation? cancellation,
  }) async => _testPipeline(body: body, cancellation: cancellation);

  /// Test filter
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "body_boundary" — Body boundary:
  /// ```json
  /// {
  ///   "config": {},
  ///   "email": {
  ///     "body": {
  ///       "content": "Hello.",
  ///       "content_type": "text/plain"
  ///     },
  ///     "envelope": {
  ///       "mail_from": "someone@example.com",
  ///       "rcpt_to": [
  ///         "eve@restmail.test"
  ///       ]
  ///     },
  ///     "headers": {
  ///       "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///       "from": [
  ///         {
  ///           "address": "someone@example.com",
  ///           "name": "Someone"
  ///         }
  ///       ],
  ///       "message-id": "<filter-test@example.com>",
  ///       "subject": "A filter test",
  ///       "to": [
  ///         {
  ///           "address": "eve@restmail.test"
  ///         }
  ///       ]
  ///     }
  ///   },
  ///   "filter_name": "header_validate"
  /// }
  /// ```
  ///
  /// **Example** "config_array" — Config array:
  /// ```json
  /// {
  ///   "config": [],
  ///   "email": {
  ///     "body": {
  ///       "content": "Hello.",
  ///       "content_type": "text/plain"
  ///     },
  ///     "envelope": {
  ///       "mail_from": "someone@example.com",
  ///       "rcpt_to": [
  ///         "eve@restmail.test"
  ///       ]
  ///     },
  ///     "headers": {
  ///       "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///       "from": [
  ///         {
  ///           "address": "someone@example.com",
  ///           "name": "Someone"
  ///         }
  ///       ],
  ///       "message-id": "<filter-test@example.com>",
  ///       "subject": "A filter test",
  ///       "to": [
  ///         {
  ///           "address": "eve@restmail.test"
  ///         }
  ///       ]
  ///     }
  ///   },
  ///   "filter_name": "header_validate"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {
  ///   "config": {},
  ///   "email": {
  ///     "body": {
  ///       "content": "Hello.",
  ///       "content_type": "text/plain"
  ///     },
  ///     "envelope": {
  ///       "mail_from": "someone@example.com",
  ///       "rcpt_to": [
  ///         "eve@restmail.test"
  ///       ]
  ///     },
  ///     "headers": {
  ///       "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///       "from": [
  ///         {
  ///           "address": "someone@example.com",
  ///           "name": "Someone"
  ///         }
  ///       ],
  ///       "message-id": "<filter-test@example.com>",
  ///       "subject": "A filter test",
  ///       "to": [
  ///         {
  ///           "address": "eve@restmail.test"
  ///         }
  ///       ]
  ///     }
  ///   },
  ///   "filter_name": "header_validate"
  /// }
  /// ```
  ///
  /// **Example** "execution_cancelled" — Execution cancelled:
  /// ```json
  /// {
  ///   "config": {},
  ///   "email": {
  ///     "body": {
  ///       "content": "Hello.",
  ///       "content_type": "text/plain"
  ///     },
  ///     "envelope": {
  ///       "mail_from": "someone@example.com",
  ///       "rcpt_to": [
  ///         "eve@restmail.test"
  ///       ]
  ///     },
  ///     "headers": {
  ///       "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///       "from": [
  ///         {
  ///           "address": "someone@example.com",
  ///           "name": "Someone"
  ///         }
  ///       ],
  ///       "message-id": "<filter-test@example.com>",
  ///       "subject": "A filter test",
  ///       "to": [
  ///         {
  ///           "address": "eve@restmail.test"
  ///         }
  ///       ]
  ///     }
  ///   },
  ///   "filter_name": "header_validate"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json" — Malformed json:
  /// ```json
  /// {
  ///   "config": {},
  ///   "email": {
  ///     "body": {
  ///       "content": "Hello.",
  ///       "content_type": "text/plain"
  ///     },
  ///     "envelope": {
  ///       "mail_from": "someone@example.com",
  ///       "rcpt_to": [
  ///         "eve@restmail.test"
  ///       ]
  ///     },
  ///     "headers": {
  ///       "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///       "from": [
  ///         {
  ///           "address": "someone@example.com",
  ///           "name": "Someone"
  ///         }
  ///       ],
  ///       "message-id": "<filter-test@example.com>",
  ///       "subject": "A filter test",
  ///       "to": [
  ///         {
  ///           "address": "eve@restmail.test"
  ///         }
  ///       ]
  ///     }
  ///   },
  ///   "filter_name": "header_validate"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {
  ///   "config": {},
  ///   "email": {
  ///     "body": {
  ///       "content": "Hello.",
  ///       "content_type": "text/plain"
  ///     },
  ///     "envelope": {
  ///       "mail_from": "someone@example.com",
  ///       "rcpt_to": [
  ///         "eve@restmail.test"
  ///       ]
  ///     },
  ///     "headers": {
  ///       "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///       "from": [
  ///         {
  ///           "address": "someone@example.com",
  ///           "name": "Someone"
  ///         }
  ///       ],
  ///       "message-id": "<filter-test@example.com>",
  ///       "subject": "A filter test",
  ///       "to": [
  ///         {
  ///           "address": "eve@restmail.test"
  ///         }
  ///       ]
  ///     }
  ///   },
  ///   "filter_name": "header_validate"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {
  ///   "config": {},
  ///   "email": {
  ///     "body": {
  ///       "content": "Hello.",
  ///       "content_type": "text/plain"
  ///     },
  ///     "envelope": {
  ///       "mail_from": "someone@example.com",
  ///       "rcpt_to": [
  ///         "eve@restmail.test"
  ///       ]
  ///     },
  ///     "headers": {
  ///       "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///       "from": [
  ///         {
  ///           "address": "someone@example.com",
  ///           "name": "Someone"
  ///         }
  ///       ],
  ///       "message-id": "<filter-test@example.com>",
  ///       "subject": "A filter test",
  ///       "to": [
  ///         {
  ///           "address": "eve@restmail.test"
  ///         }
  ///       ]
  ///     }
  ///   },
  ///   "filter_name": "header_validate"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "config": {},
  ///   "email": {
  ///     "body": {
  ///       "content": "Hello.",
  ///       "content_type": "text/plain"
  ///     },
  ///     "envelope": {
  ///       "mail_from": "someone@example.com",
  ///       "rcpt_to": [
  ///         "eve@restmail.test"
  ///       ]
  ///     },
  ///     "headers": {
  ///       "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///       "from": [
  ///         {
  ///           "address": "someone@example.com",
  ///           "name": "Someone"
  ///         }
  ///       ],
  ///       "message-id": "<filter-test@example.com>",
  ///       "subject": "A filter test",
  ///       "to": [
  ///         {
  ///           "address": "eve@restmail.test"
  ///         }
  ///       ]
  ///     }
  ///   },
  ///   "filter_name": "header_validate"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {
  ///   "config": {},
  ///   "email": {
  ///     "body": {
  ///       "content": "Hello.",
  ///       "content_type": "text/plain"
  ///     },
  ///     "envelope": {
  ///       "mail_from": "someone@example.com",
  ///       "rcpt_to": [
  ///         "eve@restmail.test"
  ///       ]
  ///     },
  ///     "headers": {
  ///       "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///       "from": [
  ///         {
  ///           "address": "someone@example.com",
  ///           "name": "Someone"
  ///         }
  ///       ],
  ///       "message-id": "<filter-test@example.com>",
  ///       "subject": "A filter test",
  ///       "to": [
  ///         {
  ///           "address": "eve@restmail.test"
  ///         }
  ///       ]
  ///     }
  ///   },
  ///   "filter_name": "header_validate"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "body_boundary" — Body boundary:
  /// ```json
  /// {
  ///   "data": {
  ///     "action": "continue",
  ///     "log": {
  ///       "detail": "all headers valid",
  ///       "filter": "header_validate",
  ///       "result": "pass"
  ///     },
  ///     "type": "action"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json" — Malformed json:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "config_array" — Config array:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "config": "must be an object"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "execution_cancelled" — Execution cancelled:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i43.TestFilterResponse, _i21.Response>>
  testFilter({
    required _i44.TestFilterRequestBody body,
    _i19.TonikCancellation? cancellation,
  }) async => _testFilter(body: body, cancellation: cancellation);

  /// Delete pipeline
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "found":
  /// Production JWT/session and capability middleware precede the real GORM resource deletion. Controlled SQL captures exact table/ID predicates, mutation failures, missing-row responses and refusal-before-database boundaries. No live resource is removed; PostgreSQL constraints/transactions and audit persistence are outside this proof.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Pipeline not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to delete pipeline"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i45.DeletePipelineResponse, _i21.Response>>
  deletePipeline({
    required _i18.int id,
    _i19.TonikCancellation? cancellation,
  }) async => _deletePipeline(id: id, cancellation: cancellation);

  /// Update pipeline
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "active_null" — Active null:
  /// ```json
  /// {
  ///   "active": null
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "spf_check"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "invalid_id" — Invalid id:
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "spf_check"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable" — Lookup unavailable:
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "spf_check"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "malformed_json" — Malformed json:
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "spf_check"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "active": false
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "spf_check"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "spf_check"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "spf_check"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "spf_check"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "active_null" — Active null:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "direction": "inbound",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "0001-01-01T00:00:00Z",
  ///       "default_quota_bytes": 0,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "",
  ///       "id": 0,
  ///       "name": "",
  ///       "sending_policy": "",
  ///       "server_type": "",
  ///       "updated_at": "0001-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "filters": [
  ///       {
  ///         "config": {},
  ///         "name": "header_validate"
  ///       }
  ///     ],
  ///     "id": 1,
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json" — Malformed json:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Pipeline not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_id" — Invalid id:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "lookup_unavailable" — Lookup unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i46.UpdatePipelineResponse, _i21.Response>>
  updatePipeline({
    required _i47.UpdatePipelineRequestBody body,
    required _i18.int id,
    _i19.TonikCancellation? cancellation,
  }) async => _updatePipeline(body: body, id: id, cancellation: cancellation);
}
