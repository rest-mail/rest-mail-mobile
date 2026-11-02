// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_oauth_token_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_oauth_token_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_oauth_token_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_oauth_token_post413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_oauth_token_post429_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_oauth_token_post500_response.dart'
    as _i8;

sealed class IssueClientCredentialsTokenResponse {
  const IssueClientCredentialsTokenResponse();
}

@_i1.immutable
class IssueClientCredentialsTokenResponse200
    extends IssueClientCredentialsTokenResponse {
  const IssueClientCredentialsTokenResponse200({required this.body});

  final _i2.ApiV1OauthTokenPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is IssueClientCredentialsTokenResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class IssueClientCredentialsTokenResponse400
    extends IssueClientCredentialsTokenResponse {
  const IssueClientCredentialsTokenResponse400({required this.body});

  final _i4.ApiV1OauthTokenPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is IssueClientCredentialsTokenResponse400 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class IssueClientCredentialsTokenResponse401
    extends IssueClientCredentialsTokenResponse {
  const IssueClientCredentialsTokenResponse401({required this.body});

  final _i5.ApiV1OauthTokenPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is IssueClientCredentialsTokenResponse401 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class IssueClientCredentialsTokenResponse413
    extends IssueClientCredentialsTokenResponse {
  const IssueClientCredentialsTokenResponse413({required this.body});

  final _i6.ApiV1OauthTokenPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is IssueClientCredentialsTokenResponse413 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class IssueClientCredentialsTokenResponse429
    extends IssueClientCredentialsTokenResponse {
  const IssueClientCredentialsTokenResponse429({required this.body});

  final _i7.ApiV1OauthTokenPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is IssueClientCredentialsTokenResponse429 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class IssueClientCredentialsTokenResponse500
    extends IssueClientCredentialsTokenResponse {
  const IssueClientCredentialsTokenResponse500({required this.body});

  final _i8.ApiV1OauthTokenPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is IssueClientCredentialsTokenResponse500 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
