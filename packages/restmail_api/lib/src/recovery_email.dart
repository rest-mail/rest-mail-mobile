/// How far an account's external recovery address has got.
enum RecoveryEmailStage { none, pending, verified }

/// What `GET /api/v1/auth/recovery-email` reports for the signed-in account.
/// The server answers an empty [email] when none is registered.
class RecoveryEmailStatus {
  const RecoveryEmailStatus({this.email = '', this.verified = false});

  final String email;
  final bool verified;

  RecoveryEmailStage get stage => email.isEmpty
      ? RecoveryEmailStage.none
      : verified
      ? RecoveryEmailStage.verified
      : RecoveryEmailStage.pending;
}
