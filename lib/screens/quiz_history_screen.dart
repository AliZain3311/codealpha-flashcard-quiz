import 'package:flutter/material.dart';

import '../services/quiz_history_service.dart';
import '../theme/app_theme.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();

    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _history = QuizHistoryService.getHistory().reversed.toList();
    });
  }

  Future<void> _clearHistory() async {
    if (_history.isEmpty) {
      return;
    }

    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear Quiz History?'),
          content: const Text(
            'This will permanently remove all your quiz results. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
              ),
              child: const Text('Clear History'),
            ),
          ],
        );
      },
    );

    if (shouldClear != true) {
      return;
    }

    await QuizHistoryService.clearHistory();

    if (!mounted) {
      return;
    }

    _loadHistory();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiz history cleared.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Unknown date';
    }

    final date = DateTime.tryParse(value);

    if (date == null) {
      return 'Unknown date';
    }

    final localDate = date.toLocal();

    final day = localDate.day.toString().padLeft(2, '0');

    final month = localDate.month.toString().padLeft(2, '0');

    final year = localDate.year.toString();

    final hour12 = localDate.hour == 0
        ? 12
        : localDate.hour > 12
        ? localDate.hour - 12
        : localDate.hour;

    final minute = localDate.minute.toString().padLeft(2, '0');

    final period = localDate.hour >= 12 ? 'PM' : 'AM';

    return '$day/$month/$year • $hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final totalQuizzes = _history.length;

    final bestScore = QuizHistoryService.getBestScore().round();

    final averageScore = QuizHistoryService.getAverageScore().round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              onPressed: _clearHistory,
              tooltip: 'Clear History',
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: SafeArea(
        child: _history.isEmpty
            ? _buildEmptyState(context)
            : RefreshIndicator(
                onRefresh: () async {
                  _loadHistory();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummary(
                        context,
                        totalQuizzes,
                        bestScore,
                        averageScore,
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Previous Attempts',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                            ),
                          ),
                          Text(
                            '$totalQuizzes attempts',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.textSecondaryColor),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      ...List.generate(_history.length, (index) {
                        final quiz = _history[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildHistoryCard(
                            context,
                            quiz,
                            index,
                            bestScore,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSummary(
    BuildContext context,
    int totalQuizzes,
    int bestScore,
    int averageScore,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.history_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Your Quiz Journey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: 'Attempts',
                  value: totalQuizzes.toString(),
                ),
              ),
              Expanded(
                child: _SummaryItem(label: 'Best', value: '$bestScore%'),
              ),
              Expanded(
                child: _SummaryItem(label: 'Average', value: '$averageScore%'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    Map<String, dynamic> quiz,
    int index,
    int bestScore,
  ) {
    final score = (quiz['score'] as num?)?.toInt() ?? 0;

    final totalQuestions = (quiz['totalQuestions'] as num?)?.toInt() ?? 0;

    final percentage = (quiz['percentage'] as num?)?.toInt() ?? 0;

    final date = quiz['date']?.toString();

    final isBest = percentage == bestScore && bestScore > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBest
              ? AppTheme.primaryColor.withValues(alpha: 0.25)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isBest
                      ? AppTheme.primaryColor.withValues(alpha: 0.10)
                      : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isBest ? Icons.emoji_events_rounded : Icons.quiz_rounded,
                  color: isBest
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondaryColor,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Quiz #${_history.length - index}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),

                        if (isBest) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'BEST',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      _formatDate(date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: _scoreColor(percentage),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Score',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$score / $totalQuestions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              Container(width: 1, height: 34, color: const Color(0xFFE2E8F0)),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Performance',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _performanceLabel(percentage),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: _scoreColor(percentage),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                _scoreColor(percentage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(int percentage) {
    if (percentage >= 75) {
      return AppTheme.successColor;
    }

    if (percentage >= 50) {
      return Colors.orange;
    }

    return AppTheme.errorColor;
  }

  String _performanceLabel(int percentage) {
    if (percentage >= 90) {
      return 'Outstanding';
    }

    if (percentage >= 75) {
      return 'Excellent';
    }

    if (percentage >= 50) {
      return 'Good';
    }

    return 'Needs Practice';
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'No Quiz History Yet',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 10),

            Text(
              'Complete your first quiz and your results will appear here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 26),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.quiz_rounded),
              label: const Text('Start a Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
