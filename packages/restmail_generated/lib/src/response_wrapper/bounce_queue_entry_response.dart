// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_bounce_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_bounce_post401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_bounce_post403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_bounce_post404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_bounce_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_bounce_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_bounce_post500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_bounce_post503_response.dart'
    as _i10;

sealed class BounceQueueEntryResponse {
  const BounceQueueEntryResponse();
}

@_i1.immutable
class BounceQueueEntryResponse200 extends BounceQueueEntryResponse {
  const BounceQueueEntryResponse200({required this.body});

  final _i2.ApiV1AdminQueueIdBouncePost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BounceQueueEntryResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BounceQueueEntryResponse401 extends BounceQueueEntryResponse {
  const BounceQueueEntryResponse401({required this.body});

  final _i4.ApiV1AdminQueueIdBouncePost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BounceQueueEntryResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BounceQueueEntryResponse403 extends BounceQueueEntryResponse {
  const BounceQueueEntryResponse403({required this.body});

  final _i5.ApiV1AdminQueueIdBouncePost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BounceQueueEntryResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BounceQueueEntryResponse404 extends BounceQueueEntryResponse {
  const BounceQueueEntryResponse404({required this.body});

  final _i6.ApiV1AdminQueueIdBouncePost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BounceQueueEntryResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BounceQueueEntryResponse413 extends BounceQueueEntryResponse {
  const BounceQueueEntryResponse413({required this.body});

  final _i7.ApiV1AdminQueueIdBouncePost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BounceQueueEntryResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BounceQueueEntryResponse422 extends BounceQueueEntryResponse {
  const BounceQueueEntryResponse422({required this.body});

  final _i8.ApiV1AdminQueueIdBouncePost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BounceQueueEntryResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BounceQueueEntryResponse500 extends BounceQueueEntryResponse {
  const BounceQueueEntryResponse500({required this.body});

  final _i9.ApiV1AdminQueueIdBouncePost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BounceQueueEntryResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BounceQueueEntryResponse503 extends BounceQueueEntryResponse {
  const BounceQueueEntryResponse503({required this.body});

  final _i10.ApiV1AdminQueueIdBouncePost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BounceQueueEntryResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
