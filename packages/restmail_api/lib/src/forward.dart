import 'models.dart';

/// The forward route can send the original parts, or deliberately discard
/// the message through the server's outbound policy (HTTP 200).
sealed class ForwardResult {
  const ForwardResult();

  factory ForwardResult.fromJson(Map<String, dynamic> json) =>
      json['status'] == 'discarded'
      ? const ForwardDiscarded()
      : ForwardSent(Message.fromJson(json));
}

final class ForwardSent extends ForwardResult {
  const ForwardSent(this.message);

  final Message message;
}

final class ForwardDiscarded extends ForwardResult {
  const ForwardDiscarded();
}
