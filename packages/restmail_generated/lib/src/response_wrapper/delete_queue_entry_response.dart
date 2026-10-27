// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_delete503_response.dart'
    as _i10;

sealed class DeleteQueueEntryResponse {
  const DeleteQueueEntryResponse();
}

@_i1.immutable
class DeleteQueueEntryResponse204 extends DeleteQueueEntryResponse {
  const DeleteQueueEntryResponse204({required this.body});

  final _i2.ApiV1AdminQueueIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQueueEntryResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQueueEntryResponse401 extends DeleteQueueEntryResponse {
  const DeleteQueueEntryResponse401({required this.body});

  final _i4.ApiV1AdminQueueIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQueueEntryResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQueueEntryResponse403 extends DeleteQueueEntryResponse {
  const DeleteQueueEntryResponse403({required this.body});

  final _i5.ApiV1AdminQueueIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQueueEntryResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQueueEntryResponse404 extends DeleteQueueEntryResponse {
  const DeleteQueueEntryResponse404({required this.body});

  final _i6.ApiV1AdminQueueIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQueueEntryResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQueueEntryResponse413 extends DeleteQueueEntryResponse {
  const DeleteQueueEntryResponse413({required this.body});

  final _i7.ApiV1AdminQueueIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQueueEntryResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQueueEntryResponse422 extends DeleteQueueEntryResponse {
  const DeleteQueueEntryResponse422({required this.body});

  final _i8.ApiV1AdminQueueIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQueueEntryResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQueueEntryResponse500 extends DeleteQueueEntryResponse {
  const DeleteQueueEntryResponse500({required this.body});

  final _i9.ApiV1AdminQueueIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQueueEntryResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQueueEntryResponse503 extends DeleteQueueEntryResponse {
  const DeleteQueueEntryResponse503({required this.body});

  final _i10.ApiV1AdminQueueIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQueueEntryResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
