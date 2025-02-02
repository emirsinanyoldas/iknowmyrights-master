import 'package:flutter/material.dart';
import 'package:iknowmyrights/l10n/app_en.dart';
import 'package:iknowmyrights/l10n/app_tr.dart';

class LocalizationService {
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': AppEn.values,
    'tr': AppTr.values,
  };

  static String translate(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? key;
  }

  static String getString(String languageCode, String key) {
    return _localizedValues[languageCode]?[key] ?? key;
  }
}
