// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_queue_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_queue_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_queue_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_queue_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_queue_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_queue_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_queue_get503_response.dart'
    as _i9;

sealed class ListQueueResponse {
  const ListQueueResponse();
}

@_i1.immutable
class ListQueueResponse200 extends ListQueueResponse {
  const ListQueueResponse200({required this.body});

  final _i2.ApiV1AdminQueueGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQueueResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQueueResponse401 extends ListQueueResponse {
  const ListQueueResponse401({required this.body});

  final _i4.ApiV1AdminQueueGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQueueResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQueueResponse403 extends ListQueueResponse {
  const ListQueueResponse403({required this.body});

  final _i5.ApiV1AdminQueueGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQueueResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQueueResponse413 extends ListQueueResponse {
  const ListQueueResponse413({required this.body});

  final _i6.ApiV1AdminQueueGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQueueResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQueueResponse422 extends ListQueueResponse {
  const ListQueueResponse422({required this.body});

  final _i7.ApiV1AdminQueueGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQueueResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQueueResponse500 extends ListQueueResponse {
  const ListQueueResponse500({required this.body});

  final _i8.ApiV1AdminQueueGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQueueResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQueueResponse503 extends ListQueueResponse {
  const ListQueueResponse503({required this.body});

  final _i9.ApiV1AdminQueueGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQueueResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
