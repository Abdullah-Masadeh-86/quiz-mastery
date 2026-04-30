import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../data/models/quiz_category.dart';
import '../../domain/providers/quiz_provider.dart';
import 'quiz_screen.dart';
import 'high_scores_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildCategorySelection(),
                  const SizedBox(height: 30),
                  _buildDifficultySelection(),
                  const SizedBox(height: 40),
                  _buildStartButton(),
                  const SizedBox(height: 20),
                  _buildHighScoresButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.quiz, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          'Quiz Master',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Test your knowledge!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Category', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: QuizCategory.categories.length,
              itemBuilder: (context, index) {
                final category = QuizCategory.categories[index];
                final isSelected =
                    quizProvider.selectedCategory == category.name;

                return GestureDetector(
                  onTap: () => quizProvider.selectCategory(category.name),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? category.color : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? category.color
                            : Colors.grey.shade200,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? category.color.withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category.icon,
                          color: isSelected ? Colors.white : category.color,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDifficultySelection() {
    final difficulties = ['Easy', 'Medium', 'Hard'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Difficulty',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            return Row(
              children: difficulties.map((difficulty) {
                final isSelected =
                    quizProvider.selectedDifficulty == difficulty;
                final color = difficulty == 'Easy'
                    ? AppTheme.correctColor
                    : difficulty == 'Medium'
                    ? AppTheme.warningColor
                    : AppTheme.wrongColor;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => quizProvider.selectDifficulty(difficulty),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? color : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? color : Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        difficulty,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        final canStart = quizProvider.selectedCategory.isNotEmpty;

        return ElevatedButton(
          onPressed: canStart
              ? () {
                  quizProvider.startQuiz().then((_) {
                    if (quizProvider.state == QuizState.ready) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizScreen(),
                        ),
                      );
                    }
                  });
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canStart ? AppTheme.primaryColor : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow, size: 28),
              SizedBox(width: 8),
              Text(
                'Start Quiz',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHighScoresButton() {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HighScoresScreen()),
        );
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: AppTheme.primaryColor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, color: AppTheme.primaryColor),
          SizedBox(width: 8),
          Text(
            'High Scores',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
