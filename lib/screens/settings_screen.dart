import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iknowmyrights/providers/theme_provider.dart';
import 'package:iknowmyrights/providers/language_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: const Text('Karanlık Mod'),
                value: themeProvider.isDarkMode,
                onChanged: (bool value) {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return ListTile(
                title: const Text('Dil'),
                subtitle: Text(
                  languageProvider.currentLanguage == 'TR' ? 'Türkçe' : 'English',
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Dil Seçin'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('Türkçe'),
                              onTap: () {
                                languageProvider.setLanguage('TR');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('English'),
                              onTap: () {
                                languageProvider.setLanguage('EN');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
} 