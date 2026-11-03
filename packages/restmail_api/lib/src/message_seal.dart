enum MessageSealState { intact, mismatch, notSealed }

class MessageSeal {
  const MessageSeal({
    required this.state,
    required this.algorithm,
    this.sealedHash,
    this.computedHash,
  });

  final MessageSealState state;
  final String algorithm;
  final String? sealedHash;
  final String? computedHash;
}
