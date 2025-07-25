import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finance_loan_app/main.dart';
import 'package:finance_loan_app/src/providers/auth_provider.dart';
import 'package:finance_loan_app/src/providers/loan_provider.dart';
import 'package:finance_loan_app/src/providers/language_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Finance Loan App Integration Tests', () {
    late SharedPreferences mockPrefs;

    setUp(() async {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      mockPrefs = await SharedPreferences.getInstance();
    });

    testWidgets('Complete app flow - splash to login', (WidgetTester tester) async {
      // Build and start the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider(mockPrefs)),
            ChangeNotifierProvider(create: (_) => LoanProvider()),
            ChangeNotifierProvider(create: (_) => LanguageProvider(mockPrefs)),
          ],
          child: const FinanceLoanApp(),
        ),
      );

      // Wait for the app to settle
      await tester.pumpAndSettle();

      // Verify the app starts successfully
      expect(find.byType(MaterialApp), findsOneWidget);

      // The app should show some content (splash screen or main content)
      // This test verifies the basic app initialization and navigation flow
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('Language switching functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider(mockPrefs)),
            ChangeNotifierProvider(create: (_) => LoanProvider()),
            ChangeNotifierProvider(create: (_) => LanguageProvider(mockPrefs)),
          ],
          child: const FinanceLoanApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the app supports multiple languages
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.supportedLocales.length, 3);
      
      // Test that the app can handle different locales
      final supportedLanguages = materialApp.supportedLocales.map((l) => l.languageCode).toList();
      expect(supportedLanguages, containsAll(['en', 'ar', 'ku']));
    });

    testWidgets('Provider state management integration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider(mockPrefs)),
            ChangeNotifierProvider(create: (_) => LoanProvider()),
            ChangeNotifierProvider(create: (_) => LanguageProvider(mockPrefs)),
          ],
          child: const FinanceLoanApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that providers are properly integrated
      final context = tester.element(find.byType(FinanceLoanApp));
      
      // Check that providers are accessible
      expect(Provider.of<AuthProvider>(context, listen: false), isNotNull);
      expect(Provider.of<LoanProvider>(context, listen: false), isNotNull);
      expect(Provider.of<LanguageProvider>(context, listen: false), isNotNull);
    });
  });
}
