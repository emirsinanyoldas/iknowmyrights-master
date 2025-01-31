import 'package:flutter/material.dart';
import 'package:iknowmyrights/screens/profile_screen.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart'; // MD5 hash için eklendi

class UserProfileButton extends StatefulWidget {
  const UserProfileButton({super.key});

  @override
  State<UserProfileButton> createState() => _UserProfileButtonState();
}

class _UserProfileButtonState extends State<UserProfileButton> {
  Map<String, dynamic>? userData;

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

  String _getGravatarUrl(String email) {
    final bytes = utf8.encode(email.trim().toLowerCase());
    final hash = md5.convert(bytes).toString();
    return 'https://www.gravatar.com/avatar/$hash?d=identicon&s=200';
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const IconButton(
        icon: Icon(Icons.account_circle),
        onPressed: null,
      );
    }

    final gravatarUrl = _getGravatarUrl(userData!['email']);

    return PopupMenuButton<int>(
      offset: const Offset(0, 56),
      icon: CircleAvatar(
        backgroundImage: NetworkImage(gravatarUrl),
        radius: 16,
      ),
      itemBuilder: (context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(gravatarUrl),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userData!['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userData!['email'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 1,
          child: const Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 12),
              Text('Profil'),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            ),
          );
        }
      },
    );
  }
} 