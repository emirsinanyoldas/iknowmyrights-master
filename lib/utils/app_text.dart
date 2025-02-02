import 'package:flutter/material.dart';
import 'package:iknowmyrights/l10n/app_localizations.dart';

class AppText {
  static String get(BuildContext context, String key) {
    return AppLocalizations.of(context).translate(key);
  }
}
