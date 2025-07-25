import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finance_loan_app/main.dart';
import 'package:finance_loan_app/src/providers/auth_provider.dart';
import 'package:finance_loan_app/src/providers/loan_provider.dart';
import 'package:finance_loan_app/src/providers/language_provider.dart';

void main() {
  group('Finance Loan App Widget Tests', () {
    late SharedPreferences mockPrefs;

    setUp(() async {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      mockPrefs = await SharedPreferences.getInstance();
    });

    testWidgets('App loads and shows splash screen', (WidgetTester tester) async {
      // Build our app and trigger a frame
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

      // Verify that the app shows at least one MaterialApp widget
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Verify that the app shows the FinanceLoanApp widget
      expect(find.byType(FinanceLoanApp), findsOneWidget);
    });

    testWidgets('App supports multiple locales', (WidgetTester tester) async {
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

      // Find the MaterialApp widget
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // Verify supported locales
      expect(materialApp.supportedLocales.length, 3);
      expect(materialApp.supportedLocales.map((l) => l.languageCode).toList(),
          containsAll(['en', 'ar', 'ku']));
    });

    testWidgets('App has correct theme configuration', (WidgetTester tester) async {
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

      // Find the MaterialApp widget
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // Verify theme configuration
      expect(materialApp.theme?.useMaterial3, true);
      expect(materialApp.debugShowCheckedModeBanner, false);
      expect(materialApp.title, 'Finance Loan App');
    });
  });
}
