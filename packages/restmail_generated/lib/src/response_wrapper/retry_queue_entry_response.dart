// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_retry_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_retry_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_retry_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_retry_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_retry_post404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_retry_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_retry_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_retry_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_retry_post503_response.dart'
    as _i11;

sealed class RetryQueueEntryResponse {
  const RetryQueueEntryResponse();
}

@_i1.immutable
class RetryQueueEntryResponse200 extends RetryQueueEntryResponse {
  const RetryQueueEntryResponse200({required this.body});

  final _i2.ApiV1AdminQueueIdRetryPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RetryQueueEntryResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RetryQueueEntryResponse400 extends RetryQueueEntryResponse {
  const RetryQueueEntryResponse400({required this.body});

  final _i4.ApiV1AdminQueueIdRetryPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RetryQueueEntryResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RetryQueueEntryResponse401 extends RetryQueueEntryResponse {
  const RetryQueueEntryResponse401({required this.body});

  final _i5.ApiV1AdminQueueIdRetryPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RetryQueueEntryResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RetryQueueEntryResponse403 extends RetryQueueEntryResponse {
  const RetryQueueEntryResponse403({required this.body});

  final _i6.ApiV1AdminQueueIdRetryPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RetryQueueEntryResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RetryQueueEntryResponse404 extends RetryQueueEntryResponse {
  const RetryQueueEntryResponse404({required this.body});

  final _i7.ApiV1AdminQueueIdRetryPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RetryQueueEntryResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RetryQueueEntryResponse413 extends RetryQueueEntryResponse {
  const RetryQueueEntryResponse413({required this.body});

  final _i8.ApiV1AdminQueueIdRetryPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RetryQueueEntryResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RetryQueueEntryResponse422 extends RetryQueueEntryResponse {
  const RetryQueueEntryResponse422({required this.body});

  final _i9.ApiV1AdminQueueIdRetryPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RetryQueueEntryResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RetryQueueEntryResponse500 extends RetryQueueEntryResponse {
  const RetryQueueEntryResponse500({required this.body});

  final _i10.ApiV1AdminQueueIdRetryPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RetryQueueEntryResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RetryQueueEntryResponse503 extends RetryQueueEntryResponse {
  const RetryQueueEntryResponse503({required this.body});

  final _i11.ApiV1AdminQueueIdRetryPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RetryQueueEntryResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
