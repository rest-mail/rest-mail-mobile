// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/well_known_autoconfig_mail_config_v11_xml_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/well_known_autoconfig_mail_config_v11_xml_get400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/well_known_autoconfig_mail_config_v11_xml_get404_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/well_known_autoconfig_mail_config_v11_xml_get500_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/well_known_autoconfig_mail_config_v11_xml_get503_response.dart'
    as _i7;

sealed class MozillaAutoconfigWellKnownResponse {
  const MozillaAutoconfigWellKnownResponse();
}

@_i1.immutable
class MozillaAutoconfigWellKnownResponse200
    extends MozillaAutoconfigWellKnownResponse {
  const MozillaAutoconfigWellKnownResponse200({required this.body});

  final _i2.WellKnownAutoconfigMailConfigV11XmlGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MozillaAutoconfigWellKnownResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MozillaAutoconfigWellKnownResponse400
    extends MozillaAutoconfigWellKnownResponse {
  const MozillaAutoconfigWellKnownResponse400({required this.body});

  final _i4.WellKnownAutoconfigMailConfigV11XmlGet400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MozillaAutoconfigWellKnownResponse400 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MozillaAutoconfigWellKnownResponse404
    extends MozillaAutoconfigWellKnownResponse {
  const MozillaAutoconfigWellKnownResponse404({required this.body});

  final _i5.WellKnownAutoconfigMailConfigV11XmlGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MozillaAutoconfigWellKnownResponse404 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MozillaAutoconfigWellKnownResponse500
    extends MozillaAutoconfigWellKnownResponse {
  const MozillaAutoconfigWellKnownResponse500({required this.body});

  final _i6.WellKnownAutoconfigMailConfigV11XmlGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MozillaAutoconfigWellKnownResponse500 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MozillaAutoconfigWellKnownResponse503
    extends MozillaAutoconfigWellKnownResponse {
  const MozillaAutoconfigWellKnownResponse503({required this.body});

  final _i7.WellKnownAutoconfigMailConfigV11XmlGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MozillaAutoconfigWellKnownResponse503 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
