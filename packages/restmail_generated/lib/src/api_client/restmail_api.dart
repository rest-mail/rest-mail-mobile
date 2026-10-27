// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i6;

import 'package:http/http.dart' as _i9;
import 'package:restmail_generated/src/model/restmail_deliver_body.dart'
    as _i13;
import 'package:restmail_generated/src/operation/restmail_capabilities_operation.dart'
    as _i3;
import 'package:restmail_generated/src/operation/restmail_check_mailbox.dart'
    as _i4;
import 'package:restmail_generated/src/operation/restmail_deliver.dart' as _i5;
import 'package:restmail_generated/src/operation/restmail_discover.dart' as _i2;
import 'package:restmail_generated/src/response_wrapper/restmail_capabilities_operation_response.dart'
    as _i10;
import 'package:restmail_generated/src/response_wrapper/restmail_check_mailbox_response.dart'
    as _i11;
import 'package:restmail_generated/src/response_wrapper/restmail_deliver_response.dart'
    as _i12;
import 'package:restmail_generated/src/response_wrapper/restmail_discover_response.dart'
    as _i8;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i7;

class RestmailApi {
  RestmailApi(_i1.Server server)
    : _restmailDiscover = _i2.RestmailDiscover(
        server.baseUrl,
        () => server.client,
      ),
      _restmailCapabilitiesOperation = _i3.RestmailCapabilitiesOperation(
        server.baseUrl,
        () => server.client,
      ),
      _restmailCheckMailbox = _i4.RestmailCheckMailbox(
        server.baseUrl,
        () => server.client,
      ),
      _restmailDeliver = _i5.RestmailDeliver(
        server.baseUrl,
        () => server.client,
      );

  final _i2.RestmailDiscover _restmailDiscover;

  final _i3.RestmailCapabilitiesOperation _restmailCapabilitiesOperation;

  final _i4.RestmailCheckMailbox _restmailCheckMailbox;

  final _i5.RestmailDeliver _restmailDeliver;

  /// Discover RESTMAIL delivery for a hosted domain
  /// Fetched from the recipient domain's MX host over verified HTTPS. The answer is a protocol document without the data envelope, naming the configured GATEWAY_HOSTNAME, never the request's Host. A 404 means the domain is not hosted here; a missing hostname is 503 and a failed lookup 500, never 404. A domain given twice, or not a domain, is 400.
  ///
  /// Response 200 (application/json):
  /// **Example** "canonical_domain" — A domain is case-folded and its trailing dot removed:
  /// ```json
  /// {
  ///   "endpoint": "https://mx.example.test/restmail"
  /// }
  /// ```
  ///
  /// **Example** "example" — The configured public delivery endpoint is advertised:
  /// No session is required. The protocol document has no API data envelope. The configured gateway wins over caller Host and forwarding headers; every answer is no-store.
  ///
  /// ```json
  /// {
  ///   "endpoint": "https://mx.example.test/restmail"
  /// }
  /// ```
  ///
  /// **Example** "unicode_domain" — An internationalized domain resolves through its IDNA identity:
  /// ```json
  /// {
  ///   "endpoint": "https://mx.example.test/restmail"
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "empty_domain" — An explicitly empty domain is invalid:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid domain query parameter"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_domain" — A mailbox address is not a recipient domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid domain query parameter"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "repeated_domain" — The domain must be supplied exactly once:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Exactly one domain query parameter required"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "inactive" — An inactive hosted domain is not advertised:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Domain not hosted"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing" — An unknown domain is not advertised:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Domain not hosted"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "missing_domain" — A missing domain is refused by typed binding:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "domain": "required"
  ///       }
  ///     },
  ///     "message": "Query parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — A failed domain lookup never becomes a false404:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to look up domain"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "unconfigured" — The server has no valid public discovery hostname:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "RESTMAIL discovery hostname not configured"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i8.RestmailDiscoverResponse, _i9.Response>>
  restmailDiscover({
    required _i6.String domain,
    _i7.TonikCancellation? cancellation,
  }) async => _restmailDiscover(domain: domain, cancellation: cancellation);

