import 'package:flutter/material.dart';
import 'package:iknowmyrights/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperDetailScreen extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;
  final String githubUrl;

  const DeveloperDetailScreen({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.githubUrl,
  });

  Future<void> _launchGitHub() async {
    final Uri url = Uri.parse('https://github.com/$githubUrl');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(height: 24),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              role,
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _launchGitHub,
              icon: const Icon(Icons.code),
              label: const Text('GitHub Profilini Ziyaret Et'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hakkında',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Geliştirici hakkında detaylı bilgi buraya eklenecek...',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 