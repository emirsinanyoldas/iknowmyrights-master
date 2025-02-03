import 'package:flutter/material.dart';
import 'package:iknowmyrights/theme/app_theme.dart';
import 'dart:convert';
import 'package:iknowmyrights/screens/quiz/quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  List<int> userAnswers = [];
  bool isLoading = true;
  bool hasError = false;
  bool? isCorrect;
  bool showExplanation = false;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final String jsonString =
          await DefaultAssetBundle.of(context).loadString('assets/data/quiz_questions.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      
      List<Map<String, dynamic>> loadedQuestions = [];
      
      if (widget.category == 'mixed') {
        data['Turkish']['categories'].forEach((key, value) {
          if (value['questions'] != null) {
            loadedQuestions.addAll(List<Map<String, dynamic>>.from(value['questions']));
          }
        });
      } else {
        final categoryQuestions = data['Turkish']['categories'][widget.category]['questions'];
        if (categoryQuestions != null) {
          loadedQuestions = List<Map<String, dynamic>>.from(categoryQuestions);
        }
      }

      if (loadedQuestions.isEmpty) {
        throw Exception('Bu kategori için soru bulunamadı');
      }

      loadedQuestions.shuffle();
      questions = loadedQuestions;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading questions: $e');
      setState(() {
        isLoading = false;
        hasError = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sorular yüklenirken bir hata oluştu')),
        );
      }
    }
  }

  void _nextQuestion() {
    if (isNavigating) return;

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isCorrect = null;
        showExplanation = false;
      });
    } else if (userAnswers.length == questions.length) {
      setState(() {
        isNavigating = true;
      });
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            questions: questions,
            userAnswers: userAnswers,
          ),
        ),
      );
    }
  }

  void _answerQuestion(int answerIndex) {
    if (isCorrect != null) return;
    
    final bool correct = answerIndex == questions[currentQuestionIndex]['correctAnswer'];
    
    setState(() {
      isCorrect = correct;
      showExplanation = !correct;
      userAnswers.add(answerIndex);
    });

    if (correct) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        _nextQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError || questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Hata'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sorular yüklenemedi. Lütfen tekrar deneyin.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Geri Dön'),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Soru ${currentQuestionIndex + 1}/10'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / 10,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              question['question'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ...List.generate(
              question['options'].length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: isCorrect != null ? null : () => _answerQuestion(index),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: isCorrect != null
                        ? (index == question['correctAnswer']
                            ? Colors.green
                            : (index == userAnswers.lastOrNull
                                ? Colors.red
                                : null))
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    question['options'][index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            if (showExplanation && !isCorrect!) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Açıklama:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question['explanation'],
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isCorrect != null ? _nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Sonraki Soru',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 