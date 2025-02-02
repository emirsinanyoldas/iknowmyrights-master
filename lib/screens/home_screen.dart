import 'package:flutter/material.dart';
import 'package:iknowmyrights/widgets/rights_card.dart';
import 'package:iknowmyrights/widgets/custom_drawer.dart';
import 'package:iknowmyrights/screens/quiz/quiz_category_screen.dart';
import 'package:iknowmyrights/screens/search_screen.dart';
import 'package:iknowmyrights/widgets/user_profile_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
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
        title: Text(l10n.app_name),
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
        children: [
          RightsCard(
            title: l10n.disability_rights,
            imagePath: 'assets/images/disability_rights.jpg',
            type: 'disability',
          ),
          RightsCard(
            title: l10n.women_rights,
            imagePath: 'assets/images/women_rights.jpg',
            type: 'women',
          ),
          RightsCard(
            title: l10n.elderly_rights,
            imagePath: 'assets/images/elderly_rights.jpg',
            type: 'elderly',
          ),
          RightsCard(
            title: l10n.children_rights,
            imagePath: 'assets/images/children_rights.jpg',
            type: 'children',
          ),
          RightsCard(
            title: l10n.fundamental_rights,
            imagePath: 'assets/images/fundamental_rights.jpg',
            type: 'fundamental',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.quiz),
            label: l10n.quiz,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: l10n.search,
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