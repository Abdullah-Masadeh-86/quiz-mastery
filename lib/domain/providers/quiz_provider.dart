import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/constants.dart';
import '../../data/datasources/question_data_source.dart';
import '../../data/datasources/local_storage_data_source.dart';
import '../../data/models/question.dart';
import '../../data/models/quiz_result.dart';

enum QuizState { initial, loading, ready, inProgress, finished }

class QuizProvider extends ChangeNotifier {
  final QuestionDataSource _questionDataSource = QuestionDataSource();
  final LocalStorageDataSource _localStorage = LocalStorageDataSource();

  QuizState _state = QuizState.initial;
  String _selectedCategory = '';
  String _selectedDifficulty = 'Easy';
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _correctAnswers = 0;
  int _remainingTime = AppConstants.questionTimeLimit;
  int? _selectedAnswerIndex;
  bool _answerRevealed = false;
  Timer? _timer;
  List<QuizResult> _highScores = [];
  int _totalTimeTaken = 0;
  DateTime? _quizStartTime;

  QuizState get state => _state;
  String get selectedCategory => _selectedCategory;
  String get selectedDifficulty => _selectedDifficulty;
  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int get correctAnswers => _correctAnswers;
  int get remainingTime => _remainingTime;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get answerRevealed => _answerRevealed;
  List<QuizResult> get highScores => _highScores;

  Question? get currentQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length
      ? _questions[_currentQuestionIndex]
      : null;

  bool get isLastQuestion =>
      _questions.isEmpty || _currentQuestionIndex >= _questions.length - 1;
  double get progress => _questions.isEmpty
      ? 0.0
      : (_currentQuestionIndex + 1) / _questions.length;

  Future<void> init() async {
    try {
      _highScores = await _localStorage.getHighScores();
    } catch (e) {
      print('Error loading high scores: $e');
      _highScores = [];
    }
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void selectDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  Future<void> startQuiz() async {
    _state = QuizState.loading;
    notifyListeners();

    _questions = _questionDataSource.getQuestions(
      _selectedCategory,
      _selectedDifficulty,
      AppConstants.questionsPerQuiz,
    );

    if (_questions.length < 5) {
      _questions = _questionDataSource.getQuestionsByCategory(
        _selectedCategory,
        AppConstants.questionsPerQuiz,
      );
    }

    if (_questions.isEmpty) {
      _questions = _questionDataSource.getRandomQuestions(
        AppConstants.questionsPerQuiz,
      );
    }

    _currentQuestionIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _totalTimeTaken = 0;
    _quizStartTime = DateTime.now();

    _state = QuizState.ready;
    notifyListeners();

    _startTimer();
  }

  void _startTimer() {
    _remainingTime = AppConstants.questionTimeLimit;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        if (!_answerRevealed) {
          _submitAnswer(-1);
        }
      }
    });
  }

  void selectAnswer(int index) {
    if (_answerRevealed) return;
    _selectedAnswerIndex = index;
    notifyListeners();
  }

  void _submitAnswer(int index) {
    _timer?.cancel();
    _selectedAnswerIndex = index;
    _answerRevealed = true;

    if (index >= 0 && currentQuestion?.isCorrect(index) == true) {
      _correctAnswers++;

      int timeBonus = _remainingTime * AppConstants.bonusPointsPerSecond;
      _score += AppConstants.pointsPerCorrectAnswer + timeBonus;
    }

    notifyListeners();
  }

  void nextQuestion() {
    if (isLastQuestion) {
      _finishQuiz();
    } else {
      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      _answerRevealed = false;
      _startTimer();
      notifyListeners();
    }
  }

  Future<void> _finishQuiz() async {
    _timer?.cancel();
    _state = QuizState.finished;

    if (_quizStartTime != null) {
      _totalTimeTaken = DateTime.now().difference(_quizStartTime!).inSeconds;
    }

    final result = QuizResult(
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
      totalQuestions: _questions.length,
      correctAnswers: _correctAnswers,
      totalScore: _score,
      completedAt: DateTime.now(),
      timeTaken: _totalTimeTaken,
    );

    try {
      await _localStorage.saveHighScore(result);
      _highScores = await _localStorage.getHighScores();
    } catch (e) {
      print('Error saving quiz result: $e');
    }

    notifyListeners();
  }

  void resetQuiz() {
    _timer?.cancel();
    _state = QuizState.initial;
    _questions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _selectedAnswerIndex = null;
    _answerRevealed = false;
    _totalTimeTaken = 0;
    notifyListeners();
  }

  void submitAnswer() {
    if (_selectedAnswerIndex != null && !_answerRevealed) {
      _submitAnswer(_selectedAnswerIndex!);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
