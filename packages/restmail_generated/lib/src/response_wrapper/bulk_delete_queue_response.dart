// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_delete_delete200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_delete_delete400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_delete_delete401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_delete_delete403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_delete_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_delete_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_delete_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_queue_bulk_delete_delete503_response.dart'
    as _i10;

sealed class BulkDeleteQueueResponse {
  const BulkDeleteQueueResponse();
}

@_i1.immutable
class BulkDeleteQueueResponse200 extends BulkDeleteQueueResponse {
  const BulkDeleteQueueResponse200({required this.body});

  final _i2.ApiV1AdminQueueBulkDeleteDelete200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkDeleteQueueResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkDeleteQueueResponse400 extends BulkDeleteQueueResponse {
  const BulkDeleteQueueResponse400({required this.body});

  final _i4.ApiV1AdminQueueBulkDeleteDelete400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkDeleteQueueResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkDeleteQueueResponse401 extends BulkDeleteQueueResponse {
  const BulkDeleteQueueResponse401({required this.body});

  final _i5.ApiV1AdminQueueBulkDeleteDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkDeleteQueueResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkDeleteQueueResponse403 extends BulkDeleteQueueResponse {
  const BulkDeleteQueueResponse403({required this.body});

  final _i6.ApiV1AdminQueueBulkDeleteDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkDeleteQueueResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkDeleteQueueResponse413 extends BulkDeleteQueueResponse {
  const BulkDeleteQueueResponse413({required this.body});

  final _i7.ApiV1AdminQueueBulkDeleteDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkDeleteQueueResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkDeleteQueueResponse422 extends BulkDeleteQueueResponse {
  const BulkDeleteQueueResponse422({required this.body});

  final _i8.ApiV1AdminQueueBulkDeleteDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkDeleteQueueResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkDeleteQueueResponse500 extends BulkDeleteQueueResponse {
  const BulkDeleteQueueResponse500({required this.body});

  final _i9.ApiV1AdminQueueBulkDeleteDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkDeleteQueueResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BulkDeleteQueueResponse503 extends BulkDeleteQueueResponse {
  const BulkDeleteQueueResponse503({required this.body});

  final _i10.ApiV1AdminQueueBulkDeleteDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BulkDeleteQueueResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
