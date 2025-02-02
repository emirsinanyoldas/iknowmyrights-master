import 'package:flutter/material.dart';
import 'package:iknowmyrights/theme/app_theme.dart';
import 'package:iknowmyrights/screens/quiz/quiz_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizCategoryScreen extends StatelessWidget {
  const QuizCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quiz),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.rights_categories,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildCategoryCard(
                    context,
                    l10n.disability_rights,
                    Icons.accessible,
                    'disability',
                  ),
                  _buildCategoryCard(
                    context,
                    l10n.women_rights,
                    Icons.female,
                    'women',
                  ),
                  _buildCategoryCard(
                    context,
                    l10n.elderly_rights,
                    Icons.elderly,
                    'elderly',
                  ),
                  _buildCategoryCard(
                    context,
                    l10n.children_rights,
                    Icons.child_care,
                    'children',
                  ),
                  _buildCategoryCard(
                    context,
                    l10n.fundamental_rights,
                    Icons.gavel,
                    'fundamental',
                  ),
                  _buildCategoryCard(
                    context,
                    l10n.mixed,
                    Icons.shuffle,
                    'mixed',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    String category,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(category: category),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor.withOpacity(0.1),
                AppTheme.secondaryColor.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}