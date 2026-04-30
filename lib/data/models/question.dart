class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String category;
  final String difficulty;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
    required this.difficulty,
  });

  String get correctAnswer => options[correctAnswerIndex];

  bool isCorrect(int selectedIndex) => selectedIndex == correctAnswerIndex;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'category': category,
      'difficulty': difficulty,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      category: json['category'],
      difficulty: json['difficulty'],
    );
  }
}
