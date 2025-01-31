import 'package:flutter/material.dart';
import 'package:iknowmyrights/theme/app_theme.dart';
import 'package:iknowmyrights/screens/developer_detail_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hakkında'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uygulama Hakkında',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Bu uygulama, temel insan haklarını herkes için erişilebilir ve anlaşılır kılmayı amaçlamaktadır. Engelli hakları, kadın hakları, yaşlı hakları ve çocuk hakları gibi özel alanlarda bilgilendirme yaparak toplumsal farkındalığı artırmayı hedeflemekteyiz.\n\n'
                      'Projemiz, haklar konusunda farkındalık yaratmak ve bu hakların kullanımını kolaylaştırmak için tasarlanmıştır. Kullanıcı dostu arayüzü ve kapsamlı içeriği ile herkesin haklarını öğrenmesini ve korumasını destekliyoruz.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Geliştirici Ekibi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildDeveloperCard(
                  context,
                  name: 'Geliştirici 1',
                  role: 'Takım Lideri',
                  imageUrl: 'assets/images/developer1.jpg',
                  githubUrl: 'github_username1',
                ),
                _buildDeveloperCard(
                  context,
                  name: 'Geliştirici 2',
                  role: 'UI/UX Tasarımcısı',
                  imageUrl: 'assets/images/developer2.jpg',
                  githubUrl: 'github_username2',
                ),
                _buildDeveloperCard(
                  context,
                  name: 'Geliştirici 3',
                  role: 'Backend Geliştirici',
                  imageUrl: 'assets/images/developer3.jpg',
                  githubUrl: 'github_username3',
                ),
                _buildDeveloperCard(
                  context,
                  name: 'Geliştirici 4',
                  role: 'Frontend Geliştirici',
                  imageUrl: 'assets/images/developer4.jpg',
                  githubUrl: 'github_username4',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperCard(
    BuildContext context, {
    required String name,
    required String role,
    required String imageUrl,
    required String githubUrl,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeveloperDetailScreen(
                name: name,
                role: role,
                imageUrl: imageUrl,
                githubUrl: githubUrl,
              ),
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
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(imageUrl),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                role,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textColor.withOpacity(0.8),
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