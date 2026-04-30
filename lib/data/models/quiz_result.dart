class QuizResult {
  final String category;
  final String difficulty;
  final int totalQuestions;
  final int correctAnswers;
  final int totalScore;
  final DateTime completedAt;
  final int timeTaken;

  QuizResult({
    required this.category,
    required this.difficulty,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalScore,
    required this.completedAt,
    required this.timeTaken,
  });

  double get accuracy => (correctAnswers / totalQuestions) * 100;

  String get grade {
    if (accuracy >= 90) return 'Excellent!';
    if (accuracy >= 70) return 'Great!';
    if (accuracy >= 50) return 'Good';
    if (accuracy >= 30) return 'Keep Trying';
    return 'Need Improvement';
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'difficulty': difficulty,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'totalScore': totalScore,
      'completedAt': completedAt.toIso8601String(),
      'timeTaken': timeTaken,
    };
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      category: json['category'] as String? ?? 'General Knowledge',
      difficulty: json['difficulty'] as String? ?? 'Easy',
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 0,
      correctAnswers: (json['correctAnswers'] as num?)?.toInt() ?? 0,
      totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      timeTaken: (json['timeTaken'] as num?)?.toInt() ?? 0,
    );
  }
}
