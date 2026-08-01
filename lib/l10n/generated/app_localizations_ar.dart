// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navFlights => 'الرحلات';

  @override
  String get navMap => 'الخريطة';

  @override
  String get navServices => 'الخدمات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSearchHint => 'ابحث في الإعدادات...';

  @override
  String get settingsGroupAppearance => 'المظهر';

  @override
  String get settingsGroupAccessibility => 'إمكانية الوصول';

  @override
  String get settingsGroupLanguage => 'اللغة والمنطقة';

  @override
  String get settingsGroupSecurity => 'الأمان والخصوصية';

  @override
  String get settingsGroupData => 'البيانات والتخزين';

  @override
  String get settingsGroupSupport => 'الدعم والمعلومات';

  @override
  String get settingDarkMode => 'الوضع الداكن';

  @override
  String get settingDarkModeDesc => 'التبديل إلى الوضع الداكن لعرض أفضل ليلاً';

  @override
  String get settingHighContrast => 'التباين العالي';

  @override
  String get settingHighContrastDesc =>
      'زيادة التباين البصري لتحسين إمكانية الوصول';

  @override
  String get settingTextSize => 'حجم النص';

  @override
  String get settingTextSizeDesc => 'اضبط حجم النص لقراءة مريحة';

  @override
  String get settingSimpleMode => 'الوضع البسيط';

  @override
  String get settingSimpleModeDesc => 'واجهة مبسطة لسهولة التنقل';

  @override
  String get settingVoiceAssistant => 'المساعد الصوتي';

  @override
  String get settingVoiceAssistantDesc => 'تفعيل الإرشادات والإعلانات الصوتية';

  @override
  String get settingAppLanguage => 'لغة التطبيق';

  @override
  String get settingAppLanguageDesc => 'اختر لغتك المفضلة';

  @override
  String get settingBiometricLogin => 'الدخول البيومتري';

  @override
  String get settingBiometricLoginDesc =>
      'استخدم البصمة أو التعرف على الوجه لتسجيل الدخول';

  @override
  String get settingLocationServices => 'خدمات الموقع';

  @override
  String get settingLocationServicesDesc => 'مطلوب للملاحة الداخلية والخدمات';

  @override
  String get settingNotifications => 'الإشعارات';

  @override
  String get settingNotificationsDesc =>
      'إدارة تنبيهات الرحلات وإشعارات التطبيق';

  @override
  String get settingSyncSettings => 'مزامنة الإعدادات';

  @override
  String get settingSyncSettingsDesc => 'نسخ تفضيلاتك احتياطياً إلى السحابة';

  @override
  String get settingClearCache => 'مسح ذاكرة التخزين';

  @override
  String get settingClearCacheDesc => 'حرر مساحة التخزين على جهازك';

  @override
  String get settingAppVersion => 'إصدار التطبيق';

  @override
  String get settingAppVersionDesc => 'الإصدار 1.0.0 (البناء 100)';

  @override
  String get settingPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingPrivacyPolicyDesc => 'تعرف على كيفية حمايتنا لبياناتك';

  @override
  String get settingTermsOfService => 'شروط الخدمة';

  @override
  String get settingTermsOfServiceDesc => 'اقرأ الشروط والأحكام الخاصة بنا';

  @override
  String get settingContactSupport => 'الاتصال بالدعم';

  @override
  String get settingContactSupportDesc =>
      'احصل على المساعدة في أي أسئلة أو مشكلات';

  @override
  String get settingsClearCacheTitle => 'مسح ذاكرة التخزين';

  @override
  String get settingsClearCacheBody =>
      'سيؤدي هذا إلى مسح جميع البيانات المخزنة وتحرير مساحة التخزين. هل تريد المتابعة؟';

  @override
  String get settingsCacheCleared => 'تم مسح ذاكرة التخزين بنجاح';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonClear => 'مسح';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get homeGoodMorning => 'صباح الخير';

  @override
  String get homeGoodAfternoon => 'مساء الخير';

  @override
  String get homeGoodEvening => 'مساء الخير';

  @override
  String get homeTraveler => 'مسافر';

  @override
  String get homeFlightStatus => 'حالة الرحلة';

  @override
  String get homeSeeAll => 'عرض الكل';

  @override
  String get homeNotifications => 'الإشعارات';

  @override
  String get homeViewAll => 'عرض الكل';

  @override
  String get homeUpcomingFlight => 'الرحلة القادمة';

  @override
  String homeGate(Object gate) {
    return 'البوابة $gate';
  }

  @override
  String homeSeat(Object seat) {
    return 'المقعد $seat';
  }

  @override
  String homeTerminal(Object terminal) {
    return 'المحطة $terminal';
  }

  @override
  String get homeAirportMap => 'خريطة المطار';

  @override
  String get homeBoardingPass => 'بطاقة الصعود';

  @override
  String get homeDining => 'المطاعم';

  @override
  String get homeHelp => 'المساعدة';

  @override
  String get homeTravelTips => 'نصائح السفر';

  @override
  String get homeTipCheckInEarly => 'تسجيل الوصول المبكر';

  @override
  String get homeTipCheckInEarlyBody =>
      'احضر قبل 2–3 ساعات للرحلات الدولية لتجنب التأخير في الأمن.';

  @override
  String get homeTipLiquidsRule => 'قاعدة السوائل';

  @override
  String get homeTipLiquidsRuleBody =>
      'احتفظ بالسوائل أقل من 100 مل في كيس شفاف قابل للإغلاق للأمن.';

  @override
  String get homeTipFreeWifi => 'واي فاي مجاني في المطار';

  @override
  String get homeTipFreeWifiBody =>
      'اتصل بشبكة \"JFK-FreeWiFi\" لإنترنت مجاني في جميع أنحاء المحطة.';

  @override
  String get homeTipBaggage => 'نصيحة الأمتعة';

  @override
  String get homeTipBaggageBody =>
      'التقط صورة لأمتعتك قبل تسجيل الوصول لسهولة التعرف عليها.';

  @override
  String get homeQuickConverter => 'محول العملات السريع';

  @override
  String get homeWeatherDesc => 'غائم جزئياً · نسيم خفيف';

  @override
  String homeFeels(Object temp) {
    return 'الإحساس $temp°';
  }

  @override
  String get homeEmergencyContacts => 'جهات الاتصال للطوارئ';

  @override
  String get homeEmergency => 'طوارئ';

  @override
  String get homeMedical => 'طبي';

  @override
  String get homeFire => 'حريق';

  @override
  String get homeAirportHelp => 'مساعدة المطار';

  @override
  String homeCalling(Object number, Object title) {
    return 'جارٍ الاتصال بـ $title: $number';
  }
}
