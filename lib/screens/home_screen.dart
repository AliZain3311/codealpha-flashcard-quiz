import 'package:flutter/material.dart';

import '../models/flashcard_model.dart';
import '../services/progress_service.dart';
import '../services/quiz_history_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'add_edit_flashcard_screen.dart';
import 'flashcards_screen.dart';
import 'quiz_history_screen.dart';
import 'quiz_screen.dart';
import 'study_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Make sure quiz history is initialized when HomeScreen starts.
    QuizHistoryService.init();
  }

  void _refreshHome() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _openQuizHistory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QuizHistoryScreen()),
    );

    // Refresh statistics when returning from history.
    _refreshHome();
  }

  Future<void> _startQuiz() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QuizScreen()),
    );

    // Refresh quiz statistics when returning from quiz.
    _refreshHome();
  }

  Future<void> _openFlashcards() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FlashcardsScreen()),
    );

    // Refresh flashcard/progress data when returning.
    _refreshHome();
  }

  Future<void> _addFlashcard() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditFlashcardScreen()),
    );

    if (result == true) {
      _refreshHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<FlashcardModel> flashcards = StorageService.getFlashcards();

    final int flashcardCount = flashcards.length;

    final int studiedCount = ProgressService.getStudiedCount();

    final Set<String> categories = flashcards
        .map((flashcard) => flashcard.category)
        .toSet();

    final int categoryCount = categories.length;

    final double progress = flashcardCount == 0
        ? 0
        : (studiedCount / flashcardCount).clamp(0.0, 1.0);

    // ----------------------------------------------------------
    // LIVE QUIZ STATISTICS
    // ----------------------------------------------------------

    final int totalQuizzes = QuizHistoryService.getTotalQuizzes();

    final int bestScore = QuizHistoryService.getBestScore().round();

    final int averageScore = QuizHistoryService.getAverageScore().round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlashLearn'),
        actions: [
          // ----------------------------------------------------
          // Quiz History
          // ----------------------------------------------------
          IconButton(
            onPressed: _openQuizHistory,
            tooltip: 'Quiz History',
            icon: const Icon(Icons.history_rounded),
          ),

          // ----------------------------------------------------
          // My Flashcards
          // ----------------------------------------------------
          IconButton(
            onPressed: _openFlashcards,
            tooltip: 'My Flashcards',
            icon: const Icon(Icons.style_outlined),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // WELCOME SECTION
              // ==================================================
              Text(
                'Welcome back!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimaryColor,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Keep learning and build your knowledge.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // MAIN STATISTICS
              // ==================================================
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Flashcards',
                      value: flashcardCount.toString(),
                      icon: Icons.style_rounded,
                      iconColor: AppTheme.primaryColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _StatCard(
                      title: 'Studied',
                      value: studiedCount.toString(),
                      icon: Icons.school_rounded,
                      iconColor: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ==================================================
              // LEARNING PROGRESS
              // ==================================================
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.insights_rounded,
                              color: AppTheme.primaryColor,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Learning Progress',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  '$studiedCount of $flashcardCount cards studied',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            '${(progress * 100).toInt()}%',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primaryColor,
                                ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 9,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // QUIZ STATISTICS
              // ==================================================
              Text(
                'Quiz Statistics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimaryColor,
                ),
              ),

              const SizedBox(height: 14),

              // --------------------------------------------------
              // BEST / AVERAGE / TOTAL QUIZZES
              // --------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: _QuizStatCard(
                      title: 'Best Score',
                      value: '$bestScore%',
                      icon: Icons.emoji_events_rounded,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _QuizStatCard(
                      title: 'Average',
                      value: '$averageScore%',
                      icon: Icons.trending_up_rounded,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _QuizStatCard(
                      title: 'Quizzes',
                      value: totalQuizzes.toString(),
                      icon: Icons.quiz_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // YOUR CATEGORIES
              // ==================================================
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your Categories',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ),

                  Text(
                    '$categoryCount categories',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (categories.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.folder_open_rounded,
                        color: AppTheme.textSecondaryColor,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'No categories yet.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categories.map((category) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppTheme.primaryColor.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.folder_rounded,
                            size: 18,
                            color: AppTheme.primaryColor,
                          ),

                          const SizedBox(width: 7),

                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 28),

              // ==================================================
              // QUICK ACTIONS
              // ==================================================
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimaryColor,
                ),
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // START STUDYING
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: flashcards.isEmpty
                      ? null
                      : () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StudyScreen(),
                            ),
                          );

                          _refreshHome();
                        },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start Studying'),
                ),
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // START QUIZ
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: flashcards.length < 4 ? null : _startQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                  icon: const Icon(Icons.quiz_rounded),
                  label: const Text('Start Quiz'),
                ),
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // MANAGE FLASHCARDS
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _openFlashcards,
                  icon: const Icon(Icons.style_rounded),
                  label: const Text('Manage Flashcards'),
                ),
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // ADD FLASHCARD
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _addFlashcard,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add Flashcard'),
                ),
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // QUIZ REQUIREMENT
              // --------------------------------------------------
              if (flashcards.length < 4)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.orange.shade700,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'Add at least 4 flashcards to start a quiz.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textSecondaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MAIN STATISTICS CARD
// ============================================================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),

            const SizedBox(height: 18),

            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimaryColor,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// QUIZ STATISTICS CARD
// ============================================================

class _QuizStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _QuizStatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: AppTheme.primaryColor),

          const SizedBox(height: 8),

          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
