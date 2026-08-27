import 'package:flutter/material.dart';

import '../services/quiz_history_service.dart';
import '../theme/app_theme.dart';
import 'quiz_screen.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  bool _saved = false;

  double get percentage {
    if (widget.totalQuestions == 0) {
      return 0;
    }

    return widget.score / widget.totalQuestions;
  }

  int get percentageValue {
    return (percentage * 100).round();
  }

  String get resultTitle {
    if (percentage >= 0.9) {
      return 'Outstanding! 🎉';
    }

    if (percentage >= 0.75) {
      return 'Excellent Work! 👏';
    }

    if (percentage >= 0.5) {
      return 'Good Job! 👍';
    }

    return 'Keep Practicing! 💪';
  }

  String get resultMessage {
    if (percentage >= 0.9) {
      return 'You have an excellent understanding of these topics.';
    }

    if (percentage >= 0.75) {
      return 'Great performance. Keep learning and improving.';
    }

    if (percentage >= 0.5) {
      return 'You are making good progress. A little more practice will help.';
    }

    return 'Review your flashcards and try the quiz again.';
  }

  @override
  void initState() {
    super.initState();

    _saveResult();
  }

  Future<void> _saveResult() async {
    await QuizHistoryService.saveQuizResult(
      score: widget.score,
      totalQuestions: widget.totalQuestions,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _saved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(
                              alpha: 0.10,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.emoji_events_rounded,
                            size: 58,
                            color: AppTheme.primaryColor,
                          ),
                        ),

                        const SizedBox(height: 28),

                        Text(
                          'Quiz Complete!',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          resultTitle,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          resultMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.textSecondaryColor,
                                height: 1.5,
                              ),
                        ),

                        const SizedBox(height: 30),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${widget.score} / ${widget.totalQuestions}',
                                style: Theme.of(context).textTheme.displaySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.primaryColor,
                                    ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                '$percentageValue%',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                'Your Score',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.textSecondaryColor,
                                    ),
                              ),

                              const SizedBox(height: 16),

                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: _saved
                                    ? Row(
                                        key: const ValueKey('saved'),
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            size: 18,
                                            color: AppTheme.successColor,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Result saved',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppTheme.successColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(
                                        key: ValueKey('saving'),
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        _buildStatistics(context),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    );
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    final bestScore = QuizHistoryService.getBestScore();
    final averageScore = QuizHistoryService.getAverageScore();
    final totalQuizzes = QuizHistoryService.getTotalQuizzes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quiz Statistics',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _StatisticCard(
                title: 'Best Score',
                value: '${bestScore.round()}%',
                icon: Icons.emoji_events_rounded,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _StatisticCard(
                title: 'Average',
                value: '${averageScore.round()}%',
                icon: Icons.trending_up_rounded,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _StatisticCard(
                title: 'Quizzes',
                value: totalQuizzes.toString(),
                icon: Icons.quiz_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
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
