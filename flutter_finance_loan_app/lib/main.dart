import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/providers/auth_provider.dart';
import 'src/providers/loan_provider.dart';
import 'src/providers/language_provider.dart';
import 'src/screens/splash_screen.dart';
import 'src/utils/app_localizations.dart';
import 'src/constants/theme_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider(prefs)),
      ],
      child: const FinanceLoanApp(),
    ),
  );
}

class FinanceLoanApp extends StatelessWidget {
  const FinanceLoanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Finance Loan App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.surface,
              background: AppColors.background,
              error: AppColors.error,
            ),
            fontFamily: languageProvider.currentLanguage == 'ar' || 
                       languageProvider.currentLanguage == 'ku' 
                ? 'Cairo' 
                : 'Roboto',
            useMaterial3: true,
            
            // AppBar Theme
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: AppTextStyles.headline4.copyWith(color: Colors.white),
            ),
            
            // Elevated Button Theme
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSizes.md, horizontal: AppSizes.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                elevation: 2,
                shadowColor: AppColors.primary.withOpacity(0.3),
                textStyle: AppTextStyles.buttonLarge,
              ),
            ),
            
            // Input Decoration Theme
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md, 
                vertical: AppSizes.md,
              ),
              labelStyle: AppTextStyles.label,
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
            ),
            
            // Card Theme
            cardTheme: CardTheme(
              elevation: 2,
              shadowColor: AppColors.textPrimary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              color: AppColors.cardBackground,
              margin: const EdgeInsets.symmetric(vertical: AppSizes.xs),
            ),
            
            // Bottom Navigation Bar Theme
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColors.surface,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              type: BottomNavigationBarType.fixed,
              elevation: 8,
            ),
            
            // Text Theme
            textTheme: TextTheme(
              displayLarge: AppTextStyles.headline1,
              displayMedium: AppTextStyles.headline2,
              displaySmall: AppTextStyles.headline3,
              headlineMedium: AppTextStyles.headline4,
              bodyLarge: AppTextStyles.bodyLarge,
              bodyMedium: AppTextStyles.bodyMedium,
              bodySmall: AppTextStyles.bodySmall,
              labelLarge: AppTextStyles.buttonLarge,
              labelMedium: AppTextStyles.buttonMedium,
              labelSmall: AppTextStyles.caption,
            ),
          ),
          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
            Locale('ku', ''),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),
        );
      },
    );
  }
}
