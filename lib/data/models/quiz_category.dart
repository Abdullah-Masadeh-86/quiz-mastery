import 'package:flutter/material.dart';

class QuizCategory {
  final String name;
  final IconData icon;
  final Color color;

  const QuizCategory({
    required this.name,
    required this.icon,
    required this.color,
  });

  static List<QuizCategory> get categories => [
    const QuizCategory(
      name: 'Science',
      icon: Icons.science,
      color: Color(0xFF22C55E),
    ),
    const QuizCategory(
      name: 'History',
      icon: Icons.history_edu,
      color: Color(0xFFF59E0B),
    ),
    const QuizCategory(
      name: 'Geography',
      icon: Icons.public,
      color: Color(0xFF3B82F6),
    ),
    const QuizCategory(
      name: 'Sports',
      icon: Icons.sports_soccer,
      color: Color(0xFFEF4444),
    ),
    const QuizCategory(
      name: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFF8B5CF6),
    ),
    const QuizCategory(
      name: 'General Knowledge',
      icon: Icons.lightbulb,
      color: Color(0xFFEC4899),
    ),
  ];

  static QuizCategory getCategoryByName(String name) {
    return categories.firstWhere(
      (cat) => cat.name == name,
      orElse: () => categories.last,
    );
  }
}
