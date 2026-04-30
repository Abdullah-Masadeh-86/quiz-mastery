import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../domain/providers/quiz_provider.dart';
import '../widgets/question_card.dart';
import '../widgets/answer_option.dart';
import '../widgets/timer_widget.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        if (quizProvider.state == QuizState.loading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.primaryColor),
                  SizedBox(height: 20),
                  Text('Loading questions...'),
                ],
              ),
            ),
          );
        }

        if (quizProvider.state == QuizState.finished) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ResultScreen()),
            );
          });
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              _showExitDialog(context, quizProvider);
            }
          },
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context, quizProvider),
                      const SizedBox(height: 20),
                      _buildProgressBar(quizProvider),
                      const SizedBox(height: 24),
                      _buildTimer(quizProvider),
                      const SizedBox(height: 24),
                      Expanded(child: _buildQuestionContent(quizProvider)),
                      const SizedBox(height: 20),
                      _buildBottomSection(context, quizProvider),
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

  Widget _buildHeader(BuildContext context, QuizProvider quizProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _showExitDialog(context, quizProvider),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.close, color: AppTheme.textPrimary),
          ),
        ),
        Column(
          children: [
            Text(
              quizProvider.selectedCategory,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              quizProvider.selectedDifficulty,
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.white, size: 18),
              const SizedBox(width: 4),
              Text(
                '${quizProvider.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(QuizProvider quizProvider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${quizProvider.currentQuestionIndex + 1}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              '${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: quizProvider.progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildTimer(QuizProvider quizProvider) {
    return TimerWidget(
      remainingTime: quizProvider.remainingTime,
      totalTime: 30,
    );
  }

  Widget _buildQuestionContent(QuizProvider quizProvider) {
    final question = quizProvider.currentQuestion;
    if (question == null) {
      return const Center(child: Text('No question available'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          QuestionCard(question: question.question),
          const SizedBox(height: 24),
          ...List.generate(
            question.options.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnswerOption(
                text: question.options[index],
                index: index,
                isSelected: quizProvider.selectedAnswerIndex == index,
                isCorrect: question.correctAnswerIndex == index,
                isRevealed: quizProvider.answerRevealed,
                onTap: () {
                  if (!quizProvider.answerRevealed) {
                    quizProvider.selectAnswer(index);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, QuizProvider quizProvider) {
    if (quizProvider.answerRevealed) {
      return ElevatedButton(
        onPressed: () {
          quizProvider.nextQuestion();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          quizProvider.isLastQuestion ? 'See Results' : 'Next Question',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: quizProvider.selectedAnswerIndex != null
          ? () => quizProvider.submitAnswer()
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: quizProvider.selectedAnswerIndex != null
            ? AppTheme.primaryColor
            : Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text(
        'Submit Answer',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context, QuizProvider quizProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              quizProvider.resetQuiz();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.wrongColor,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
