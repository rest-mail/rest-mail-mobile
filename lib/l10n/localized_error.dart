import 'package:restmail_api/restmail_api.dart';

import 'catalog.dart';

/// An error authored by the client, distinct from an unmodified server error.
class LocalizedApiException extends ApiException {
  LocalizedApiException(
    int statusCode,
    String code,
    Object message, {
    super.fields,
    super.retryAfter,
  }) : text = message is UiText ? message : null,
       super(
         statusCode,
         code,
         message is UiText ? message.inEnglish : message as String,
       );

  final UiText? text;
}
