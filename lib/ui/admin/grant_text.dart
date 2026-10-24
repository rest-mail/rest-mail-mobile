import '../../l10n/voice.dart';

import 'package:flutter/widgets.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

// Words for grants, shared by Permissions in Administration and by My
// permissions in Settings.

/// Where a grant applies, as a person reads it.
String scopeLabel(BuildContext context, String scope) => switch (scope) {
  '*' => tr(context, 'admin.granttext.everywhere'),
  _ when scope.startsWith('domain:') => trArgs(
    context,
    'admin.granttext.domainValue',
    {'value': (scope.substring(7)).toString()},
  ),
  _ when scope.startsWith('mailbox:') => trArgs(
    context,
    'admin.granttext.mailboxValue',
    {'value': (scope.substring(8)).toString()},
  ),
  _ => scope,
};

/// Whether a grant gives its role now, and for how long.
String grantState(BuildContext context, Grant grant) {
  final now = DateTime.now();
  if (grant.isExpiredAt(now)) return tr(context, 'admin.granttext.ended');
  final activation = grant.activation;
  return switch (grant.mode) {
    GrantMode.active => tr(context, 'admin.granttext.activeAlwaysApplies'),
    GrantMode.eligible when activation != null && activation.isActiveAt(now) =>
      trArgs(context, 'admin.granttext.switchedOnUntilValue', {
        'value': (longDate(activation.expiresAt)).toString(),
      }),
    GrantMode.eligible => tr(
      context,
      'admin.granttext.eligibleOffUntilSwitchedOn',
    ),
    GrantMode.unknown => tr(context, 'admin.granttext.unknownMode'),
  };
}

/// When the grant itself ends.
String grantEnds(BuildContext context, Grant grant) =>
    switch (grant.expiresAt) {
      final ends? => trArgs(context, 'admin.granttext.grantEndsValue', {
        'value': (longDate(ends)).toString(),
      }),
      null => tr(context, 'admin.granttext.lastsUntilRemoved'),
    };

const _fieldNames = {
  'holder': 'admin.audit.account',
  'holder_id': 'admin.audit.account',
  'role': 'admin.granttext.role',
  'scope': 'admin.granttext.scope',
  'mode': 'admin.granttext.mode',
  'expires_at': 'admin.granttext.expiry',
  'reason': 'admin.granttext.reason',
  'minutes': 'admin.granttext.minutes',
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
    final fieldKey = _fieldNames[field.key];
    final name = fieldKey == null
        ? field.key.replaceAll('_', ' ')
        : tr(context, fieldKey);
    return '$name: ${field.value}.';
  }
  return switch (error.code) {
    GrantErrorCode.twoFactorRequired when escalating => tr(
      context,
      'admin.granttext.thisNeedsTwoFactorAuthenticationSetUp',
    ),
    GrantErrorCode.twoFactorRequired => tr(
      context,
      'admin.granttext.changingPermissionsNeedsASessionSignedIn',
    ),
    GrantErrorCode.totpRequired => tr(
      context,
      'admin.granttext.enterTheCurrentCodeFromYourAuthenticator',
    ),
    GrantErrorCode.invalidTotp => tr(
      context,
      'admin.granttext.thatCodeIsWrongOrHasExpired',
    ),
    GrantErrorCode.exceedsHeld => tr(
      context,
      'admin.granttext.youCanOnlyGrantOrRemoveA',
    ),
    GrantErrorCode.conflict => tr(
      context,
      'admin.granttext.theyAlreadyHoldThatRoleThere',
    ),
    GrantErrorCode.lastSuperadmin => tr(
      context,
      'admin.granttext.refusedNobodyElseHoldsSuperadminSoNobody',
    ),
    GrantErrorCode.notEligible => tr(
      context,
      'admin.granttext.onlyAnEligibleRoleCanBeSwitched',
    ),
    GrantErrorCode.alreadyActive => tr(
      context,
      'admin.granttext.itIsSwitchedOnAlready',
    ),
    GrantErrorCode.notActive => tr(
      context,
      'admin.granttext.itIsNotSwitchedOn',
    ),
    GrantErrorCode.grantExpired => tr(
      context,
      'admin.granttext.thisGrantHasEnded',
    ),
    GrantErrorCode.alreadyEligible => tr(
      context,
      'admin.granttext.itIsEligibleAlready',
    ),
    'not_found' => tr(context, 'admin.granttext.thatGrantIsGoneOrIsNot'),
    _ => describeAdminError(context, error, host: host),
  };
}
