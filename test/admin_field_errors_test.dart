import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/ui/admin/admin_widgets.dart';
import 'package:restmail_api/restmail_api.dart';

void main() {
  Future<String Function(Object)> describe(WidgetTester tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      ),
    );
    return (Object error) => describeAdminError(context, error);
  }

  ApiException invalid(String field, String message) => ApiException(
    422,
    'validation_failed',
    'Request body failed validation',
    fields: {field: message},
  );

  testWidgets('a field phrase follows the field name', (tester) async {
    final text = await describe(tester);
    expect(text(invalid('domain_id', 'required')), 'Domain id required.');
    expect(
      text(invalid('sender', 'must be an address, or @ and a domain')),
      'Sender must be an address, or @ and a domain.',
    );
  });

  testWidgets('a field sentence stands on its own', (tester) async {
    final text = await describe(tester);
    expect(
      text(invalid('cert_pem', 'Invalid certificate PEM')),
      'Invalid certificate PEM.',
    );
    expect(
      text(invalid('name', 'Invalid domain name: -bad.example')),
      'Invalid domain name: -bad.example.',
    );
    expect(
      text(invalid('max_age', 'Must be a non-negative integer (seconds).')),
      'Must be a non-negative integer (seconds).',
    );
  });

  testWidgets('a refusal says only that permission is missing', (tester) async {
    final text = await describe(tester);
    expect(
      text(const ApiException(403, 'forbidden', 'Forbidden')),
      noPermission,
    );
  });
}
