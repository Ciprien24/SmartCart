import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cart/main.dart';

void main() {
  testWidgets('Carts screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartCartApp());

    expect(find.text('SmartCart'), findsOneWidget);
    expect(find.text('Your Carts'), findsOneWidget);
    expect(find.text('New Cart'), findsOneWidget);
  });
}
