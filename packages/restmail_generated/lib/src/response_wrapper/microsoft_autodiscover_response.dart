// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/autodiscover_autodiscover_xml_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/autodiscover_autodiscover_xml_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/autodiscover_autodiscover_xml_post404_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/autodiscover_autodiscover_xml_post413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/autodiscover_autodiscover_xml_post500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/autodiscover_autodiscover_xml_post503_response.dart'
    as _i8;

sealed class MicrosoftAutodiscoverResponse {
  const MicrosoftAutodiscoverResponse();
}

@_i1.immutable
class MicrosoftAutodiscoverResponse200 extends MicrosoftAutodiscoverResponse {
  const MicrosoftAutodiscoverResponse200({required this.body});

  final _i2.AutodiscoverAutodiscoverXmlPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MicrosoftAutodiscoverResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MicrosoftAutodiscoverResponse400 extends MicrosoftAutodiscoverResponse {
  const MicrosoftAutodiscoverResponse400({required this.body});

  final _i4.AutodiscoverAutodiscoverXmlPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MicrosoftAutodiscoverResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MicrosoftAutodiscoverResponse404 extends MicrosoftAutodiscoverResponse {
  const MicrosoftAutodiscoverResponse404({required this.body});

  final _i5.AutodiscoverAutodiscoverXmlPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MicrosoftAutodiscoverResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MicrosoftAutodiscoverResponse413 extends MicrosoftAutodiscoverResponse {
  const MicrosoftAutodiscoverResponse413({required this.body});

  final _i6.AutodiscoverAutodiscoverXmlPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MicrosoftAutodiscoverResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MicrosoftAutodiscoverResponse500 extends MicrosoftAutodiscoverResponse {
  const MicrosoftAutodiscoverResponse500({required this.body});

  final _i7.AutodiscoverAutodiscoverXmlPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MicrosoftAutodiscoverResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MicrosoftAutodiscoverResponse503 extends MicrosoftAutodiscoverResponse {
  const MicrosoftAutodiscoverResponse503({required this.body});

  final _i8.AutodiscoverAutodiscoverXmlPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MicrosoftAutodiscoverResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
