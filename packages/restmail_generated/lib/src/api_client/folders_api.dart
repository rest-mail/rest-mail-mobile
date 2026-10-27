// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i6;

import 'package:http/http.dart' as _i9;
import 'package:restmail_generated/src/model/folder_name_body.dart' as _i11;
import 'package:restmail_generated/src/operation/create_folder.dart' as _i3;
import 'package:restmail_generated/src/operation/delete_folder.dart' as _i4;
import 'package:restmail_generated/src/operation/list_folders.dart' as _i2;
import 'package:restmail_generated/src/operation/rename_folder.dart' as _i5;
import 'package:restmail_generated/src/response_wrapper/create_folder_response.dart'
    as _i10;
import 'package:restmail_generated/src/response_wrapper/delete_folder_response.dart'
    as _i12;
import 'package:restmail_generated/src/response_wrapper/list_folders_response.dart'
    as _i8;
import 'package:restmail_generated/src/response_wrapper/rename_folder_response.dart'
    as _i13;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i7;

class FoldersApi {
  FoldersApi(_i1.Server server)
    : _listFolders = _i2.ListFolders(server.baseUrl, () => server.client),
      _createFolder = _i3.CreateFolder(server.baseUrl, () => server.client),
      _deleteFolder = _i4.DeleteFolder(server.baseUrl, () => server.client),
      _renameFolder = _i5.RenameFolder(server.baseUrl, () => server.client);

  final _i2.ListFolders _listFolders;

  final _i3.CreateFolder _createFolder;

  final _i4.DeleteFolder _deleteFolder;

  final _i5.RenameFolder _renameFolder;

  /// List folders for an account
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "name": "Archive",
  ///       "total": 2,
  ///       "unread": 1
  ///     },
  ///     {
  ///       "name": "INBOX",
  ///       "total": 5,
  ///       "unread": 2
  ///     },
  ///     {
  ///       "name": "Projects/2026",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Sent",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Drafts",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Trash",
  ///       "total": 0,
  ///       "unread": 0
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "name": "Archive",
  ///       "total": 2,
  ///       "unread": 1
  ///     },
  ///     {
  ///       "name": "INBOX",
  ///       "total": 5,
  ///       "unread": 2
  ///     },
  ///     {
  ///       "name": "Projects/2026",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Sent",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Drafts",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Trash",
  ///       "total": 0,
  ///       "unread": 0
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "name": "Archive",
  ///       "total": 2,
  ///       "unread": 1
  ///     },
  ///     {
  ///       "name": "INBOX",
  ///       "total": 5,
  ///       "unread": 2
  ///     },
  ///     {
  ///       "name": "Projects/2026",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Sent",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Drafts",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Trash",
  ///       "total": 0,
  ///       "unread": 0
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "empty" — A successful empty aggregation still lists the four ordinary standard folders:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "name": "INBOX",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Sent",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Drafts",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Trash",
  ///       "total": 0,
  ///       "unread": 0
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "found" — Grouped counts retain populated folders and zero-count hierarchy markers without duplicating INBOX:
  /// Actual production routes, repositories and credential/grant checks map controlled rows. SQL restrictions and returned fields are asserted, but PostgreSQL aggregation, filtering, ordering and persistence are not claimed.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "name": "Archive",
  ///       "total": 2,
  ///       "unread": 1
  ///     },
  ///     {
  ///       "name": "INBOX",
  ///       "total": 5,
  ///       "unread": 2
  ///     },
  ///     {
  ///       "name": "Projects/2026",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Sent",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Drafts",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Trash",
  ///       "total": 0,
  ///       "unread": 0
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "name": "Archive",
  ///       "total": 2,
  ///       "unread": 1
  ///     },
  ///     {
  ///       "name": "INBOX",
  ///       "total": 5,
  ///       "unread": 2
  ///     },
  ///     {
  ///       "name": "Projects/2026",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Sent",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Drafts",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Trash",
  ///       "total": 0,
  ///       "unread": 0
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "name": "Archive",
  ///       "total": 2,
  ///       "unread": 1
  ///     },
  ///     {
  ///       "name": "INBOX",
  ///       "total": 5,
  ///       "unread": 2
  ///     },
  ///     {
  ///       "name": "Projects/2026",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Sent",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Drafts",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Trash",
  ///       "total": 0,
  ///       "unread": 0
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "name": "Archive",
  ///       "total": 2,
  ///       "unread": 1
  ///     },
  ///     {
  ///       "name": "INBOX",
  ///       "total": 5,
  ///       "unread": 2
  ///     },
  ///     {
  ///       "name": "Projects/2026",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Sent",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Drafts",
  ///       "total": 0,
  ///       "unread": 0
  ///     },
  ///     {
  ///       "name": "Trash",
  ///       "total": 0,
  ///       "unread": 0
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_format":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "content_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i8.ListFoldersResponse, _i9.Response>>
  listFolders({
    required _i6.int id,
    _i7.TonikCancellation? cancellation,
  }) async => _listFolders(id: id, cancellation: cancellation);

