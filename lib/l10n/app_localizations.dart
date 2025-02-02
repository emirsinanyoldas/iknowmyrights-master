import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'I Know My Rights',
      'about': 'About',
      'help': 'Help',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'turkish': 'Turkish',
      'english': 'English',
      'rights_categories': 'Rights Categories',
      'disability_rights': 'Disability Rights',
      'women_rights': 'Women Rights',
      'elderly_rights': 'Elderly Rights',
      'children_rights': 'Children Rights',
      'fundamental_rights': 'Fundamental Rights',
      'search': 'Search',
      'search_rights': 'Search Your Rights',
      'quiz': 'Quiz',
      'start_quiz': 'Start Quiz',
      'next': 'Next',
      'previous': 'Previous',
      'finish': 'Finish',
      'correct': 'Correct',
      'wrong': 'Wrong',
      'score': 'Score',
      'home': 'Home',
      'categories': 'Categories',
      'search_tab': 'Search',
      'profile': 'Profile',
      'learn_rights': 'Learn Your Rights',
      'take_quiz': 'Take Quiz',
      'search_description': 'Search and Learn Your Rights',
      'categories_description': 'Explore Rights Categories',
      'quiz_description': 'Test Your Knowledge',
      'profile_description': 'Manage Your Profile',
      'link_error': 'Could not open the link',
      'more_info': 'Click for more information',
      'mixed': 'Mixed',
    },
    'tr': {
      'app_name': 'Haklarımı Biliyorum',
      'about': 'Hakkında',
      'help': 'Yardım',
      'dark_mode': 'Karanlık Mod',
      'language': 'Dil',
      'turkish': 'Türkçe',
      'english': 'İngilizce',
      'rights_categories': 'Hak Kategorileri',
      'disability_rights': 'Engelli Hakları',
      'women_rights': 'Kadın Hakları',
      'elderly_rights': 'Yaşlı Hakları',
      'children_rights': 'Çocuk Hakları',
      'fundamental_rights': 'Temel Haklar',
      'search': 'Ara',
      'search_rights': 'Haklarını Ara',
      'quiz': 'Test',
      'start_quiz': 'Teste Başla',
      'next': 'İleri',
      'previous': 'Geri',
      'finish': 'Bitir',
      'correct': 'Doğru',
      'wrong': 'Yanlış',
      'score': 'Puan',
      'home': 'Ana Sayfa',
      'categories': 'Kategoriler',
      'search_tab': 'Arama',
      'profile': 'Profil',
      'learn_rights': 'Haklarını Öğren',
      'take_quiz': 'Test Çöz',
      'search_description': 'Haklarını Ara ve Öğren',
      'categories_description': 'Hak Kategorilerini İncele',
      'quiz_description': 'Bilgilerini Test Et',
      'profile_description': 'Profilini Yönet',
      'link_error': 'Link açılamadı',
      'more_info': 'Daha fazla bilgi için tıklayın',
      'mixed': 'Karışık',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'tr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
