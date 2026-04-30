import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../domain/providers/quiz_provider.dart';
import 'home_screen.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        final correctAnswers = quizProvider.correctAnswers;
        final totalQuestions = quizProvider.questions.length;
        final accuracy = totalQuestions > 0
            ? (correctAnswers / totalQuestions * 100).round()
            : 0;

        return PopScope(
          canPop: false,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildResultIcon(accuracy),
                      const SizedBox(height: 24),
                      _buildGrade(accuracy),
                      const SizedBox(height: 32),
                      _buildScoreCard(context, quizProvider),
                      const SizedBox(height: 24),
                      _buildStatsRow(correctAnswers, totalQuestions),
                      const SizedBox(height: 40),
                      _buildActionButtons(context, quizProvider),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultIcon(int accuracy) {
    IconData icon;
    Color color;

    if (accuracy >= 80) {
      icon = Icons.emoji_events;
      color = const Color(0xFFFFD700);
    } else if (accuracy >= 60) {
      icon = Icons.celebration;
      color = AppTheme.correctColor;
    } else if (accuracy >= 40) {
      icon = Icons.thumb_up;
      color = AppTheme.warningColor;
    } else {
      icon = Icons.sentiment_dissatisfied;
      color = AppTheme.wrongColor;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 60, color: color),
    );
  }

  Widget _buildGrade(int accuracy) {
    String grade;
    Color color;

    if (accuracy >= 90) {
      grade = 'Excellent!';
      color = AppTheme.correctColor;
    } else if (accuracy >= 70) {
      grade = 'Great Job!';
      color = AppTheme.correctColor;
    } else if (accuracy >= 50) {
      grade = 'Good Effort!';
      color = AppTheme.warningColor;
    } else if (accuracy >= 30) {
      grade = 'Keep Trying!';
      color = AppTheme.warningColor;
    } else {
      grade = 'Need Practice';
      color = AppTheme.wrongColor;
    }

    return Column(
      children: [
        Text(
          grade,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'You scored $accuracy%',
          style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildScoreCard(BuildContext context, QuizProvider quizProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Total Score',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '${quizProvider.score}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(Icons.category, quizProvider.selectedCategory),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.speed, quizProvider.selectedDifficulty),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int correctAnswers, int totalQuestions) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle,
            iconColor: AppTheme.correctColor,
            label: 'Correct',
            value: '$correctAnswers',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.cancel,
            iconColor: AppTheme.wrongColor,
            label: 'Wrong',
            value: '${totalQuestions - correctAnswers}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.help_outline,
            iconColor: AppTheme.primaryColor,
            label: 'Total',
            value: '$totalQuestions',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, QuizProvider quizProvider) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            quizProvider.startQuiz().then((_) {
              if (quizProvider.state == QuizState.ready) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.replay, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Play Again',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            quizProvider.resetQuiz();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            side: BorderSide(color: AppTheme.primaryColor, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, color: AppTheme.primaryColor),
              SizedBox(width: 8),
              Text(
                'Home',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
