import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_connector/main.dart';
import 'package:eco_connector/services/storage_service.dart';

void main() {
  testWidgets('app starts and reaches onboarding', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
    await tester.pumpWidget(const EcoConnectApp());

    // Skip the splash screen delay.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
