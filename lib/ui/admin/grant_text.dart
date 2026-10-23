import 'package:flutter/widgets.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

// Words for grants, shared by Permissions in Administration and by My
// permissions in Settings.

/// Where a grant applies, as a person reads it.
String scopeLabel(String scope) => switch (scope) {
  '*' => 'Everywhere',
  _ when scope.startsWith('domain:') => 'Domain ${scope.substring(7)}',
  _ when scope.startsWith('mailbox:') => 'Mailbox ${scope.substring(8)}',
  _ => scope,
};

/// Whether a grant gives its role now, and for how long.
String grantState(Grant grant) {
  final now = DateTime.now();
  if (grant.isExpiredAt(now)) return 'Ended';
  final activation = grant.activation;
  return switch (grant.mode) {
    GrantMode.active => 'Active: always applies',
    GrantMode.eligible when activation != null && activation.isActiveAt(now) =>
      'Switched on until ${longDate(activation.expiresAt)}',
    GrantMode.eligible => 'Eligible: off until switched on',
    GrantMode.unknown => 'Unknown mode',
  };
}

/// When the grant itself ends.
String grantEnds(Grant grant) => switch (grant.expiresAt) {
  final ends? => 'Grant ends ${longDate(ends)}',
  null => 'Lasts until removed',
};

const _fieldNames = {
  'holder': 'Account',
  'holder_id': 'Account',
  'role': 'Role',
  'scope': 'Scope',
  'mode': 'Mode',
  'expires_at': 'Expiry',
  'reason': 'Reason',
  'minutes': 'Minutes',
};

/// What to tell someone about a refused grant change or escalation step. A
/// 403 here is the server saying no to this one request; the session is
/// still good, so nothing here signs anyone out.
///
/// [escalating] is for the holder's own steps, where `two_factor_required`
/// means no authenticator is enrolled, rather than a session signed in
/// without one.
String describeGrantError(
  BuildContext context,
  Object error, {
  String? host,
  bool escalating = false,
}) {
  if (error is! ApiException) {
    return describeError(context, error, host: host);
  }
  if (error.fields.entries.firstOrNull case final field?) {
    final name = _fieldNames[field.key] ?? field.key.replaceAll('_', ' ');
    return '$name: ${field.value}.';
  }
  return switch (error.code) {
    GrantErrorCode.twoFactorRequired when escalating =>
      'This needs two-factor authentication. Set up an authenticator for '
          'this account first, then try again.',
    GrantErrorCode.twoFactorRequired =>
      'Changing permissions needs a session signed in with a two-factor '
          'code. Sign in again with your authenticator code, then try again.',
    GrantErrorCode.totpRequired =>
      'Enter the current code from your authenticator, or a recovery code.',
    GrantErrorCode.invalidTotp =>
      'That code is wrong or has expired. Enter the current one from your '
          'authenticator, or an unused recovery code.',
    GrantErrorCode.exceedsHeld =>
      'You can only grant, or remove, a role you hold yourself, at a scope '
          'at least as wide.',
    GrantErrorCode.conflict => 'They already hold that role there.',
    GrantErrorCode.lastSuperadmin =>
      'Refused: nobody else holds superadmin, so nobody could grant anything '
          'after this.',
    GrantErrorCode.notEligible => 'Only an eligible role can be switched on.',
    GrantErrorCode.alreadyActive => 'It is switched on already.',
    GrantErrorCode.notActive => 'It is not switched on.',
    GrantErrorCode.grantExpired => 'This grant has ended.',
    GrantErrorCode.alreadyEligible => 'It is eligible already.',
    'not_found' => 'That grant is gone, or is not yours.',
    _ => describeAdminError(context, error, host: host),
  };
}
