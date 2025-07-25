import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = 
      _AppLocalizationsDelegate();

  Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Finance Loan',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'no_account': 'Don\'t have an account?',
      'have_account': 'Already have an account?',
      'welcome': 'Welcome',
      'dashboard': 'Dashboard',
      'loan_request': 'Request Loan',
      'transaction_history': 'Transaction History',
      'profile': 'Profile',
      'settings': 'Settings',
      'logout': 'Logout',
      'select_bank': 'Select Bank',
      'select_company': 'Select Company',
      'loan_amount': 'Loan Amount',
      'credit_limit': 'Credit Limit',
      'available_credit': 'Available Credit',
      'submit_request': 'Submit Request',
      'pending': 'Pending',
      'approved': 'Approved',
      'rejected': 'Rejected',
      'processing': 'Processing',
      'completed': 'Completed',
      'transaction_id': 'Transaction ID',
      'date': 'Date',
      'amount': 'Amount',
      'status': 'Status',
      'bank': 'Bank',
      'company': 'Company',
      'language': 'Language',
      'english': 'English',
      'arabic': 'العربية',
      'kurdish': 'کوردی',
      'error_occurred': 'An error occurred',
      'please_wait': 'Please wait...',
      'no_transactions': 'No transactions found',
      'search': 'Search',
      'filter': 'Filter',
      'notifications': 'Notifications',
      'help': 'Help',
      'contact_support': 'Contact Support',
      'terms_conditions': 'Terms & Conditions',
      'privacy_policy': 'Privacy Policy',
    },
    'ar': {
      'app_title': 'التمويل',
      'login': 'تسجيل الدخول',
      'register': 'تسجيل',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'no_account': 'ليس لديك حساب؟',
      'have_account': 'لديك حساب بالفعل؟',
      'welcome': 'أهلاً وسهلاً',
      'dashboard': 'لوحة التحكم',
      'loan_request': 'طلب قرض',
      'transaction_history': 'سجل المعاملات',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'logout': 'تسجيل الخروج',
      'select_bank': 'اختر البنك',
      'select_company': 'اختر الشركة',
      'loan_amount': 'مبلغ القرض',
      'credit_limit': 'الحد الائتماني',
      'available_credit': 'الائتمان المتاح',
      'submit_request': 'إرسال الطلب',
      'pending': 'قيد الانتظار',
      'approved': 'موافق عليه',
      'rejected': 'مرفوض',
      'processing': 'قيد المعالجة',
      'completed': 'مكتمل',
      'transaction_id': 'رقم المعاملة',
      'date': 'التاريخ',
      'amount': 'المبلغ',
      'status': 'الحالة',
      'bank': 'البنك',
      'company': 'الشركة',
      'language': 'اللغة',
      'english': 'English',
      'arabic': 'العربية',
      'kurdish': 'کوردی',
      'error_occurred': 'حدث خطأ',
      'please_wait': 'يرجى الانتظار...',
      'no_transactions': 'لم يتم العثور على معاملات',
      'search': 'بحث',
      'filter': 'تصفية',
      'notifications': 'الإشعارات',
      'help': 'المساعدة',
      'contact_support': 'اتصل بالدعم',
      'terms_conditions': 'الشروط والأحكام',
      'privacy_policy': 'سياسة الخصوصية',
    },
    'ku': {
      'app_title': 'دارایی قەرز',
      'login': 'چوونەژوورەوە',
      'register': 'تۆمارکردن',
      'email': 'ئیمەیڵ',
      'password': 'وشەی نهێنی',
      'forgot_password': 'وشەی نهێنیت لەبیرکردوە؟',
      'no_account': 'هەژمارت نییە؟',
      'have_account': 'هەژمارت هەیە؟',
      'welcome': 'بەخێربێیت',
      'dashboard': 'داشبۆرد',
      'loan_request': 'داواکردنی قەرز',
      'transaction_history': 'مێژووی کارەکان',
      'profile': 'پرۆفایل',
      'settings': 'ڕێکخستنەکان',
      'logout': 'دەرچوون',
      'select_bank': 'بانک هەڵبژێرە',
      'select_company': 'کۆمپانیا هەڵبژێرە',
      'loan_amount': 'بڕی قەرز',
      'credit_limit': 'سنووری بڕ',
      'available_credit': 'بڕی بەردەست',
      'submit_request': 'ناردنی داواکاری',
      'pending': 'چاوەڕوانی',
      'approved': 'پەسەندکراو',
      'rejected': 'ڕەتکراوە',
      'processing': 'لەژێر پرۆسەدایە',
      'completed': 'تەواو',
      'transaction_id': 'ژمارەی کار',
      'date': 'بەروار',
      'amount': 'بڕ',
      'status': 'دۆخ',
      'bank': 'بانک',
      'company': 'کۆمپانیا',
      'language': 'زمان',
      'english': 'English',
      'arabic': 'العربية',
      'kurdish': 'کوردی',
      'error_occurred': 'هەڵەیەک ڕوویدا',
      'please_wait': 'تکایە چاوەڕوان بە...',
      'no_transactions': 'هیچ کارێک نەدۆزرایەوە',
      'search': 'گەڕان',
      'filter': 'پاڵاوتن',
      'notifications': 'ئاگاداریەکان',
      'help': 'یارمەتی',
      'contact_support': 'پەیوەندی بە پشتگیری',
      'terms_conditions': 'مەرجەکان و ڕێکارەکان',
      'privacy_policy': 'سیاسەتی تایبەتی',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar', 'ku'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
