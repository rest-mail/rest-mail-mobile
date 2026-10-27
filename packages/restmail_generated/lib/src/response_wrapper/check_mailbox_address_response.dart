// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/model/data_address_check.dart' as _i2;
import 'package:restmail_generated/src/model/error_response.dart' as _i4;
import 'package:restmail_generated/src/model/validation_error_response.dart'
    as _i5;

sealed class CheckMailboxAddressResponse {
  const CheckMailboxAddressResponse();
}

@_i1.immutable
class CheckMailboxAddressResponse200 extends CheckMailboxAddressResponse {
  const CheckMailboxAddressResponse200({required this.body});

  final _i2.DataAddressCheck body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CheckMailboxAddressResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CheckMailboxAddressResponse400 extends CheckMailboxAddressResponse {
  const CheckMailboxAddressResponse400({required this.body});

  final _i4.ErrorResponse body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CheckMailboxAddressResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CheckMailboxAddressResponse422 extends CheckMailboxAddressResponse {
  const CheckMailboxAddressResponse422({required this.body});

  final _i5.ValidationErrorResponse body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CheckMailboxAddressResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CheckMailboxAddressResponse500 extends CheckMailboxAddressResponse {
  const CheckMailboxAddressResponse500({required this.body});

  final _i4.ErrorResponse body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CheckMailboxAddressResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
