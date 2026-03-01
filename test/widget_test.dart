import 'package:flutter_test/flutter_test.dart';
import 'package:urjasetu/main.dart';

void main() {
  testWidgets('App should launch', (WidgetTester tester) async {
    await tester.pumpWidget(const UrjaSetuApp());
    expect(find.text('UrjaSetu'), findsOneWidget);
  });
}
