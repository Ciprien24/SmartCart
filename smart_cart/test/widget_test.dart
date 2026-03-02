import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cart/main.dart';

void main() {
  testWidgets('Preferences screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartCartApp());

    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Weekly budget (€)'), findsOneWidget);
    expect(find.text('Generate Weekly List'), findsOneWidget);
  });
}
