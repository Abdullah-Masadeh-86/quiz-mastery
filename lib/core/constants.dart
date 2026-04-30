class AppConstants {
  static const int questionTimeLimit = 30;
  static const int questionsPerQuiz = 10;
  static const int pointsPerCorrectAnswer = 10;
  static const int bonusPointsPerSecond = 1;

  static const List<String> categories = [
    'Science',
    'History',
    'Geography',
    'Sports',
    'Entertainment',
    'General Knowledge',
  ];

  static const List<String> difficultyLevels = ['Easy', 'Medium', 'Hard'];

  static const String highScoresKey = 'high_scores';
  static const String soundEnabledKey = 'sound_enabled';
}
