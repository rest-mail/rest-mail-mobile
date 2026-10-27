// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/model/data_delivery_processed.dart'
    as _i2;
import 'package:restmail_generated/src/model/data_message.dart' as _i4;
import 'package:restmail_generated/src/model/error_response.dart' as _i5;
import 'package:restmail_generated/src/model/validation_error_response.dart'
    as _i6;

sealed class DeliverMessageResponse {
  const DeliverMessageResponse();
}

@_i1.immutable
class DeliverMessageResponse200 extends DeliverMessageResponse {
  const DeliverMessageResponse200({required this.body});

  final _i2.DataDeliveryProcessed body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse201 extends DeliverMessageResponse {
  const DeliverMessageResponse201({required this.body});

  final _i4.DataMessage body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse400 extends DeliverMessageResponse {
  const DeliverMessageResponse400({required this.body});

  final _i5.ErrorResponse body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse404 extends DeliverMessageResponse {
  const DeliverMessageResponse404({required this.body});

  final _i5.ErrorResponse body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse413 extends DeliverMessageResponse {
  const DeliverMessageResponse413({required this.body});

  final _i5.ErrorResponse body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse422 extends DeliverMessageResponse {
  const DeliverMessageResponse422({required this.body});

  final _i6.ValidationErrorResponse body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse451 extends DeliverMessageResponse {
  const DeliverMessageResponse451({required this.body});

  final _i5.ErrorResponse body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse451 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse500 extends DeliverMessageResponse {
  const DeliverMessageResponse500({required this.body});

  final _i5.ErrorResponse body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse550 extends DeliverMessageResponse {
  const DeliverMessageResponse550({required this.body});

  final _i5.ErrorResponse body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse550 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
