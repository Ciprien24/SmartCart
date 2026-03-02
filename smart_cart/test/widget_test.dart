import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cart/main.dart';

void main() {
  testWidgets('Preferences screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartCartApp());

    expect(find.text('SmartCart'), findsOneWidget);
    expect(find.text('Set Your Preferences'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
