// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_retry_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_retry_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_retry_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_retry_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_retry_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_retry_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_retry_post500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_retry_post503_response.dart'
    as _i10;

sealed class BulkRetryQueueResponse {
  const BulkRetryQueueResponse();
}

@_i1.immutable
class BulkRetryQueueResponse200 extends BulkRetryQueueResponse {
  const BulkRetryQueueResponse200({required this.body});

  final _i2.ApiV1AdminQueueBulkRetryPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkRetryQueueResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkRetryQueueResponse400 extends BulkRetryQueueResponse {
  const BulkRetryQueueResponse400({required this.body});

  final _i4.ApiV1AdminQueueBulkRetryPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkRetryQueueResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkRetryQueueResponse401 extends BulkRetryQueueResponse {
  const BulkRetryQueueResponse401({required this.body});

  final _i5.ApiV1AdminQueueBulkRetryPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkRetryQueueResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkRetryQueueResponse403 extends BulkRetryQueueResponse {
  const BulkRetryQueueResponse403({required this.body});

  final _i6.ApiV1AdminQueueBulkRetryPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkRetryQueueResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkRetryQueueResponse413 extends BulkRetryQueueResponse {
  const BulkRetryQueueResponse413({required this.body});

  final _i7.ApiV1AdminQueueBulkRetryPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkRetryQueueResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkRetryQueueResponse422 extends BulkRetryQueueResponse {
  const BulkRetryQueueResponse422({required this.body});

  final _i8.ApiV1AdminQueueBulkRetryPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkRetryQueueResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkRetryQueueResponse500 extends BulkRetryQueueResponse {
  const BulkRetryQueueResponse500({required this.body});

  final _i9.ApiV1AdminQueueBulkRetryPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkRetryQueueResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkRetryQueueResponse503 extends BulkRetryQueueResponse {
  const BulkRetryQueueResponse503({required this.body});

  final _i10.ApiV1AdminQueueBulkRetryPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkRetryQueueResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
