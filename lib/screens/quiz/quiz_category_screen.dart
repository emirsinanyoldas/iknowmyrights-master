import 'package:flutter/material.dart';
import 'package:iknowmyrights/theme/app_theme.dart';
import 'package:iknowmyrights/screens/quiz/quiz_screen.dart';

class QuizCategoryScreen extends StatelessWidget {
  const QuizCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hak Bilgisi Yarışması'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Kategori Seçin',
              style: TextStyle(
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
                  _buildAnimatedCategoryCard(
                    context,
                    'Engelli Hakları',
                    Icons.accessible,
                    'disability',
                  ),
                  _buildAnimatedCategoryCard(
                    context,
                    'Kadın Hakları',
                    Icons.female,
                    'women',
                  ),
                  _buildAnimatedCategoryCard(
                    context,
                    'Yaşlı Hakları',
                    Icons.elderly,
                    'elderly',
                  ),
                  _buildAnimatedCategoryCard(
                    context,
                    'Çocuk Hakları',
                    Icons.child_care,
                    'children',
                  ),
                  _buildAnimatedCategoryCard(
                    context,
                    'Temel Haklar',
                    Icons.gavel,
                    'fundamental',
                  ),
                  _buildAnimatedCategoryCard(
                    context,
                    'Karışık',
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

  Widget _buildAnimatedCategoryCard(
      BuildContext context,
      String title,
      IconData icon,
      String category,
      ) {
    return MouseRegion(
      onEnter: (_) {},
      onExit: (_) {},
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
        tween: Tween<double>(begin: 1.0, end: 1.0),
        builder: (context, scale, child) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(category: category),
                ),
              );
            },
            child: Transform.scale(
              scale: scale,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100), // Yuvarlak kenar
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Tam yuvarlak kart
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
            ),
          );
        },
      ),
    );
  }
}