// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:http/http.dart' as _i6;
import 'package:restmail_generated/src/operation/check_mailbox_address.dart'
    as _i2;
import 'package:restmail_generated/src/response_wrapper/check_mailbox_address_response.dart'
    as _i5;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i4;

class MailboxesApi {
  MailboxesApi(_i1.Server server)
    : _checkMailboxAddress = _i2.CheckMailboxAddress(
        server.baseUrl,
        () => server.client,
      );

  final _i2.CheckMailboxAddress _checkMailboxAddress;

  /// Check whether an address is a mailbox here (protocol gateways)
  /// Machine to machine: no user token. An address that is not a mailbox here is 200 with exists false: the gateway then routes it outbound.
  ///
  /// Response 200 (application/json):
  /// **Example** "found":
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "user@example.com",
  ///     "exists": true,
  ///     "mailbox_id": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "inactive":
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "disabled@example.com",
  ///     "exists": false
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_address":
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "not-an-address",
  ///     "exists": false
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "not_local":
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "external@example.net",
  ///     "exists": false
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "address_empty":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "address query parameter required"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "address_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "address": "required"
  ///       }
  ///     },
  ///     "message": "Query parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "address_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to check address"
  ///   }
  /// }
  /// ```
  _i3.Future<_i4.TonikResult<_i5.CheckMailboxAddressResponse, _i6.Response>>
  checkMailboxAddress({
    required _i3.String address,
    _i4.TonikCancellation? cancellation,
  }) async =>
      _checkMailboxAddress(address: address, cancellation: cancellation);
}