  /// Create a new folder
  /// The name is valid UTF-8 of at most 255 bytes, neither blank nor beginning or ending with a space, with no control character and no ".."; a "/" is the hierarchy delimiter IMAP clients show. Any other name is 422. A folder that already exists is 409 already_exists, INBOX in any case, Sent, Drafts and Trash among them: they are listed empty or not.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "name": "Receipts"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "destination_exists":
  /// ```json
  /// {
  ///   "name": "Existing"
  /// }
  /// ```
  ///
  /// **Example** "destination_unavailable":
  /// ```json
  /// {
  ///   "name": "LookupFailure"
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real production routes authenticate JWT/Basic/scoped keys and check current holder grants and CSRF before folder storage. Local SQL verifies exact mailbox/name counts, deleted zero-byte markers and message/marker rename selectors, including lookup/write failures. Fixed rows do not prove PostgreSQL durability or concurrency serialization.
  ///
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "literal_folder":
  /// ```json
  /// {
  ///   "name": "Work/2026"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type. The route and Vertrag transport hook send those exact bytes rather than JSON-quoting them.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "name_boundary":
  /// ```json
  /// {
  ///   "name": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  /// }
  /// ```
  ///
  /// **Example** "name_control":
  /// ```json
  /// {
  ///   "name": "New\nfolder"
  /// }
  /// ```
  ///
  /// **Example** "name_empty":
  /// An empty string validates against the published string type but is refused as required by the runtime folder-name rule.
  ///
  /// ```json
  /// {
  ///   "name": ""
  /// }
  /// ```
  ///
  /// **Example** "name_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "name_parent":
  /// ```json
  /// {
  ///   "name": "Work/../Other"
  /// }
  /// ```
  ///
  /// **Example** "name_space":
  /// ```json
  /// {
  ///   "name": " New"
  /// }
  /// ```
  ///
  /// **Example** "name_too_long":
  /// ```json
  /// {
  ///   "name": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  /// }
  /// ```
  ///
  /// **Example** "name_wrong_type":
  /// ```json
  /// {
  ///   "name": 12
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "standard_archive":
  /// ```json
  /// {
  ///   "name": "Archive"
  /// }
  /// ```
  ///
  /// **Example** "standard_drafts":
  /// ```json
  /// {
  ///   "name": "Drafts"
  /// }
  /// ```
  ///
  /// **Example** "standard_inbox":
  /// ```json
  /// {
  ///   "name": "INBOX"
  /// }
  /// ```
  ///
  /// **Example** "standard_inbox_case":
  /// ```json
  /// {
  ///   "name": "iNbOx"
  /// }
  /// ```
  ///
  /// **Example** "standard_sent":
  /// ```json
  /// {
  ///   "name": "Sent"
  /// }
  /// ```
  ///
  /// **Example** "standard_spam":
  /// ```json
  /// {
  ///   "name": "Spam"
  /// }
  /// ```
  ///
  /// **Example** "standard_trash":
  /// ```json
  /// {
  ///   "name": "Trash"
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "unicode":
  /// ```json
  /// {
  ///   "name": "Reçus"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "name": "WriteFailure"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "Receipts"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real production routes authenticate JWT/Basic/scoped keys and check current holder grants and CSRF before folder storage. Local SQL verifies exact mailbox/name counts, deleted zero-byte markers and message/marker rename selectors, including lookup/write failures. Fixed rows do not prove PostgreSQL durability or concurrency serialization.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "literal_folder":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "Work/2026"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_boundary":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_archive":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "Archive"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_spam":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "Spam"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unicode":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "Reçus"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type. The route and Vertrag transport hook send those exact bytes rather than JSON-quoting them.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "destination_exists":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Folder already exists"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_drafts":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Folder already exists"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_inbox":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Folder already exists"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_inbox_case":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Folder already exists"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_sent":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Folder already exists"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_trash":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Folder already exists"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_format":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_control":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must not contain a control character"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_empty":
  /// An empty string validates against the published string type but is refused as required by the runtime folder-name rule.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_parent":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must not contain \"..\""
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_space":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must not begin or end with a space"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_too_long":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must be at most 255 bytes"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "destination_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i10.CreateFolderResponse, _i9.Response>>
  createFolder({
    required _i11.FolderNameBody body,
    required _i6.int id,
    _i7.TonikCancellation? cancellation,
  }) async => _createFolder(body: body, id: id, cancellation: cancellation);

  /// Delete a folder and its messages
  /// A standard folder (INBOX, Sent, Drafts, Trash, Spam, Archive) cannot be deleted: 400 bad_request.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 400 (application/json):
  /// **Example** "standard_archive":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot delete standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_drafts":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot delete standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_inbox":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot delete standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_inbox_case":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot delete standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_sent":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot delete standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_spam":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot delete standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_trash":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot delete standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_send":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing_account":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Folder not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_format":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "delete_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "quota_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sum_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i12.DeleteFolderResponse, _i9.Response>>
  deleteFolder({
    required _i6.int id,
    required _i6.String folder,
    _i7.TonikCancellation? cancellation,
  }) async => _deleteFolder(id: id, folder: folder, cancellation: cancellation);

