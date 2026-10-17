import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/state/push_state.dart';

void main() {
  group('PushSignal', () {
    test('reads the device, account and count, and nothing else', () {
      final signal = PushSignal.parse({
        'restmail': {
          'device': 'dev-3',
          'account': 12,
          'unread': 4,
          'subject': 'ignored',
        },
      });

      expect(signal.device, 'dev-3');
      expect(signal.account, 12);
      expect(signal.unread, 4);
    });

    test('takes what is malformed as missing', () {
      final signal = PushSignal.parse({
        'restmail': {'device': 5, 'account': '12', 'unread': -1},
      });
      final bare = PushSignal.parse({'restmail': 'fetch'});

      expect(signal.device, '5');
      expect(signal.account, isNull);
      expect(signal.unread, isNull);
      expect(bare.device, isNull);
      expect(bare.account, isNull);
    });
  });
}
