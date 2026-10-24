import '../l10n/catalog.dart';
import '../l10n/localized_error.dart';

import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:restmail_api/restmail_api.dart';

/// Shows a sign-in page in the system browser: ASWebAuthenticationSession on
/// iOS, a Custom Tab (an Auth Tab where Chrome has them) on Android. Not a
/// web view, so the app never sees the password, and the provider can tell.
///
/// The session is ephemeral: it shares no cookies with the browser, so each
/// account signs in afresh rather than as whoever the browser last was.
Future<Uri> systemOAuthBrowser(Uri authorize, Uri redirect) async {
  try {
    final back = await FlutterWebAuth2.authenticate(
      url: '$authorize',
      callbackUrlScheme: redirect.scheme,
      options: const FlutterWebAuth2Options(preferEphemeral: true),
    );
    return Uri.parse(back);
  } on PlatformException catch (e) {
    if (e.code == 'CANCELED') {
      throw LocalizedApiException(
        0,
        'cancelled',
        UiText('client.signInWasCancelled'),
      );
    }
    throw LocalizedApiException(
      0,
      'browser_error',
      UiText('client.couldnTOpenTheSignInPage', {
        'value': (e.message ?? e.code).toString(),
      }),
    );
  } on FormatException {
    throw LocalizedApiException(
      0,
      'oauth_redirect',
      UiText('client.theSignInCameBackWithAn'),
    );
  }
}
