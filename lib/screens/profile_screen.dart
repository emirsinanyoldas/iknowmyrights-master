import 'package:flutter/material.dart';
import 'package:iknowmyrights/theme/app_theme.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iknowmyrights/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> quizHistory = [];
  List<String> savedRights = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Kullanıcı verilerini yükle
      final String? userDataString = prefs.getString('user_data');
      if (userDataString != null) {
        setState(() {
          userData = json.decode(userDataString);
        });
      }

      // Quiz geçmişini yükle
      final String? quizHistoryString = prefs.getString('quiz_history');
      if (quizHistoryString != null) {
        setState(() {
          quizHistory = List<Map<String, dynamic>>.from(
            json.decode(quizHistoryString),
          );
        });
      }

      // Kaydedilen hakları yükle
      setState(() {
        savedRights = prefs.getStringList('saved_rights') ?? [];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading user data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Kartı
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        userData?['avatarUrl'] ?? 
                        'https://via.placeholder.com/80',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData?['name'] ?? 'Kullanıcı',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData?['email'] ?? 'kullanici@email.com',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // İstatistikler
            Text(
              'İstatistikler',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Çözülen Test',
                    '${quizHistory.length}',
                    Icons.quiz,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Ortalama Puan',
                    _calculateAverageScore(),
                    Icons.score,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quiz Geçmişi
            Text(
              'Quiz Geçmişi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quizHistory.length,
              itemBuilder: (context, index) {
                final quiz = quizHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      Icons.check_circle,
                      color: quiz['score'] >= 7 ? Colors.green : Colors.orange,
                    ),
                    title: Text(quiz['category']),
                    subtitle: Text('Tarih: ${quiz['date']}'),
                    trailing: Text(
                      '${quiz['score']}/10',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateAverageScore() {
    if (quizHistory.isEmpty) return '0';
    final totalScore = quizHistory.fold<int>(
      0,
      (sum, quiz) => sum + (quiz['score'] as int),
    );
    return (totalScore / quizHistory.length).toStringAsFixed(1);
  }
}