  /// Get RESTMAIL server capabilities
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — The public operation answers without credentials:
  /// ```json
  /// {
  ///   "data": {
  ///     "features": [
  ///       "delivery",
  ///       "recipient-check"
  ///     ],
  ///     "protocol": "RESTMAIL",
  ///     "version": "1.0"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — An unexpected handler failure uses the shared error envelope:
  /// This fault response is exercised through the endpoint error adapter; a healthy GET does not provoke it. Metrics additionally exercises a failing scrape.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  _i6.Future<
    _i7.TonikResult<_i10.RestmailCapabilitiesOperationResponse, _i9.Response>
  >
  restmailCapabilitiesOperation({_i7.TonikCancellation? cancellation}) async =>
      _restmailCapabilitiesOperation(cancellation: cancellation);

  /// Check if a recipient mailbox exists
  ///
  /// Response 200 (application/json):
  /// **Example** "canonical_address" — Case-equivalent input uses the stored account identity:
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "user@example.test",
  ///     "exists": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "disabled" — A disabled recipient is unavailable:
  /// ```json
  /// {
  ///   "data": {
  ///     "exists": false
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found" — An active recipient returns its stored address:
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "user@example.test",
  ///     "exists": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_address" — A non-address remains an unavailable recipient:
  /// ```json
  /// {
  ///   "data": {
  ///     "exists": false
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing" — An absent recipient has no address field:
  /// ```json
  /// {
  ///   "data": {
  ///     "exists": false
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unicode_address" — NFC and IDNA normalization preserve the stored public identity:
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "café@xn--mnchen-3ya.test",
  ///     "exists": true
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "empty_address" — An empty address is refused before lookup:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "address": "address query parameter required"
  ///       }
  ///     },
  ///     "message": "Query parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing_address" — An omitted address is refused before lookup:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "address": "address query parameter required"
  ///       }
  ///     },
  ///     "message": "Query parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — A database fault cannot claim the mailbox is absent:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to look up mailbox"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i11.RestmailCheckMailboxResponse, _i9.Response>>
  restmailCheckMailbox({
    required _i6.String address,
    _i7.TonikCancellation? cancellation,
  }) async =>
      _restmailCheckMailbox(address: address, cancellation: cancellation);

  /// Deliver a message via RESTMAIL protocol
  /// Server-to-server delivery. Unauthenticated at the HTTP layer: a delivery must come from a trusted peer network or carry a DKIM signature aligned with its From domain, or it is refused 403 unauthorized. The inbound pipeline can refuse it 403 rejected or defer it 503 deferred. When no recipient takes the message the answer is 422 undeliverable.
  ///
  /// Request body (application/json):
  /// **Example** "delivered":
  /// ```json
  /// {
  ///   "body_text": "Hello, Eve.",
  ///   "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///   "from": "someone@ext-contract.test",
  ///   "message_id": "<restmail-delivery@ext-contract.test>",
  ///   "subject": "Delivered over RESTMAIL",
  ///   "to": [
  ///     "eve@restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "recipients_missing":
  /// ```json
  /// {
  ///   "body_text": "Hello, Eve.",
  ///   "date": "Sat, 17 Oct 2026 12:00:00 +0000",
  ///   "from": "someone@ext-contract.test",
  ///   "message_id": "<restmail-delivery@ext-contract.test>",
  ///   "subject": "Delivered over RESTMAIL"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "delivered":
  /// ```json
  /// {
  ///   "data": {
  ///     "delivered": [
  ///       "eve@restmail.test"
  ///     ],
  ///     "failed": []
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "recipients_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "to": "at least one recipient required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i12.RestmailDeliverResponse, _i9.Response>>
  restmailDeliver({
    required _i13.RestmailDeliverBody body,
    _i7.TonikCancellation? cancellation,
  }) async => _restmailDeliver(body: body, cancellation: cancellation);
}
