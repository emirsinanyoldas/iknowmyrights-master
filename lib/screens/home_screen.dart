import 'package:flutter/material.dart';
import 'package:iknowmyrights/widgets/rights_card.dart';
import 'package:iknowmyrights/widgets/custom_drawer.dart';
import 'package:iknowmyrights/screens/quiz/quiz_category_screen.dart';
import 'package:iknowmyrights/screens/search_screen.dart';
import 'package:iknowmyrights/widgets/user_profile_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text('Haklarımı Biliyorum'),
        actions: const [
          UserProfileButton(),
        ],
      ),
      drawer: const CustomDrawer(),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: const [
          RightsCard(
            title: 'Engelli Hakları',
            imagePath: 'assets/images/disability_rights.jpg',
            type: 'disability',
          ),
          RightsCard(
            title: 'Kadın Hakları',
            imagePath: 'assets/images/women_rights.jpg',
            type: 'women',
          ),
          RightsCard(
            title: 'Yaşlı Hakları',
            imagePath: 'assets/images/elderly_rights.jpg',
            type: 'elderly',
          ),
          RightsCard(
            title: 'Çocuk Hakları',
            imagePath: 'assets/images/children_rights.jpg',
            type: 'children',
          ),
          RightsCard(
            title: 'Temel Haklar',
            imagePath: 'assets/images/fundamental_rights.jpg',
            type: 'fundamental',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Arama',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuizCategoryScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          }
        },
      ),
    );
  }
} 