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
  Set<int> hoveredItems = {};

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

      if (data['Turkish'] == null || data['Turkish']['subtopics'] == null) {
        throw Exception('Geçersiz JSON formatı');
      }

      setState(() {
        subtopics = List<Map<String, dynamic>>.from(data['Turkish']['subtopics']);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('İçerik yüklenirken bir hata oluştu')),
        );
      }
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
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListView.builder(
                  itemCount: subtopics.length,
                  itemBuilder: (context, index) {
                    final subtopic = subtopics[index];
                    final bool isExpanded = expandedItems.contains(index);
                    final bool isHovered = hoveredItems.contains(index);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            hoveredItems.add(index);
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            hoveredItems.remove(index);
                          });
                        },
                        child: Card(
                          elevation: isHovered ? 4 : 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).cardColor,
                            ),
                            child: ExpansionTile(
                              title: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  fontSize: isHovered ? 15 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                                child: Text(
                                  subtopic['title'] ?? subtopic['subheading'] ?? 'Başlık bulunamadı',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (subtopic['text'] != null)
                                        Text(
                                          subtopic['text'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            height: 1.5,
                                          ),
                                        ),
                                      if (subtopic['url'] != null) ...[
                                        const SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          onPressed: () => _launchURL(subtopic['url']),
                                          icon: const Icon(Icons.link),
                                          label: const Text('Daha fazla bilgi'),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}