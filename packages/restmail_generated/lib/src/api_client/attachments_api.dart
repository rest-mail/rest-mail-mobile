// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i4;

import 'package:http/http.dart' as _i7;
import 'package:restmail_generated/src/operation/get_attachment.dart' as _i2;
import 'package:restmail_generated/src/operation/list_attachments.dart' as _i3;
import 'package:restmail_generated/src/response_wrapper/get_attachment_response.dart'
    as _i6;
import 'package:restmail_generated/src/response_wrapper/list_attachments_response.dart'
    as _i8;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i5;

class AttachmentsApi {
  AttachmentsApi(_i1.Server server)
    : _getAttachment = _i2.GetAttachment(server.baseUrl, () => server.client),
      _listAttachments = _i3.ListAttachments(
        server.baseUrl,
        () => server.client,
      );

  final _i2.GetAttachment _getAttachment;

  final _i3.ListAttachments _listAttachments;

  /// Download an attachment
  /// The attachment's bytes are application/octet-stream; listAttachments' content_type is the sender's declared type. Range requests return a binary part or multipart/byteranges. Conditional requests can return bodyless 304 or 412; malformed or non-overlapping ranges return plain-text 416.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/octet-stream):
  /// **Example** "found":
  /// Production routing, real credential/holder access checks and the real signed S3 client stream bytes through a local S3 wire fixture. Controlled SQL proves lookup/authorization wiring, not PostgreSQL semantics. Sender HTML type is ignored; UTF-8/CRLF and attachment download headers are retained, with an injection-safe filename.
  ///
  /// ```
  /// attachment café
  ///
  /// ```
  ///
  /// Response 206 (application/octet-stream):
  /// **Example** "range_single":
  /// A single byte range is served as 206 with the selected bytes.
  ///
  /// ```
  /// attachment
  /// ```
  ///
  /// Response 206 (multipart/byteranges):
  /// **Example** "range_multiple":
  /// Two byte ranges are served as one 206 multipart/byteranges body, a part per range. The boundary is chosen per response.
  ///
  /// ```
  /// --EXAMPLE
  /// Content-Range: bytes 0-1/18
  /// Content-Type: application/octet-stream
  ///
  /// at
  /// --EXAMPLE
  /// Content-Range: bytes 4-5/18
  /// Content-Type: application/octet-stream
  ///
  /// ch
  /// --EXAMPLE--
  ///
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
  /// **Example** "invalid_storage_path":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Invalid storage path"
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
  ///     "message": "Attachment not found"
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
  /// Response 416 (text/plain):
  /// **Example** "range_not_satisfiable":
  /// A range starting past the end of the attachment answers plain-text 416.
  ///
  /// ```
  /// invalid range: failed to overlap
  ///
  /// ```
  ///
  /// Response 422 (application/json):
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
  _i4.Future<_i5.TonikResult<_i6.GetAttachmentResponse, _i7.Response>>
  getAttachment({
    required _i4.int id,
    _i4.String? range,
    _i4.String? ifRange,
    _i4.String? ifMatch,
    _i4.String? ifNoneMatch,
    _i4.String? ifModifiedSince,
    _i4.String? ifUnmodifiedSince,
    _i5.TonikCancellation? cancellation,
  }) async => _getAttachment(
    id: id,
    range: range,
    ifRange: ifRange,
    ifMatch: ifMatch,
    ifNoneMatch: ifNoneMatch,
    ifModifiedSince: ifModifiedSince,
    ifUnmodifiedSince: ifUnmodifiedSince,
    cancellation: cancellation,
  );

  /// List a message's attachments
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — A readable message exposes attachment metadata without storage details or content:
  /// Real credential and holder access checks precede the message-scoped, ID-ordered metadata query. Fixed rows include private disk/object-reference sentinels that must not appear in the complete public response; this GET reads no object/file bytes.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "checksum": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
  ///       "content_type": "application/pdf",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "filename": "résumé.pdf",
  ///       "id": 61,
  ///       "message_id": 1,
  ///       "size_bytes": 123
  ///     },
  ///     {
  ///       "checksum": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
  ///       "content_type": "application/octet-stream",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "filename": "",
  ///       "id": 62,
  ///       "message_id": 1,
  ///       "size_bytes": 0
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
  ///     "message": "Message not found"
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
  _i4.Future<_i5.TonikResult<_i8.ListAttachmentsResponse, _i7.Response>>
  listAttachments({
    required _i4.int id,
    _i5.TonikCancellation? cancellation,
  }) async => _listAttachments(id: id, cancellation: cancellation);
}
