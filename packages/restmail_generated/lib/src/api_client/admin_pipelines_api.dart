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
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
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
  /// **Example** "config_missing":
  /// ```json
  /// {
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "config_null":
  /// ```json
  /// {
  ///   "config": null,
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "config_scalar":
  /// ```json
  /// {
  ///   "config": "script",
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
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
  /// **Example** "created":
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
  /// **Example** "csrf_missing":
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
  /// **Example** "direction_invalid":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "sideways",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
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
  /// **Example** "domain_wrong_type":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": "other",
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "empty_config":
  /// ```json
  /// {
  ///   "config": {},
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
  /// **Example** "enabled_true":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": true,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "enabled_wrong_type":
  /// ```json
  /// {
  ///   "config": {},
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": "false",
  ///   "filter_type": "action",
  ///   "name": "test"
  /// }
  /// ```
  ///
  /// **Example** "filter_type_invalid":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "enabled": false,
  ///   "filter_type": "invalid",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "forged_id":
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
  ///   "id": 987654,
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "forged_timestamp":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "created_at": "2000-01-01T00:00:00Z",
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
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
  /// **Example** "key_holder_missing":
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
  /// **Example** "key_mailbox":
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
  /// **Example** "key_read":
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
  /// **Example** "key_write":
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
  /// **Example** "mailbox_scope":
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
  /// **Example** "malformed_json":
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "name_wrong_type":
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
  ///   "name": 1
  /// }
  /// ```
  ///
  /// **Example** "nested_config":
  /// ```json
  /// {
  ///   "config": {
  ///     "arbitrary": null,
  ///     "rules": [
  ///       {
  ///         "enabled": false,
  ///         "name": "café"
  ///       }
  ///     ],
  ///     "script": "function filter(email) { return email; }"
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
  /// **Example** "nested_domain":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "inbound",
  ///   "domain": {
  ///     "name": "injected.test"
  ///   },
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "tag-invoices"
  /// }
  /// ```
  ///
  /// **Example** "permission_store_unavailable":
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
  /// **Example** "read_only":
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
  /// **Example** "required_missing":
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
  /// **Example** "transform_outbound":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "Tags mail about invoices",
  ///   "direction": "outbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "transform",
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
  /// **Example** "unicode":
  /// ```json
  /// {
  ///   "config": {
  ///     "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///   },
  ///   "description": "商用フィルター",
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "enabled": false,
  ///   "filter_type": "action",
  ///   "name": "Subject café"
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
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
  ///   "name": "tag-invoices",
  ///   "surprise": true
  /// }
  /// ```
  ///
  /// **Example** "write_only":
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
  /// **Example** "cookie_session":
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
  /// **Example** "created":
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
  /// **Example** "empty_config":
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {},
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
  /// **Example** "enabled_true":
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
  /// **Example** "key_write":
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
  /// **Example** "nested_config":
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {
  ///       "arbitrary": null,
  ///       "rules": [
  ///         {
  ///           "enabled": false,
  ///           "name": "café"
  ///         }
  ///       ],
  ///       "script": "function filter(email) { return email; }"
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
  /// **Example** "transform_outbound":
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {
  ///       "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///     },
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "description": "Tags mail about invoices",
  ///     "direction": "outbound",
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
  ///     "filter_type": "transform",
  ///     "id": 1,
  ///     "name": "tag-invoices",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unicode":
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {
  ///       "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///     },
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "description": "商用フィルター",
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
  ///     "name": "Subject café",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
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
  /// **Example** "body_array":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
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
  /// **Example** "config_missing":
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
  /// **Example** "config_null":
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
  /// **Example** "config_scalar":
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
  /// **Example** "direction_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "direction": "must be inbound, outbound or both"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "domain_id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "enabled_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "enabled": "must be a boolean"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "filter_type_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filter_type": "must be action or transform"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "forged_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "forged_timestamp":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "created_at": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "nested_domain":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "domain": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "required_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "direction": "required",
  ///         "filter_type": "required",
  ///         "name": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "surprise": "not allowed"
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
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
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
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "dry_run":
  /// ```json
  /// {
  ///   "email": {
  ///     "envelope": {
  ///       "mail_from": "sender@example.com"
  ///     }
  ///   },
  ///   "script": "dry-run"
  /// }
  /// ```
  ///
  /// **Example** "email_nested":
  /// ```json
  /// {
  ///   "email": {
  ///     "body": {
  ///       "content": "Hello"
  ///     },
  ///     "envelope": {
  ///       "mail_from": "sender@example.com",
  ///       "rcpt_to": [
  ///         "user@example.com"
  ///       ]
  ///     },
  ///     "headers": {
  ///       "subject": "café"
  ///     }
  ///   },
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "email_null":
  /// ```json
  /// {
  ///   "email": null,
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "execution_error":
  /// ```json
  /// {
  ///   "email": {
  ///     "envelope": {
  ///       "mail_from": "sender@example.com"
  ///     }
  ///   },
  ///   "script": "execution-error"
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope":
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
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "read_only":
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
  /// **Example** "script_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "script_null":
  /// ```json
  /// {
  ///   "script": null
  /// }
  /// ```
  ///
  /// **Example** "script_wrong_type":
  /// ```json
  /// {
  ///   "script": false
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
  /// **Example** "sidecar_token_refused":
  /// ```json
  /// {
  ///   "script": "token-refused"
  /// }
  /// ```
  ///
  /// **Example** "sidecar_truncated":
  /// ```json
  /// {
  ///   "script": "truncated-response"
  /// }
  /// ```
  ///
  /// **Example** "sidecar_unavailable":
  /// ```json
  /// {
  ///   "script": "transport-unavailable"
  /// }
  /// ```
  ///
  /// **Example** "spaced_response":
  /// ```json
  /// {
  ///   "script": "spaced-response"
  /// }
  /// ```
  ///
  /// **Example** "syntax_error":
  /// ```json
  /// {
  ///   "script": "syntax-error"
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
  /// **Example** "unicode_script":
  /// ```json
  /// {
  ///   "script": "function filter(email) { /* café 商用 */ return email; }"
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n",
  ///   "surprise": true
  /// }
  /// ```
  ///
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "worker_error":
  /// ```json
  /// {
  ///   "script": "worker-error"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
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
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "valid": true
  /// }
  /// ```
  ///
  /// **Example** "dry_run":
  /// ```json
  /// {
  ///   "dry_run": {
  ///     "logs": [
  ///       "checked"
  ///     ],
  ///     "result": {
  ///       "action": "continue",
  ///       "score": 1
  ///     }
  ///   },
  ///   "valid": true
  /// }
  /// ```
  ///
  /// **Example** "email_nested":
  /// ```json
  /// {
  ///   "valid": true
  /// }
  /// ```
  ///
  /// **Example** "email_null":
  /// ```json
  /// {
  ///   "valid": true
  /// }
  /// ```
  ///
  /// **Example** "execution_error":
  /// ```json
  /// {
  ///   "dry_run": {
  ///     "error": "Script threw",
  ///     "logs": []
  ///   },
  ///   "error": "Script threw",
  ///   "phase": "execution",
  ///   "valid": true
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "valid": true
  /// }
  /// ```
  ///
  /// **Example** "spaced_response":
  /// ```json
  /// {
  ///   "dry_run": {
  ///     "logs": [],
  ///     "result": {
  ///       "custom": 42
  ///     }
  ///   },
  ///   "valid": true
  /// }
  /// ```
  ///
  /// **Example** "syntax_error":
  /// ```json
  /// {
  ///   "error": "Unexpected token",
  ///   "phase": "syntax",
  ///   "valid": false
  /// }
  /// ```
  ///
  /// **Example** "unicode_script":
  /// ```json
  /// {
  ///   "valid": true
  /// }
  /// ```
  ///
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "valid": true
  /// }
  /// ```
  ///
  /// **Example** "worker_error":
  /// ```json
  /// {
  ///   "error": "Worker unavailable"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "valid": true
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "body_array":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
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
  /// **Example** "script_missing":
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
  /// **Example** "script_null":
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
  /// **Example** "script_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "script": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "surprise": "not allowed"
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
  /// **Example** "sidecar_truncated":
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
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sidecar_token_refused":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "service_unavailable",
  ///     "message": "JS filter sidecar refused the API's token (JS_FILTER_TOKEN differs between the API and the sidecar)"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sidecar_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "service_unavailable",
  ///     "message": "JS filter sidecar unavailable"
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
  /// **Example** "disabled" — Disabled configuration remains readable to administrators:
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
  ///     "enabled": false,
  ///     "filter_type": "transform",
  ///     "id": 2,
  ///     "name": "Subject café",
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "domain_scope" — A domain-scoped grant cannot read an installation-wide resource:
  /// The current installation-wide permission ceiling is preserved. A grant on example.com does not satisfy read access at *.
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
  /// **Example** "outside_domain" — A grant on another domain cannot read this configuration:
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
  /// **Example** "invalid_format" — The domain ID cannot bind to an integer:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "permission_store_unavailable" — The grant-store lookup fails:
  /// The current session is valid, but its held grants cannot be loaded; permission middleware fails closed.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "required_capability":
  /// Certificates require installation-wide domains:write; pipelines/custom filters require pipelines:delete. Read-only, other-resource and domain-scoped grants do not substitute.
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
  /// **Example** "other_capability":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only":
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
  /// **Example** "invalid_format":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "config_array":
  /// ```json
  /// {
  ///   "config": [],
  ///   "enabled": true
  /// }
  /// ```
  ///
  /// **Example** "config_null":
  /// ```json
  /// {
  ///   "config": null,
  ///   "enabled": true
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
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
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "direction_invalid":
  /// ```json
  /// {
  ///   "direction": "sideways",
  ///   "enabled": true
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "domain_wrong_type":
  /// ```json
  /// {
  ///   "domain_id": "other",
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "empty_config":
  /// ```json
  /// {
  ///   "config": {}
  /// }
  /// ```
  ///
  /// **Example** "empty_description":
  /// ```json
  /// {
  ///   "description": ""
  /// }
  /// ```
  ///
  /// **Example** "enabled_false":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "filter_type_invalid":
  /// ```json
  /// {
  ///   "enabled": true,
  ///   "filter_type": "invalid"
  /// }
  /// ```
  ///
  /// **Example** "forged_id":
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "id": 987654
  /// }
  /// ```
  ///
  /// **Example** "forged_timestamp":
  /// ```json
  /// {
  ///   "created_at": "2000-01-01T00:00:00Z",
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "ignored_domain":
  /// ```json
  /// {
  ///   "domain_id": 99
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
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
  /// **Example** "invalid_overflow":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "key_write":
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
  /// **Example** "mailbox_scope":
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
  /// **Example** "name_empty":
  /// ```json
  /// {
  ///   "enabled": true,
  ///   "name": ""
  /// }
  /// ```
  ///
  /// **Example** "name_wrong_type":
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "name": 1
  /// }
  /// ```
  ///
  /// **Example** "nested_config":
  /// ```json
  /// {
  ///   "config": {
  ///     "arbitrary": null,
  ///     "rules": [
  ///       {
  ///         "enabled": false,
  ///         "name": "café"
  ///       }
  ///     ],
  ///     "script": "function filter(email) { return email; }"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "nested_domain":
  /// ```json
  /// {
  ///   "domain": {
  ///     "name": "injected.test"
  ///   },
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "null_fields":
  /// ```json
  /// {
  ///   "description": null,
  ///   "direction": null,
  ///   "domain_id": null,
  ///   "enabled": null,
  ///   "filter_type": null,
  ///   "name": null
  /// }
  /// ```
  ///
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "enabled": false
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
  /// **Example** "read_only":
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
  /// **Example** "transform_outbound":
  /// ```json
  /// {
  ///   "config": {
  ///     "action": "continue"
  ///   },
  ///   "description": "Updated",
  ///   "direction": "outbound",
  ///   "enabled": false,
  ///   "filter_type": "transform",
  ///   "name": "Redirect"
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
  /// **Example** "unchanged":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "unicode":
  /// ```json
  /// {
  ///   "description": "商用フィルター",
  ///   "name": "Subject café"
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "surprise": true
  /// }
  /// ```
  ///
  /// **Example** "updated":
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
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
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
  /// **Example** "cookie_session":
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
  /// **Example** "empty_config":
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {},
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
  /// **Example** "empty_description":
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {
  ///       "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///     },
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "description": "",
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
  /// **Example** "enabled_false":
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
  /// **Example** "ignored_domain":
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
  /// **Example** "key_write":
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
  /// **Example** "nested_config":
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {
  ///       "arbitrary": null,
  ///       "rules": [
  ///         {
  ///           "enabled": false,
  ///           "name": "café"
  ///         }
  ///       ],
  ///       "script": "function filter(email) { return email; }"
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
  /// **Example** "null_fields":
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
  /// **Example** "transform_outbound":
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {
  ///       "action": "continue"
  ///     },
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "description": "Updated",
  ///     "direction": "outbound",
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
  ///     "filter_type": "transform",
  ///     "id": 1,
  ///     "name": "Redirect",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unchanged":
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
  /// **Example** "unicode":
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {
  ///       "script": "function filter(email) {\n  return { action: \"continue\" };\n}\n"
  ///     },
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "description": "商用フィルター",
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
  ///     "name": "Subject café",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "updated":
  /// ```json
  /// {
  ///   "data": {
  ///     "config": {
  ///       "script": "function filter(email) { return { action: \"continue\" }; }"
  ///     },
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "description": "Tags mail about invoices and receipts",
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
  /// **Example** "write_only":
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
  /// **Example** "body_array":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only":
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
  /// **Example** "config_null":
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
  /// **Example** "direction_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "direction": "must be inbound, outbound or both"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "domain_id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "filter_type_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filter_type": "must be action or transform"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "forged_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "not allowed"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "forged_timestamp":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "created_at": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "invalid_overflow":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_empty":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "nested_domain":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "domain": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "surprise": "not allowed"
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
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to update custom filter"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "config_invalid":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "cookie_session" — Cookie session:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "csrf_missing" — Csrf missing:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "domain_scope" — Domain scope:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "email_array":
  /// ```json
  /// {
  ///   "email": [
  ///     1,
  ///     {
  ///       "a": true
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "email_nested":
  /// ```json
  /// {
  ///   "email": {
  ///     "body": {
  ///       "content": "hello"
  ///     },
  ///     "custom": {
  ///       "nested": [
  ///         1,
  ///         false,
  ///         null
  ///       ]
  ///     },
  ///     "headers": {
  ///       "subject": "Invoice €"
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "email_null":
  /// ```json
  /// {
  ///   "email": null
  /// }
  /// ```
  ///
  /// **Example** "empty_body":
  /// The transport replay sends an empty body, selecting the complete built-in sample email.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
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
  /// **Example** "invalid_overflow":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "key_domain" — Key domain:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "key_holder_missing" — Key holder missing:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "key_mailbox" — Key mailbox:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "key_read" — Key read:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "key_write" — Key write:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "key_wrong_domain" — Key wrong domain:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "mailbox_scope" — Mailbox scope:
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
  /// **Example** "null_body":
  /// ```json
  /// null
  /// ```
  ///
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "read_only" — Read only:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "script_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "sidecar_invalid_json":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "sidecar_spaced":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "sidecar_syntax_error":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "sidecar_timeout":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "sidecar_token_refused":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "sidecar_too_large":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "sidecar_truncated":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "sidecar_unavailable":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "sidecar_worker_error":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "surprise": true
  /// }
  /// ```
  ///
  /// **Example** "valid":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "write_only" — Write only:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "wrong_domain" — Wrong domain:
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
  /// **Example** "cookie_session" — Cookie session:
  /// ```json
  /// {
  ///   "logs": [],
  ///   "result": {
  ///     "action": "continue"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "email_array":
  /// ```json
  /// {
  ///   "logs": [],
  ///   "result": {
  ///     "action": "continue"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "email_nested":
  /// ```json
  /// {
  ///   "logs": [],
  ///   "result": {
  ///     "action": "continue"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "email_null":
  /// ```json
  /// {
  ///   "logs": [],
  ///   "result": {
  ///     "action": "continue"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty_body":
  /// The transport replay sends an empty body, selecting the complete built-in sample email.
  ///
  /// ```json
  /// {
  ///   "logs": [],
  ///   "result": {
  ///     "action": "continue"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write" — Key write:
  /// ```json
  /// {
  ///   "logs": [],
  ///   "result": {
  ///     "action": "continue"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_body":
  /// ```json
  /// {
  ///   "logs": [],
  ///   "result": {
  ///     "action": "continue"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sidecar_spaced":
  /// ```json
  /// {
  ///   "logs": [
  ///     "checked"
  ///   ],
  ///   "result": {
  ///     "custom": 42
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "logs": [],
  ///   "result": {
  ///     "action": "continue"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only" — Write only:
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
  /// **Example** "config_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Filter config does not contain a script"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "script_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Filter config does not contain a script"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sidecar_syntax_error":
  /// ```json
  /// {
  ///   "error": "Unexpected token"
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
  /// **Example** "csrf_missing" — Csrf missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope" — Domain scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain" — Key domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing" — Key holder missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox" — Key mailbox:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read" — Key read:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain" — Key wrong domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope" — Mailbox scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only" — Read only:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain" — Wrong domain:
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
  /// **Example** "sidecar_too_large":
  /// ```json
  /// {
  ///   "error": "Email exceeds sidecar limit"
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_format":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "invalid_overflow":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "surprise": "not allowed"
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
  /// **Example** "sidecar_truncated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Invalid sidecar response"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sidecar_worker_error":
  /// ```json
  /// {
  ///   "error": "Worker unavailable"
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sidecar_token_refused":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "service_unavailable",
  ///     "message": "JS filter sidecar refused the API's token (JS_FILTER_TOKEN differs between the API and the sidecar)"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sidecar_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "service_unavailable",
  ///     "message": "JS filter sidecar unavailable"
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
  /// **Example** "observability_capability" — Only observability capability grants this operation:
  /// The session holds exactly one installation-wide read capability. The two resource-specific capabilities cannot substitute for each other.
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
  /// **Example** "required_capability" — The specific read capability grants access:
  /// The session holds queue:read and observability:read at *. Neither domains:read nor pipelines:read substitutes for those capabilities.
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
  /// **Example** "stages_empty" — Stored stages_empty is preserved without inventing timeline entries:
  /// ```json
  /// {
  ///   "data": {
  ///     "client_ip": "192.0.2.10",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "direction": "inbound",
  ///     "duration_ms": 12,
  ///     "expires_at": "2026-10-21T00:00:00Z",
  ///     "final_action": "continue",
  ///     "id": 105,
  ///     "mail_from": "sender@example.com",
  ///     "message_id": 5,
  ///     "outcome": "delivered",
  ///     "pipeline_id": 7,
  ///     "rcpt_to": "recipient@example.com",
  ///     "reason_code": "",
  ///     "rfc_message_id": "<fixture@example.com>",
  ///     "sampled": true,
  ///     "spam_score": 2.5,
  ///     "stages": [],
  ///     "transport": "tls"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "stages_null" — Stored stages_null is preserved without inventing timeline entries:
  /// ```json
  /// {
  ///   "data": {
  ///     "client_ip": "192.0.2.10",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "direction": "inbound",
  ///     "duration_ms": 12,
  ///     "expires_at": "2026-10-21T00:00:00Z",
  ///     "final_action": "continue",
  ///     "id": 102,
  ///     "mail_from": "sender@example.com",
  ///     "message_id": 2,
  ///     "outcome": "delivered",
  ///     "pipeline_id": 7,
  ///     "rcpt_to": "recipient@example.com",
  ///     "reason_code": "",
  ///     "rfc_message_id": "<fixture@example.com>",
  ///     "sampled": true,
  ///     "spam_score": 2.5,
  ///     "stages": null,
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
  /// **Example** "queue_capability" — Queue capability alone cannot read this operation:
  /// The session holds exactly one installation-wide read capability. The two resource-specific capabilities cannot substitute for each other.
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
  /// **Example** "wrong_capability" — Other administrator read capabilities do not grant this operation:
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
  /// **Example** "invalid_format" — The domain ID cannot bind to an integer:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "invalid_stages" — Corrupt stored timeline data returns a sanitized500:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to read pipeline trace stages"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "permission_store_unavailable" — The grant-store lookup fails:
  /// The current session is valid, but its held grants cannot be loaded; permission middleware fails closed.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "active_null" — Active null:
  /// ```json
  /// {
  ///   "active": null,
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
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "body_boundary" — Body boundary:
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
  /// **Example** "cookie_session" — Cookie session:
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
  /// **Example** "csrf_missing" — Csrf missing:
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
  /// **Example** "direction_missing":
  /// ```json
  /// {
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
  /// **Example** "disabled" — Disabled:
  /// ```json
  /// {
  ///   "active": false,
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
  /// **Example** "domain_scope" — Domain scope:
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
  /// **Example** "duplicate_unsupported" — Duplicate unsupported:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": [
  ///     {
  ///       "config": {
  ///         "queue_recipient": "owner@example.com"
  ///       },
  ///       "name": "duplicate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "empty_filters" — Empty filters:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": []
  /// }
  /// ```
  ///
  /// **Example** "filters_missing":
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1
  /// }
  /// ```
  ///
  /// **Example** "global_pipeline" — Global pipeline:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 0,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "header_validate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "insert_unavailable" — Insert unavailable:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 4,
  ///   "filters": [
  ///     {
  ///       "config": {},
  ///       "name": "header_validate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_domain" — Key domain:
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
  /// **Example** "key_holder_missing" — Key holder missing:
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
  /// **Example** "key_mailbox" — Key mailbox:
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
  /// **Example** "key_read" — Key read:
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
  /// **Example** "key_write" — Key write:
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
  /// **Example** "key_wrong_domain" — Key wrong domain:
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
  /// **Example** "mailbox_scope" — Mailbox scope:
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
  /// **Example** "null_body":
  /// ```json
  /// null
  /// ```
  ///
  /// **Example** "outbound" — Outbound:
  /// ```json
  /// {
  ///   "direction": "outbound",
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
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
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
  /// **Example** "read_only" — Read only:
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
  /// **Example** "sieve_valid" — Sieve valid:
  /// ```json
  /// {
  ///   "direction": "inbound",
  ///   "domain_id": 1,
  ///   "filters": [
  ///     {
  ///       "config": {
  ///         "script": "keep;"
  ///       },
  ///       "name": "sieve"
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
  /// **Example** "write_only" — Write only:
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
  /// **Example** "wrong_domain" — Wrong domain:
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
  /// **Example** "body_boundary" — Body boundary:
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
  /// **Example** "cookie_session" — Cookie session:
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
  /// **Example** "disabled" — Disabled:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
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
  /// **Example** "empty_filters" — Empty filters:
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
  ///     "filters": [],
  ///     "id": 1,
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "global_pipeline" — Global pipeline:
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
  ///     "domain_id": 0,
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
  /// **Example** "key_write" — Key write:
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
  /// **Example** "outbound" — Outbound:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "direction": "outbound",
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
  /// **Example** "sieve_valid" — Sieve valid:
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
  ///         "config": {
  ///           "script": "keep;"
  ///         },
  ///         "name": "sieve"
  ///       }
  ///     ],
  ///     "id": 1,
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only" — Write only:
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
  /// **Example** "body_array":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "duplicate_unsupported" — Duplicate unsupported:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unsupported_filter",
  ///     "message": "the duplicate filter's queue_recipient is not supported; use webhook_url to fork a copy"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "null_body":
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
  /// **Example** "csrf_missing" — Csrf missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope" — Domain scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain" — Key domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing" — Key holder missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox" — Key mailbox:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read" — Key read:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain" — Key wrong domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope" — Mailbox scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only" — Read only:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain" — Wrong domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
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
  /// **Example** "direction_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "direction": "must be 'inbound' or 'outbound'"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "filters_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filters": "must be an array of filter objects"
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
  /// **Example** "insert_unavailable" — Insert unavailable:
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
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "body_boundary" — Body boundary:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "config_unreadable" — Config unreadable:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 4
  /// }
  /// ```
  ///
  /// **Example** "cookie_session" — Cookie session:
  /// ```json
  /// {
  ///   "email": {},
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
  /// **Example** "csrf_missing" — Csrf missing:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "domain_scope" — Domain scope:
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
  /// **Example** "empty_pipeline" — Empty pipeline:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 2
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "key_domain" — Key domain:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing" — Key holder missing:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox" — Key mailbox:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "key_read" — Key read:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "key_write" — Key write:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain" — Key wrong domain:
  /// ```json
  /// {
  ///   "email": {},
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
  /// **Example** "mailbox_scope" — Mailbox scope:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
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
  /// **Example** "null_body" — Null body:
  /// ```json
  /// null
  /// ```
  ///
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "pipeline_id_wrong_type":
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": "1"
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
  /// **Example** "read_only" — Read only:
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
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "write_only" — Write only:
  /// ```json
  /// {
  ///   "email": {},
  ///   "pipeline_id": 1
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain" — Wrong domain:
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
  /// **Example** "body_boundary" — Body boundary:
  /// ```json
  /// {
  ///   "data": {
  ///     "duration_ms": 0,
  ///     "final_action": "reject",
  ///     "final_email": {
  ///       "body": {
  ///         "content_type": ""
  ///       },
  ///       "envelope": {
  ///         "direction": "",
  ///         "mail_from": "",
  ///         "rcpt_to": [],
  ///         "tls": false
  ///       },
  ///       "headers": {
  ///         "date": "",
  ///         "from": [],
  ///         "message-id": "",
  ///         "subject": "",
  ///         "to": []
  ///       }
  ///     },
  ///     "reject_message": "550 Invalid headers: missing From header, missing Date header",
  ///     "steps": [
  ///       {
  ///         "action": "reject",
  ///         "duration_ms": 0,
  ///         "filter_name": "header_validate",
  ///         "filter_type": "action",
  ///         "log": {
  ///           "detail": "missing From header; missing Date header",
  ///           "filter": "header_validate",
  ///           "result": "reject"
  ///         }
  ///       }
  ///     ]
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session" — Cookie session:
  /// ```json
  /// {
  ///   "data": {
  ///     "duration_ms": 0,
  ///     "final_action": "reject",
  ///     "final_email": {
  ///       "body": {
  ///         "content_type": ""
  ///       },
  ///       "envelope": {
  ///         "direction": "",
  ///         "mail_from": "",
  ///         "rcpt_to": [],
  ///         "tls": false
  ///       },
  ///       "headers": {
  ///         "date": "",
  ///         "from": [],
  ///         "message-id": "",
  ///         "subject": "",
  ///         "to": []
  ///       }
  ///     },
  ///     "reject_message": "550 Invalid headers: missing From header, missing Date header",
  ///     "steps": [
  ///       {
  ///         "action": "reject",
  ///         "duration_ms": 0,
  ///         "filter_name": "header_validate",
  ///         "filter_type": "action",
  ///         "log": {
  ///           "detail": "missing From header; missing Date header",
  ///           "filter": "header_validate",
  ///           "result": "reject"
  ///         }
  ///       }
  ///     ]
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty_pipeline" — Empty pipeline:
  /// ```json
  /// {
  ///   "data": {
  ///     "duration_ms": 0,
  ///     "final_action": "continue",
  ///     "final_email": {
  ///       "body": {
  ///         "content_type": ""
  ///       },
  ///       "envelope": {
  ///         "direction": "",
  ///         "mail_from": "",
  ///         "rcpt_to": [],
  ///         "tls": false
  ///       },
  ///       "headers": {
  ///         "date": "",
  ///         "from": [],
  ///         "message-id": "",
  ///         "subject": "",
  ///         "to": []
  ///       }
  ///     },
  ///     "steps": []
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write" — Key write:
  /// ```json
  /// {
  ///   "data": {
  ///     "duration_ms": 0,
  ///     "final_action": "reject",
  ///     "final_email": {
  ///       "body": {
  ///         "content_type": ""
  ///       },
  ///       "envelope": {
  ///         "direction": "",
  ///         "mail_from": "",
  ///         "rcpt_to": [],
  ///         "tls": false
  ///       },
  ///       "headers": {
  ///         "date": "",
  ///         "from": [],
  ///         "message-id": "",
  ///         "subject": "",
  ///         "to": []
  ///       }
  ///     },
  ///     "reject_message": "550 Invalid headers: missing From header, missing Date header",
  ///     "steps": [
  ///       {
  ///         "action": "reject",
  ///         "duration_ms": 0,
  ///         "filter_name": "header_validate",
  ///         "filter_type": "action",
  ///         "log": {
  ///           "detail": "missing From header; missing Date header",
  ///           "filter": "header_validate",
  ///           "result": "reject"
  ///         }
  ///       }
  ///     ]
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "data": {
  ///     "duration_ms": 0,
  ///     "final_action": "reject",
  ///     "final_email": {
  ///       "body": {
  ///         "content_type": ""
  ///       },
  ///       "envelope": {
  ///         "direction": "",
  ///         "mail_from": "",
  ///         "rcpt_to": [],
  ///         "tls": false
  ///       },
  ///       "headers": {
  ///         "date": "",
  ///         "from": [],
  ///         "message-id": "",
  ///         "subject": "",
  ///         "to": []
  ///       }
  ///     },
  ///     "reject_message": "550 Invalid headers: missing From header, missing Date header",
  ///     "steps": [
  ///       {
  ///         "action": "reject",
  ///         "duration_ms": 0,
  ///         "filter_name": "header_validate",
  ///         "filter_type": "action",
  ///         "log": {
  ///           "detail": "missing From header; missing Date header",
  ///           "filter": "header_validate",
  ///           "result": "reject"
  ///         }
  ///       }
  ///     ]
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only" — Write only:
  /// ```json
  /// {
  ///   "data": {
  ///     "duration_ms": 0,
  ///     "final_action": "reject",
  ///     "final_email": {
  ///       "body": {
  ///         "content_type": ""
  ///       },
  ///       "envelope": {
  ///         "direction": "",
  ///         "mail_from": "",
  ///         "rcpt_to": [],
  ///         "tls": false
  ///       },
  ///       "headers": {
  ///         "date": "",
  ///         "from": [],
  ///         "message-id": "",
  ///         "subject": "",
  ///         "to": []
  ///       }
  ///     },
  ///     "reject_message": "550 Invalid headers: missing From header, missing Date header",
  ///     "steps": [
  ///       {
  ///         "action": "reject",
  ///         "duration_ms": 0,
  ///         "filter_name": "header_validate",
  ///         "filter_type": "action",
  ///         "log": {
  ///           "detail": "missing From header; missing Date header",
  ///           "filter": "header_validate",
  ///           "result": "reject"
  ///         }
  ///       }
  ///     ]
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "invalid_body":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "null_body" — Null body:
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
  /// **Example** "csrf_missing" — Csrf missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope" — Domain scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain" — Key domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing" — Key holder missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox" — Key mailbox:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read" — Key read:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain" — Key wrong domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope" — Mailbox scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only" — Read only:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain" — Wrong domain:
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
  /// **Example** "pipeline_id_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "pipeline_id": "must be a non-negative integer"
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
  /// **Example** "config_unreadable" — Config unreadable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Invalid pipeline filter config"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "config_missing" — Config missing:
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
  ///   "filter_name": "header_validate"
  /// }
  /// ```
  ///
  /// **Example** "config_null" — Config null:
  /// ```json
  /// {
  ///   "config": null,
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
  /// **Example** "cookie_session" — Cookie session:
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
  /// **Example** "csrf_missing" — Csrf missing:
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
  /// **Example** "domain_scope" — Domain scope:
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
  /// **Example** "execution_failure" — Execution failure:
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
  /// **Example** "execution_panic" — Execution panic:
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
  /// **Example** "filter_name_missing":
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
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "filter_name_wrong_type":
  /// ```json
  /// {
  ///   "config": {},
  ///   "email": {},
  ///   "filter_name": 1
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "key_domain" — Key domain:
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
  /// **Example** "key_holder_missing" — Key holder missing:
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
  /// **Example** "key_mailbox" — Key mailbox:
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
  /// **Example** "key_read" — Key read:
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
  /// **Example** "key_write" — Key write:
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
  /// **Example** "key_wrong_domain" — Key wrong domain:
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
  /// **Example** "mailbox_scope" — Mailbox scope:
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
  /// **Example** "null_body" — Null body:
  /// ```json
  /// null
  /// ```
  ///
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
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
  /// **Example** "read_only" — Read only:
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
  /// **Example** "rejected_email" — Rejected email:
  /// ```json
  /// {
  ///   "config": {},
  ///   "email": {},
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
  /// **Example** "unknown_filter" — Unknown filter:
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
  ///   "filter_name": "missing_filter"
  /// }
  /// ```
  ///
  /// **Example** "valid":
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
  /// **Example** "write_only" — Write only:
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
  /// **Example** "wrong_domain" — Wrong domain:
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
  /// **Example** "cookie_session" — Cookie session:
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
  /// **Example** "key_write" — Key write:
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
  /// **Example** "rejected_email" — Rejected email:
  /// ```json
  /// {
  ///   "data": {
  ///     "action": "reject",
  ///     "log": {
  ///       "detail": "missing From header; missing Date header",
  ///       "filter": "header_validate",
  ///       "result": "reject"
  ///     },
  ///     "reject_message": "550 Invalid headers: missing From header, missing Date header",
  ///     "type": "action"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "valid":
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
  /// **Example** "write_only" — Write only:
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
  /// **Example** "invalid_body":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "null_body" — Null body:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unknown_filter" — Unknown filter:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "filter_error",
  ///     "message": "create filter missing_filter: unknown filter: missing_filter"
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
  /// **Example** "csrf_missing" — Csrf missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope" — Domain scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain" — Key domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing" — Key holder missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox" — Key mailbox:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read" — Key read:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain" — Key wrong domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope" — Mailbox scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only" — Read only:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain" — Wrong domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
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
  /// **Example** "config_missing" — Config missing:
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
  /// **Example** "config_null" — Config null:
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
  /// **Example** "filter_name_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "email": "required",
  ///         "filter_name": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "filter_name_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filter_name": "must be a string"
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
  /// **Example** "execution_failure" — Execution failure:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "execution_panic" — Execution panic:
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
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "required_capability":
  /// Certificates require installation-wide domains:write; pipelines/custom filters require pipelines:delete. Read-only, other-resource and domain-scoped grants do not substitute.
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
  /// **Example** "other_capability":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only":
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
  /// **Example** "invalid_format":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "active_only" — Active only:
  /// ```json
  /// {
  ///   "active": false
  /// }
  /// ```
  ///
  /// **Example** "body_boundary" — Body boundary:
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
  /// **Example** "cancelled_after_lookup" — Cancelled after lookup:
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
  /// **Example** "concurrent" — Concurrent:
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
  /// **Example** "cookie_session" — Cookie session:
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
  /// **Example** "csrf_missing" — Csrf missing:
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
  /// **Example** "domain_scope" — Domain scope:
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
  /// **Example** "duplicate_unsupported" — Duplicate unsupported:
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": [
  ///     {
  ///       "config": {
  ///         "queue_recipient": "owner@example.com"
  ///       },
  ///       "name": "duplicate"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "empty_filters" — Empty filters:
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": []
  /// }
  /// ```
  ///
  /// **Example** "filters_null":
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": null
  /// }
  /// ```
  ///
  /// **Example** "filters_object":
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": {
  ///     "config": {},
  ///     "name": "spf_check"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_format" — Invalid format:
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
  /// **Example** "key_domain" — Key domain:
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
  /// **Example** "key_holder_missing" — Key holder missing:
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
  /// **Example** "key_mailbox" — Key mailbox:
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
  /// **Example** "key_read" — Key read:
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
  /// **Example** "key_write" — Key write:
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
  /// **Example** "key_wrong_domain" — Key wrong domain:
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
  /// **Example** "mailbox_scope" — Mailbox scope:
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
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
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
  /// **Example** "read_only" — Read only:
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
  /// **Example** "sieve_valid" — Sieve valid:
  /// ```json
  /// {
  ///   "active": false,
  ///   "filters": [
  ///     {
  ///       "config": {
  ///         "script": "keep;"
  ///       },
  ///       "name": "sieve"
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
  /// **Example** "unchanged" — Unchanged:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "update_unavailable" — Update unavailable:
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
  /// **Example** "updated":
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
  /// **Example** "write_only" — Write only:
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
  /// **Example** "wrong_domain" — Wrong domain:
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
  /// **Example** "active_only" — Active only:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
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
  /// **Example** "body_boundary" — Body boundary:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
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
  ///         "name": "spf_check"
  ///       }
  ///     ],
  ///     "id": 1,
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session" — Cookie session:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
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
  ///         "name": "spf_check"
  ///       }
  ///     ],
  ///     "id": 1,
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty_filters" — Empty filters:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
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
  ///     "filters": [],
  ///     "id": 1,
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write" — Key write:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
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
  ///         "name": "spf_check"
  ///       }
  ///     ],
  ///     "id": 1,
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sieve_valid" — Sieve valid:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
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
  ///         "config": {
  ///           "script": "keep;"
  ///         },
  ///         "name": "sieve"
  ///       }
  ///     ],
  ///     "id": 1,
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unchanged" — Unchanged:
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
  /// **Example** "updated":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
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
  ///         "name": "spf_check"
  ///       }
  ///     ],
  ///     "id": 1,
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only" — Write only:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
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
  ///         "name": "spf_check"
  ///       }
  ///     ],
  ///     "id": 1,
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "duplicate_unsupported" — Duplicate unsupported:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unsupported_filter",
  ///     "message": "the duplicate filter's queue_recipient is not supported; use webhook_url to fork a copy"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "csrf_missing" — Csrf missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope" — Domain scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain" — Key domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing" — Key holder missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox" — Key mailbox:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read" — Key read:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain" — Key wrong domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope" — Mailbox scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only" — Read only:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain" — Wrong domain:
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
  /// **Example** "concurrent" — Concurrent:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Pipeline not found"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "filters_null":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filters": "must be an array of filter objects"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "filters_object":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filters": "must be an array of filter objects"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_format" — Invalid format:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "cancelled_after_lookup" — Cancelled after lookup:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to update pipeline"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "update_unavailable" — Update unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to update pipeline"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
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
