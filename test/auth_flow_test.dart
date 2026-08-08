import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_connector/main.dart';
import 'package:eco_connector/services/storage_service.dart';
import 'package:eco_connector/widgets/custom_button.dart';
import 'package:eco_connector/widgets/map_fallback.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
    await tester.pumpWidget(const EcoConnectApp());

    // Skip the splash screen delay.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  }

  testWidgets('login -> home does not throw', (WidgetTester tester) async {
    await pumpApp(tester);
    expect(tester.takeException(), isNull);

    // Go to login.
    await tester.tap(find.text('Login').first);
    await tester.pumpAndSettle();

    // Fill credentials and submit.
    await tester.enterText(find.byType(TextFormField).at(0), '123456789');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final Object? error = tester.takeException();
    expect(error, isNull, reason: 'Exception while navigating to home: $error');

    // Without a Maps API key no native GoogleMap platform view may exist,
    // otherwise the app crashes on device. A fallback card must render instead.
    expect(find.byType(GoogleMap), findsNothing);
    expect(find.byType(MapFallback), findsWidgets);
  });

  testWidgets('register -> otp -> home does not throw', (WidgetTester tester) async {
    await pumpApp(tester);
    expect(tester.takeException(), isNull);

    // Go to register via onboarding's "Get Started".
    await tester.tap(find.text('Get Started').first);
    await tester.pumpAndSettle();

    // Fill the registration form.
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Jane Doe');
    await tester.enterText(fields.at(1), '+237612345678');
    await tester.enterText(fields.at(2), 'password1');
    await tester.enterText(fields.at(3), 'password1');
    await tester.pumpAndSettle();

    // Submit.
    await tester.ensureVisible(find.widgetWithText(CustomButton, 'Register'));
    await tester.tap(find.widgetWithText(CustomButton, 'Register'));

    // Route transition to OTP. The OTP screen runs a periodic resend timer, so
    // use explicit pumps instead of pumpAndSettle to avoid stalling.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);

    // Enter the mock OTP code.
    const code = '123456';
    final otpFields = find.byType(TextFormField);
    expect(otpFields, findsNWidgets(6));
    for (var i = 0; i < 6; i++) {
      await tester.enterText(otpFields.at(i), code[i]);
    }
    await tester.pump();

    // Verify: simulated 2s API delay, then navigate to home.
    await tester.ensureVisible(find.widgetWithText(CustomButton, 'Verify'));
    await tester.tap(find.widgetWithText(CustomButton, 'Verify'));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final Object? error = tester.takeException();
    expect(error, isNull, reason: 'Exception while reaching home via register: $error');

    // Same map guard check as the login path.
    expect(find.byType(GoogleMap), findsNothing);
    expect(find.byType(MapFallback), findsWidgets);
  });
}
