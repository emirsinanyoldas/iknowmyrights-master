import 'package:flutter/material.dart';
import 'package:iknowmyrights/theme/app_theme.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  File? _profileImage;

  String _getGravatarUrl(String email) {
    final bytes = utf8.encode(email.trim().toLowerCase());
    final hash = md5.convert(bytes).toString();
    return 'https://www.gravatar.com/avatar/$hash?d=identicon&s=400';
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final String jsonString =
          await DefaultAssetBundle.of(context).loadString('assets/data/user_data.json');
      setState(() {
        userData = json.decode(jsonString)['user'];
      });
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
      // İleride: Firebase'e yükle
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final stats = userData!['quizStats'];
    final categoryStats = stats['categoryStats'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppTheme.primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : NetworkImage(_getGravatarUrl(userData!['email'])) as ImageProvider,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 18),
                            color: Colors.white,
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData!['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userData!['email'],
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quiz İstatistikleri',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatCard(
                        'Toplam Soru',
                        stats['totalQuestions'].toString(),
                        Icons.quiz,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        'Doğruluk',
                        '%${stats['accuracyPercentage']}',
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Kategori Bazlı Performans',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...categoryStats.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildCategoryProgress(
                      entry.key,
                      entry.value['accuracy'].toDouble(),
                    ),
                  )),
                  const SizedBox(height: 24),
                  const Text(
                    'Son Quiz\'ler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...stats['quizHistory'].map((quiz) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(quiz['category']),
                      subtitle: Text(quiz['date']),
                      trailing: Text(
                        '${quiz['score']}/${quiz['total']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, {Color? color}) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color ?? AppTheme.primaryColor, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color ?? AppTheme.primaryColor,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryProgress(String category, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category[0].toUpperCase() + category.substring(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            percentage >= 70 ? Colors.green : 
            percentage >= 50 ? Colors.orange : Colors.red,
          ),
        ),
        const SizedBox(height: 4),
        Text('$percentage%'),
      ],
    );
  }
} 