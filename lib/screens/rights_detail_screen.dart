import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:iknowmyrights/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class RightsDetailScreen extends StatefulWidget {
  final String title;
  final String type;

  const RightsDetailScreen({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<RightsDetailScreen> createState() => _RightsDetailScreenState();
}

class _RightsDetailScreenState extends State<RightsDetailScreen> {
  List<dynamic> subtopics = [];
  bool isLoading = true;
  Set<int> expandedItems = {};
  Set<int> hoveredItems = {}; // Fare üzerine gelinen öğeleri tutan Set

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link açılamadı')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRightsData();
  }

  Future<void> _loadRightsData() async {
    try {
      String jsonPath;
      switch (widget.type) {
        case 'disability':
          jsonPath = 'assets/data/disabled.json';
          break;
        case 'women':
          jsonPath = 'assets/data/women.json';
          break;
        case 'elderly':
          jsonPath = 'assets/data/elderly.json';
          break;
        case 'children':
          jsonPath = 'assets/data/children.json';
          break;
        default:
          jsonPath = 'assets/data/fundamental.json';
      }

      final String jsonString = await DefaultAssetBundle.of(context).loadString(jsonPath);
      final Map<String, dynamic> data = json.decode(jsonString);

      setState(() {
        subtopics = data['Turkish']['subtopics'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error loading JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subtopics.length,
        itemBuilder: (context, index) {
          final subtopic = subtopics[index];
          final bool isExpanded = expandedItems.contains(index);
          final bool isHovered = hoveredItems.contains(index); // Hovered durumu

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          expandedItems.remove(index);
                        } else {
                          expandedItems.add(index);
                        }
                      });
                    },
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          hoveredItems.add(index); // Fare üzerindeyken yazıyı küçült
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          hoveredItems.remove(index); // Fare ayrıldığında yazıyı eski haline getir
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.1),
                              AppTheme.secondaryColor.withOpacity(0.1),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                subtopic['subheading'] ?? subtopic['title'] ?? '',
                                style: TextStyle(
                                  fontSize: isHovered ? 12.6 : 18, // %30 küçülme
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isExpanded) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subtopic['text'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textColor.withOpacity(0.8),
                              height: 1.5,
                            ),
                          ),
                          if (subtopic['url'] != null) ...[
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => _launchURL(subtopic['url']),
                              icon: const Icon(Icons.link),
                              label: const Text('Daha fazla bilgi için tıklayın'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.secondaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}