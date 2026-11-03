// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_put200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_put400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_put401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_put403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_put404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_put413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_put422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_put429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_put500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_put503_response.dart'
    as _i12;

sealed class SetQuietHoursResponse {
  const SetQuietHoursResponse();
}

@_i1.immutable
class SetQuietHoursResponse200 extends SetQuietHoursResponse {
  const SetQuietHoursResponse200({required this.body});

  final _i2.ApiV1AccountsIdQuietHoursPut200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetQuietHoursResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetQuietHoursResponse400 extends SetQuietHoursResponse {
  const SetQuietHoursResponse400({required this.body});

  final _i4.ApiV1AccountsIdQuietHoursPut400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetQuietHoursResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetQuietHoursResponse401 extends SetQuietHoursResponse {
  const SetQuietHoursResponse401({required this.body});

  final _i5.ApiV1AccountsIdQuietHoursPut401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetQuietHoursResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetQuietHoursResponse403 extends SetQuietHoursResponse {
  const SetQuietHoursResponse403({required this.body});

  final _i6.ApiV1AccountsIdQuietHoursPut403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetQuietHoursResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetQuietHoursResponse404 extends SetQuietHoursResponse {
  const SetQuietHoursResponse404({required this.body});

  final _i7.ApiV1AccountsIdQuietHoursPut404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetQuietHoursResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetQuietHoursResponse413 extends SetQuietHoursResponse {
  const SetQuietHoursResponse413({required this.body});

  final _i8.ApiV1AccountsIdQuietHoursPut413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetQuietHoursResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetQuietHoursResponse422 extends SetQuietHoursResponse {
  const SetQuietHoursResponse422({required this.body});

  final _i9.ApiV1AccountsIdQuietHoursPut422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetQuietHoursResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetQuietHoursResponse429 extends SetQuietHoursResponse {
  const SetQuietHoursResponse429({required this.body});

  final _i10.ApiV1AccountsIdQuietHoursPut429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetQuietHoursResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetQuietHoursResponse500 extends SetQuietHoursResponse {
  const SetQuietHoursResponse500({required this.body});

  final _i11.ApiV1AccountsIdQuietHoursPut500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetQuietHoursResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetQuietHoursResponse503 extends SetQuietHoursResponse {
  const SetQuietHoursResponse503({required this.body});

  final _i12.ApiV1AccountsIdQuietHoursPut503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetQuietHoursResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
