// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_calendar_events_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_calendar_events_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_calendar_events_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_calendar_events_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_calendar_events_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_calendar_events_get429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_calendar_events_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_calendar_events_get503_response.dart'
    as _i10;

sealed class ListCalendarEventsResponse {
  const ListCalendarEventsResponse();
}

@_i1.immutable
class ListCalendarEventsResponse200 extends ListCalendarEventsResponse {
  const ListCalendarEventsResponse200({required this.body});

  final _i2.ApiV1AccountsIdCalendarEventsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCalendarEventsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCalendarEventsResponse401 extends ListCalendarEventsResponse {
  const ListCalendarEventsResponse401({required this.body});

  final _i4.ApiV1AccountsIdCalendarEventsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCalendarEventsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCalendarEventsResponse403 extends ListCalendarEventsResponse {
  const ListCalendarEventsResponse403({required this.body});

  final _i5.ApiV1AccountsIdCalendarEventsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCalendarEventsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCalendarEventsResponse413 extends ListCalendarEventsResponse {
  const ListCalendarEventsResponse413({required this.body});

  final _i6.ApiV1AccountsIdCalendarEventsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCalendarEventsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCalendarEventsResponse422 extends ListCalendarEventsResponse {
  const ListCalendarEventsResponse422({required this.body});

  final _i7.ApiV1AccountsIdCalendarEventsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCalendarEventsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCalendarEventsResponse429 extends ListCalendarEventsResponse {
  const ListCalendarEventsResponse429({required this.body});

  final _i8.ApiV1AccountsIdCalendarEventsGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCalendarEventsResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCalendarEventsResponse500 extends ListCalendarEventsResponse {
  const ListCalendarEventsResponse500({required this.body});

  final _i9.ApiV1AccountsIdCalendarEventsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCalendarEventsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCalendarEventsResponse503 extends ListCalendarEventsResponse {
  const ListCalendarEventsResponse503({required this.body});

  final _i10.ApiV1AccountsIdCalendarEventsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCalendarEventsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
