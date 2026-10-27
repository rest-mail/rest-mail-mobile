// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_bounce_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_bounce_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_bounce_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_bounce_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_bounce_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_bounce_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_bounce_post500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_bounce_post503_response.dart'
    as _i10;

sealed class BulkBounceQueueResponse {
  const BulkBounceQueueResponse();
}

@_i1.immutable
class BulkBounceQueueResponse200 extends BulkBounceQueueResponse {
  const BulkBounceQueueResponse200({required this.body});

  final _i2.ApiV1AdminQueueBulkBouncePost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkBounceQueueResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkBounceQueueResponse400 extends BulkBounceQueueResponse {
  const BulkBounceQueueResponse400({required this.body});

  final _i4.ApiV1AdminQueueBulkBouncePost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkBounceQueueResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkBounceQueueResponse401 extends BulkBounceQueueResponse {
  const BulkBounceQueueResponse401({required this.body});

  final _i5.ApiV1AdminQueueBulkBouncePost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkBounceQueueResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkBounceQueueResponse403 extends BulkBounceQueueResponse {
  const BulkBounceQueueResponse403({required this.body});

  final _i6.ApiV1AdminQueueBulkBouncePost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkBounceQueueResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkBounceQueueResponse413 extends BulkBounceQueueResponse {
  const BulkBounceQueueResponse413({required this.body});

  final _i7.ApiV1AdminQueueBulkBouncePost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkBounceQueueResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkBounceQueueResponse422 extends BulkBounceQueueResponse {
  const BulkBounceQueueResponse422({required this.body});

  final _i8.ApiV1AdminQueueBulkBouncePost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkBounceQueueResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkBounceQueueResponse500 extends BulkBounceQueueResponse {
  const BulkBounceQueueResponse500({required this.body});

  final _i9.ApiV1AdminQueueBulkBouncePost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkBounceQueueResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkBounceQueueResponse503 extends BulkBounceQueueResponse {
  const BulkBounceQueueResponse503({required this.body});

  final _i10.ApiV1AdminQueueBulkBouncePost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkBounceQueueResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
