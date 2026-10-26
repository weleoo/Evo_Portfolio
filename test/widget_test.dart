import 'package:flutter_test/flutter_test.dart';
import 'package:evo_portfolio/main.dart';

void main() {
  testWidgets('EvoMedApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EvoMedApp());
    expect(find.text('EVO MED'), findsWidgets);
  });
}
