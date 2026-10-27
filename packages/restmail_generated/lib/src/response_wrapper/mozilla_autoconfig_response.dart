// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/mail_config_v11_xml_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/mail_config_v11_xml_get400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/mail_config_v11_xml_get404_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/mail_config_v11_xml_get500_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/mail_config_v11_xml_get503_response.dart'
    as _i7;

sealed class MozillaAutoconfigResponse {
  const MozillaAutoconfigResponse();
}

@_i1.immutable
class MozillaAutoconfigResponse200 extends MozillaAutoconfigResponse {
  const MozillaAutoconfigResponse200({required this.body});

  final _i2.MailConfigV11XmlGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MozillaAutoconfigResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MozillaAutoconfigResponse400 extends MozillaAutoconfigResponse {
  const MozillaAutoconfigResponse400({required this.body});

  final _i4.MailConfigV11XmlGet400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MozillaAutoconfigResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MozillaAutoconfigResponse404 extends MozillaAutoconfigResponse {
  const MozillaAutoconfigResponse404({required this.body});

  final _i5.MailConfigV11XmlGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MozillaAutoconfigResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MozillaAutoconfigResponse500 extends MozillaAutoconfigResponse {
  const MozillaAutoconfigResponse500({required this.body});

  final _i6.MailConfigV11XmlGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MozillaAutoconfigResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MozillaAutoconfigResponse503 extends MozillaAutoconfigResponse {
  const MozillaAutoconfigResponse503({required this.body});

  final _i7.MailConfigV11XmlGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MozillaAutoconfigResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
