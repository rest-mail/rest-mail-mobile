import 'package:flutter/material.dart';

import '../../l10n/voice.dart';
import '../../theme/tokens.dart';

(String, String)? messageClassKeys(String? messageClass) =>
    switch (messageClass) {
      'newsletter' => ('messageClass.list', 'messageClass.listDescription'),
      'receipt' => ('messageClass.receipt', 'messageClass.receiptDescription'),
      'notification' => (
        'messageClass.automated',
        'messageClass.automatedDescription',
      ),
      _ => null,
    };

class MessageClassLabel extends StatelessWidget {
  const MessageClassLabel({super.key, required this.messageClass});

  final String? messageClass;

  @override
  Widget build(BuildContext context) {
    final keys = messageClassKeys(messageClass);
    if (keys == null) return const SizedBox.shrink();
    return Tooltip(
      message: tr(context, keys.$2),
      child: Text(
        tr(context, keys.$1),
        style: rmText(11.5, color: context.rm.ink3),
      ),
    );
  }
}
