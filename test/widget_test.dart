import 'package:flutter_test/flutter_test.dart';
import 'package:drakson/drakson_app.dart';

void main() {
  testWidgets('DraksonApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DraksonApp());
    expect(find.byType(DraksonApp), findsOneWidget);
  });
}
