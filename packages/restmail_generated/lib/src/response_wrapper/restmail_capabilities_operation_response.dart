// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/restmail_capabilities_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/restmail_capabilities_get500_response.dart'
    as _i4;

sealed class RestmailCapabilitiesOperationResponse {
  const RestmailCapabilitiesOperationResponse();
}

@_i1.immutable
class RestmailCapabilitiesOperationResponse200
    extends RestmailCapabilitiesOperationResponse {
  const RestmailCapabilitiesOperationResponse200({required this.body});

  final _i2.RestmailCapabilitiesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailCapabilitiesOperationResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailCapabilitiesOperationResponse500
    extends RestmailCapabilitiesOperationResponse {
  const RestmailCapabilitiesOperationResponse500({required this.body});

  final _i4.RestmailCapabilitiesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailCapabilitiesOperationResponse500 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
