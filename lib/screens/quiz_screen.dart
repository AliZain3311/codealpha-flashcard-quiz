import 'package:flutter/material.dart';

import '../models/flashcard_model.dart';
import '../services/storage_service.dart';
import '../services/quiz_history_service.dart';
import '../theme/app_theme.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<FlashcardModel> _questions;

  int _currentIndex = 0;
  int _score = 0;

  int? _selectedOption;
  bool _answered = false;
  bool _isSavingResult = false;

  @override
  void initState() {
    super.initState();

    _questions = StorageService.getFlashcards();
  }

  FlashcardModel get _currentQuestion {
    return _questions[_currentIndex];
  }

  List<String> _buildOptions(FlashcardModel question) {
    final options = <String>[question.answer];

    final otherAnswers = _questions
        .where((card) => card.id != question.id)
        .map((card) => card.answer)
        .toList();

    otherAnswers.shuffle();

    for (final answer in otherAnswers) {
      if (options.length >= 4) {
        break;
      }

      if (!options.contains(answer)) {
        options.add(answer);
      }
    }

    while (options.length < 4) {
      options.add('None of the above');
    }

    options.shuffle();

    return options;
  }

  List<String>? _optionsForCurrentQuestion;

  List<String> get _currentOptions {
    _optionsForCurrentQuestion ??= _buildOptions(_currentQuestion);

    return _optionsForCurrentQuestion!;
  }

  void _selectOption(int index) {
    if (_answered || _isSavingResult) {
      return;
    }

    setState(() {
      _selectedOption = index;
      _answered = true;

      if (_currentOptions[index] == _currentQuestion.answer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (!_answered || _isSavingResult) {
      return;
    }

    if (_currentIndex >= _questions.length - 1) {
      _finishQuiz();
      return;
    }

    setState(() {
      _currentIndex++;
      _selectedOption = null;
      _answered = false;
      _optionsForCurrentQuestion = null;
    });
  }

  Future<void> _finishQuiz() async {
    if (_isSavingResult) {
      return;
    }

    setState(() {
      _isSavingResult = true;
    });

    try {
      // Save quiz result BEFORE opening the result screen.
      await QuizHistoryService.saveQuizResult(
        score: _score,
        totalQuestions: _questions.length,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            score: _score,
            totalQuestions: _questions.length,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSavingResult = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to save quiz result. Please try again.\n$e'),
        ),
      );
    }
  }

  Color _optionColor(int index) {
    if (!_answered) {
      return Colors.white;
    }

    final option = _currentOptions[index];
    final correct = option == _currentQuestion.answer;

    if (correct) {
      return AppTheme.successColor.withValues(alpha: 0.10);
    }

    if (_selectedOption == index) {
      return AppTheme.errorColor.withValues(alpha: 0.10);
    }

    return Colors.white;
  }

  Color _optionBorderColor(int index) {
    if (!_answered) {
      return const Color(0xFFE2E8F0);
    }

    final option = _currentOptions[index];
    final correct = option == _currentQuestion.answer;

    if (correct) {
      return AppTheme.successColor;
    }

    if (_selectedOption == index) {
      return AppTheme.errorColor;
    }

    return const Color(0xFFE2E8F0);
  }

  IconData? _optionIcon(int index) {
    if (!_answered) {
      return null;
    }

    final option = _currentOptions[index];
    final correct = option == _currentQuestion.answer;

    if (correct) {
      return Icons.check_circle_rounded;
    }

    if (_selectedOption == index) {
      return Icons.cancel_rounded;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return _buildEmptyState(context);
    }

    final question = _currentQuestion;

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Mode')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              _buildProgress(context),

              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          question.category,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        question.question,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimaryColor,
                              height: 1.3,
                            ),
                      ),

                      const SizedBox(height: 26),

                      ...List.generate(_currentOptions.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildOption(context, index),
                        );
                      }),

                      if (_answered) _buildAnswerFeedback(context),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _answered && !_isSavingResult
                      ? _nextQuestion
                      : null,
                  icon: _isSavingResult
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          _currentIndex == _questions.length - 1
                              ? Icons.check_rounded
                              : Icons.arrow_forward_rounded,
                        ),
                  label: Text(
                    _isSavingResult
                        ? 'Saving Result...'
                        : _currentIndex == _questions.length - 1
                        ? 'Finish Quiz'
                        : 'Next Question',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgress(BuildContext context) {
    final progress = (_currentIndex + 1) / _questions.length;

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Question ${_currentIndex + 1}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              '${_currentIndex + 1} / ${_questions.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOption(BuildContext context, int index) {
    final icon = _optionIcon(index);

    return InkWell(
      onTap: () {
        _selectOption(index);
      },
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: _optionColor(index),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _optionBorderColor(index), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _answered
                    ? Colors.transparent
                    : AppTheme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: icon != null
                  ? Icon(icon, color: _optionBorderColor(index))
                  : Text(
                      String.fromCharCode(65 + index),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryColor,
                      ),
                    ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                _currentOptions[index],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerFeedback(BuildContext context) {
    final selected = _selectedOption == null
        ? ''
        : _currentOptions[_selectedOption!];

    final isCorrect = selected == _currentQuestion.answer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppTheme.successColor.withValues(alpha: 0.08)
            : AppTheme.errorColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              isCorrect
                  ? 'Correct answer!'
                  : 'Incorrect. The correct answer is: ${_currentQuestion.answer}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Mode')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.quiz_outlined,
                size: 70,
                color: AppTheme.primaryColor,
              ),

              const SizedBox(height: 20),

              Text(
                'No flashcards available',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 8),

              Text(
                'Create flashcards before starting a quiz.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
