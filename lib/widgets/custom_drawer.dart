import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iknowmyrights/screens/about_screen.dart';
import 'package:iknowmyrights/screens/help_screen.dart';
import 'package:iknowmyrights/theme/theme_provider.dart';
import 'package:iknowmyrights/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance,
                  size: 50,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.app_name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.about),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => ListTile(
              leading: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: Text(l10n.dark_mode),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
              ),
            ),
          ),
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, _) => ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.language),
              trailing: PopupMenuButton<String>(
                initialValue: languageProvider.currentLocale.languageCode,
                onSelected: (String value) {
                  languageProvider.changeLanguage(value);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'tr',
                    child: Text(l10n.turkish),
                  ),
                  PopupMenuItem<String>(
                    value: 'en',
                    child: Text(l10n.english),
                  ),
                ],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      languageProvider.currentLocale.languageCode == 'tr'
                          ? l10n.turkish
                          : l10n.english,
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(l10n.help),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