  /// Rename a folder
  /// A standard folder (INBOX, Sent, Drafts, Trash, Spam, Archive) is not renamed, and no folder is renamed to one: 400 bad_request. A name another folder has is 409 already_exists: folders are not merged. The name is valid UTF-8 of at most 255 bytes, neither blank nor beginning or ending with a space, with no control character and no ".."; a "/" is the hierarchy delimiter IMAP clients show. Any other name is 422.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "concurrent":
  /// ```json
  /// {
  ///   "name": "New"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "destination_exists":
  /// ```json
  /// {
  ///   "name": "Existing"
  /// }
  /// ```
  ///
  /// **Example** "destination_standard":
  /// ```json
  /// {
  ///   "name": "INBOX"
  /// }
  /// ```
  ///
  /// **Example** "destination_unavailable":
  /// ```json
  /// {
  ///   "name": "LookupFailure"
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "example" — The operation's example:
  /// ```json
  /// {
  ///   "name": "Paid receipts"
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real production routes authenticate JWT/Basic/scoped keys and check current holder grants and CSRF before folder storage. Local SQL verifies exact mailbox/name counts, deleted zero-byte markers and message/marker rename selectors, including lookup/write failures. Fixed rows do not prove PostgreSQL durability or concurrency serialization.
  ///
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "literal_folder":
  /// ```json
  /// {
  ///   "name": "Work/2026"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type. The route and Vertrag transport hook send those exact bytes rather than JSON-quoting them.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "name_boundary":
  /// ```json
  /// {
  ///   "name": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  /// }
  /// ```
  ///
  /// **Example** "name_control":
  /// ```json
  /// {
  ///   "name": "New\nfolder"
  /// }
  /// ```
  ///
  /// **Example** "name_parent":
  /// ```json
  /// {
  ///   "name": "Work/../Other"
  /// }
  /// ```
  ///
  /// **Example** "name_space":
  /// ```json
  /// {
  ///   "name": " New"
  /// }
  /// ```
  ///
  /// **Example** "name_too_long":
  /// ```json
  /// {
  ///   "name": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "same_name":
  /// ```json
  /// {
  ///   "name": "Work"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "source_missing":
  /// ```json
  /// {
  ///   "name": "New"
  /// }
  /// ```
  ///
  /// **Example** "source_unavailable":
  /// ```json
  /// {
  ///   "name": "New"
  /// }
  /// ```
  ///
  /// **Example** "standard_archive":
  /// ```json
  /// {
  ///   "name": "New"
  /// }
  /// ```
  ///
  /// **Example** "standard_drafts":
  /// ```json
  /// {
  ///   "name": "New"
  /// }
  /// ```
  ///
  /// **Example** "standard_inbox":
  /// ```json
  /// {
  ///   "name": "New"
  /// }
  /// ```
  ///
  /// **Example** "standard_inbox_case":
  /// ```json
  /// {
  ///   "name": "New"
  /// }
  /// ```
  ///
  /// **Example** "standard_sent":
  /// ```json
  /// {
  ///   "name": "New"
  /// }
  /// ```
  ///
  /// **Example** "standard_spam":
  /// ```json
  /// {
  ///   "name": "New"
  /// }
  /// ```
  ///
  /// **Example** "standard_trash":
  /// ```json
  /// {
  ///   "name": "New"
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "unicode":
  /// ```json
  /// {
  ///   "name": "Reçus"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "name": "New folder"
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "name": "WriteFailure"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "example" — The operation's example:
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "Paid receipts"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real production routes authenticate JWT/Basic/scoped keys and check current holder grants and CSRF before folder storage. Local SQL verifies exact mailbox/name counts, deleted zero-byte markers and message/marker rename selectors, including lookup/write failures. Fixed rows do not prove PostgreSQL durability or concurrency serialization.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "literal_folder":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "Work/2026"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_boundary":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unicode":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "Reçus"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "name": "New folder"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "destination_standard":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot rename a folder to a standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type. The route and Vertrag transport hook send those exact bytes rather than JSON-quoting them.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_archive":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot rename standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_drafts":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot rename standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_inbox":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot rename standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_inbox_case":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot rename standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_sent":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot rename standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_spam":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot rename standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "standard_trash":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Cannot rename standard folder"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "concurrent":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Folder not found or empty"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "source_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Folder not found or empty"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "destination_exists":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Folder already exists"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "same_name":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Folder already exists"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_format":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_control":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must not contain a control character"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_parent":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must not contain \"..\""
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_space":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must not begin or end with a space"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_too_long":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must be at most 255 bytes"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "destination_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "source_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i13.RenameFolderResponse, _i9.Response>>
  renameFolder({
    required _i11.FolderNameBody body,
    required _i6.int id,
    required _i6.String folder,
    _i7.TonikCancellation? cancellation,
  }) async => _renameFolder(
    body: body,
    id: id,
    folder: folder,
    cancellation: cancellation,
  );
}
