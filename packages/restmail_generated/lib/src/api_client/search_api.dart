// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:http/http.dart' as _i6;
import 'package:restmail_generated/src/model/api_v1_accounts_id_search_parameters_model.dart'
    as _i7;
import 'package:restmail_generated/src/operation/search_messages.dart' as _i2;
import 'package:restmail_generated/src/response_wrapper/search_messages_response.dart'
    as _i5;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i4;

class SearchApi {
  SearchApi(_i1.Server server)
    : _searchMessages = _i2.SearchMessages(server.baseUrl, () => server.client);

  final _i2.SearchMessages _searchMessages;

  /// Search messages
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  _i3.Future<_i4.TonikResult<_i5.SearchMessagesResponse, _i6.Response>>
  searchMessages({
    required _i3.int id,
    _i3.String? q,
    _i3.String? folder,
    _i3.String? from,
    _i3.DateTime? after,
    _i3.DateTime? before,
    _i7.ApiV1AccountsIdSearchParametersModel? hasAttachment,
    _i3.int? limit,
    _i4.TonikCancellation? cancellation,
  }) async => _searchMessages(
    id: id,
    q: q,
    folder: folder,
    from: from,
    after: after,
    before: before,
    hasAttachment: hasAttachment,
    limit: limit,
    cancellation: cancellation,
  );
}
