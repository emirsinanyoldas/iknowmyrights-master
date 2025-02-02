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
          AnimatedRightsCard(
            title: 'Engelli Hakları',
            imagePath: 'assets/images/disability_rights.jpg',
            type: 'disability',
          ),
          AnimatedRightsCard(
            title: 'Kadın Hakları',
            imagePath: 'assets/images/women_rights.jpg',
            type: 'women',
          ),
          AnimatedRightsCard(
            title: 'Yaşlı Hakları',
            imagePath: 'assets/images/elderly_rights.jpg',
            type: 'elderly',
          ),
          AnimatedRightsCard(
            title: 'Çocuk Hakları',
            imagePath: 'assets/images/children_rights.jpg',
            type: 'children',
          ),
          AnimatedRightsCard(
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

class AnimatedRightsCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final String type;

  const AnimatedRightsCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.type,
  });

  @override
  _AnimatedRightsCardState createState() => _AnimatedRightsCardState();
}

class _AnimatedRightsCardState extends State<AnimatedRightsCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _scale = 1.1; // Hafif büyüme
        });
      },
      onExit: (_) {
        setState(() {
          _scale = 1.0; // Normal boyuta dön
        });
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        child: RightsCard(
          title: widget.title,
          imagePath: widget.imagePath,
          type: widget.type,
        ),
      ),
    );
  }
}
