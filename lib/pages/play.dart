import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'user_scores.dart'; // Ensure this import is correct

class PlayPage extends StatefulWidget {
  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late Future<List<Question>> _futureQuestions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String? _selectedAnswer;
  Duration _timerDuration = Duration(seconds: 30);
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Map<int, List<String>> _shuffledOptions = {};

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('background.mp3'));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch questions
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _futureQuestions = fetchQuestions(args);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<List<Question>> fetchQuestions(Map<String, dynamic> params) async {
    print("Quiz Parameters: $params");

    final amount = params['numberOfQuestions'];
    final category = params['category'] != '' ? '&category=${params['category']}' : '';
    final difficulty = params['difficulty'] != '' ? '&difficulty=${params['difficulty']}' : '';
    final type = params['type'] != '' ? '&type=${params['type']}' : '';
    final url = 'https://opentdb.com/api.php?amount=$amount$category$difficulty$type';

    print("Constructed URL: $url");

    final response = await http.get(Uri.parse(url));
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['results'];

      print("Fetched Data: ${data.length} questions");

      if (data.isEmpty) {
        throw Exception('No questions fetched from API');
      }

      return data.map((questionData) => Question.fromJson(questionData)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerDuration.inSeconds > 0) {
        setState(() {
          _timerDuration -= Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _isAnswered = false;
      _selectedAnswer = null;
      _timerDuration = Duration(seconds: 30);
      _startTimer();
    });
  }

  void _nextQuestionWithArgs(List<Question> questions) {
    setState(() {
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
        _isAnswered = false;
        _selectedAnswer = null;
        _timerDuration = Duration(seconds: 30);
        _startTimer();
      } else {
        _showScoreDialog();
      }
    });
  }

  void _showScoreDialog() {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final category = args['category'];
    final difficulty = args['difficulty'];

    // Update the user's score in Firestore
    final userId = FirebaseAuth.instance.currentUser!.uid;
    updateScore(userId, _score, category, difficulty);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Quiz Completed!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          content: Text(
            'Your score: $_score/${_currentQuestionIndex + 1}',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: Text(
                'Replay',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/play', arguments: ModalRoute.of(context)!.settings.arguments);
              },
            ),
            TextButton(
              child: Text(
                'Home',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void _checkAnswer(String selectedAnswer, String correctAnswer, List<Question> questions) {
    setState(() {
      _isAnswered = true;
      _selectedAnswer = selectedAnswer;
      if (selectedAnswer == correctAnswer) {
        _score++;
      }
      _timer?.cancel(); // Cancel the timer when an answer is selected
      Future.delayed(Duration(seconds: 1), () => _nextQuestionWithArgs(questions));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF5568FE),
      ),
      body: FutureBuilder<List<Question>>(
        future: _futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load questions'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            if (!_isAnswered && _timer == null) {
              _startTimer();
            }
            return _buildQuestion(snapshot.data![_currentQuestionIndex], snapshot.data!);
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(child: Text('No questions available'));
          } else {
            return Center(child: Text('Unexpected error occurred'));
          }
        },
      ),
    );
  }

  Widget _buildQuestion(Question question, List<Question> questions) {
    print("Displaying Question: $_currentQuestionIndex");

    // Check if the options for this question have been shuffled before
    if (!_shuffledOptions.containsKey(_currentQuestionIndex)) {
      List<String> options = List.from(question.incorrectAnswers);
      options.add(question.correctAnswer);
      options.shuffle(); // Shuffle the options to randomize their order
      _shuffledOptions[_currentQuestionIndex] = options; // Store the shuffled options
    }

    // Retrieve the shuffled options for this question
    List<String> options = _shuffledOptions[_currentQuestionIndex]!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question.question,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Time left: ${_timerDuration.inSeconds}s',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
          SizedBox(height: 20),
          ...options.map((option) {
            return ListTile(
              tileColor: _isAnswered
                  ? (option == question.correctAnswer
                  ? Colors.green
                  : option == _selectedAnswer
                  ? Colors.red
                  : null)
                  : null,
              title: Text(option),
              onTap: !_isAnswered
                  ? () => _checkAnswer(option, question.correctAnswer, questions)
                  : null,
            );
          }).toList(),
        ],
      ),
    );
  }
}

class Question {
  final String type;
  final String difficulty;
  final String category;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  Question({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json['type'],
      difficulty: json['difficulty'],
      category: json['category'],
      question: json['question'],
      correctAnswer: json['correct_answer'],
      incorrectAnswers: List<String>.from(json['incorrect_answers']),
    );
  }
}
