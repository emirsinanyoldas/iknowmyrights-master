import 'package:flutter/material.dart';
import 'package:iknowmyrights/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iknowmyrights/screens/right_detail_screen.dart';
import 'package:flutter/foundation.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  List<String> _searchHistory = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  bool _isSpeechAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _checkSpeechAvailability();
  }

  Future<void> _checkSpeechAvailability() async {
    if (!Platform.isWindows) {  // Windows'ta speech özelliğini devre dışı bırak
      try {
        final available = await _speech.initialize(
          onError: (error) => print('Speech Error: $error'),
          onStatus: (status) => print('Speech Status: $status'),
        );
        if (mounted) {
          setState(() {
            _isSpeechAvailable = available;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isSpeechAvailable = false;
          });
        }
        print('Speech initialization error: $e');
      }
    } else {
      setState(() {
        _isSpeechAvailable = false;
      });
    }
  }

  Future<void> _loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _searchHistory = prefs.getStringList('search_history') ?? [];
      });
    } catch (e) {
      print('Error loading search history: $e');
    }
  }

  Future<void> _saveSearchHistory(String query) async {
    if (query.trim().isEmpty) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('search_history') ?? [];
      
      if (!history.contains(query)) {
        history.insert(0, query);
        if (history.length > 5) {
          history.removeLast();
        }
        await prefs.setStringList('search_history', history);
        setState(() {
          _searchHistory = history;
        });
      }
    } catch (e) {
      print('Error saving search history: $e');
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // Tüm JSON dosyalarını yükle
      final List<String> jsonFiles = [
        'assets/data/women.json',
        'assets/data/disabled.json',
        'assets/data/elderly.json',
        'assets/data/children.json',
        'assets/data/fundamental.json'
      ];

      List<Map<String, dynamic>> allResults = [];

      for (String file in jsonFiles) {
        try {
          final String jsonString = await DefaultAssetBundle.of(context).loadString(file);
          final Map<String, dynamic> data = json.decode(jsonString);
          
          if (data.containsKey('rights')) {
            final List<dynamic> rights = data['rights'];
            
            for (var right in rights) {
              if (right['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
                  right['content'].toString().toLowerCase().contains(query.toLowerCase())) {
                allResults.add({
                  'title': right['title'],
                  'text': right['content'],
                  'category': file.split('/').last.split('.').first,
                });
              }
            }
          }
        } catch (e) {
          print('Error loading $file: $e');
        }
      }

      if (mounted) {
        setState(() {
          _searchResults = allResults;
          _isLoading = false;
        });
      }

      await _saveSearchHistory(query);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Arama yapılırken bir hata oluştu')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.search ?? 'Arama'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n?.search_rights ?? 'Haklarını Ara',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: _performSearch,
                  ),
                ),
                if (_isSpeechAvailable)
                  IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    onPressed: () async {
                      if (!_isListening) {
                        final available = await _speech.initialize();
                        if (available) {
                          setState(() => _isListening = true);
                          await _speech.listen(
                            onResult: (result) {
                              setState(() {
                                _searchController.text = result.recognizedWords;
                                if (result.finalResult) {
                                  _performSearch(result.recognizedWords);
                                  _isListening = false;
                                }
                              });
                            },
                          );
                        }
                      } else {
                        setState(() => _isListening = false);
                        _speech.stop();
                      }
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: _buildSearchResults(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      if (_searchHistory.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Son Aramalar',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _searchHistory.map((query) => ActionChip(
                  label: Text(query),
                  onPressed: () {
                    _searchController.text = query;
                    _performSearch(query);
                  },
                )).toList(),
              ),
            ],
          ),
        );
      }
      
      return Center(
        child: Text(
          _searchController.text.isEmpty
              ? 'Arama yapmak için yukarıdaki alanı kullanın'
              : 'Sonuç bulunamadı',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(result['title'] ?? ''),
            subtitle: Text(
              result['text'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RightDetailScreen(
                    title: result['title'] ?? '',
                    content: result['text'] ?? '',
                    category: result['category'] ?? '',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _speech.stop();
    super.dispose();
  }
}
