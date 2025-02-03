import 'package:flutter/material.dart';
import 'package:iknowmyrights/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';
import 'package:iknowmyrights/l10n/app_localizations.dart';
import 'package:iknowmyrights/screens/right_detail_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize();
    if (mounted) {
      setState(() => _isListening = available);
    }
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  Future<void> _saveSearchHistory(String query) async {
    if (query.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    
    if (!history.contains(query)) {
      history.insert(0, query);
      if (history.length > 10) history.removeLast();
      await prefs.setStringList('search_history', history);
      setState(() {
        _searchHistory = history;
      });
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/search_data.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      final List<Map<String, dynamic>> results = [];
      for (var item in data['content']) {
        if (item['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
            item['text'].toString().toLowerCase().contains(query.toLowerCase())) {
          results.add(item);
        }
      }

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });

      await _saveSearchHistory(query);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Arama yapılırken bir hata oluştu')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.search),
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
                      hintText: l10n.search_rights,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: _performSearch,
                  ),
                ),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: () async {
                    if (!_isListening) {
                      bool available = await _speech.initialize();
                      if (available) {
                        await _speech.listen(
                          onResult: (result) {
                            setState(() {
                              _searchController.text = result.recognizedWords;
                              if (result.finalResult) {
                                _performSearch(result.recognizedWords);
                              }
                            });
                          },
                        );
                      }
                    } else {
                      await _speech.stop();
                    }
                    setState(() => _isListening = !_isListening);
                  },
                ),
              ],
            ),
          ),
          if (_searchHistory.isNotEmpty && _searchResults.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    children: _searchHistory
                        .map(
                          (query) => ActionChip(
                            label: Text(query),
                            onPressed: () {
                              _searchController.text = query;
                              _performSearch(query);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? 'Arama yapmak için yukarıdaki alanı kullanın'
                              : 'Sonuç bulunamadı',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              title: Text(result['title']),
                              subtitle: Text(
                                result['text'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RightDetailScreen(
                                      title: result['title'],
                                      content: result['text'],
                                      category: result['category'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _speech.cancel();
    super.dispose();
  }
}
