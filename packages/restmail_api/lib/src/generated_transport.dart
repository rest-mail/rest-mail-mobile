import 'package:http/http.dart' as http;

/// Borrows the account's transport without owning its TLS connection pool.
/// Generated requests retain their encoded path, repeated query parameters and
/// exact body bytes. Session renewal and errors remain the account's policy.
class GeneratedTransport extends http.BaseClient {
  GeneratedTransport(this._send);

  final Future<http.Response> Function(http.BaseRequest) _send;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _send(request);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      contentLength: response.bodyBytes.length,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }

  @override
  void close() {}
}
