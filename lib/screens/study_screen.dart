import 'package:flutter/material.dart';

import '../models/flashcard_model.dart';
import '../services/progress_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  late List<FlashcardModel> _flashcards;

  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _isCurrentCardStudied = false;

  @override
  void initState() {
    super.initState();

    _flashcards = StorageService.getFlashcards();

    _updateStudiedStatus();
  }

  FlashcardModel? get _currentCard {
    if (_flashcards.isEmpty) {
      return null;
    }

    return _flashcards[_currentIndex];
  }

  double get _progress {
    if (_flashcards.isEmpty) {
      return 0;
    }

    return (_currentIndex + 1) / _flashcards.length;
  }

  void _updateStudiedStatus() {
    if (_flashcards.isEmpty) {
      return;
    }

    _isCurrentCardStudied = ProgressService.isStudied(
      _flashcards[_currentIndex].id,
    );
  }

  void _showAnswerCard() {
    setState(() {
      _showAnswer = true;
    });
  }

  Future<void> _toggleStudied() async {
    final card = _currentCard;

    if (card == null) {
      return;
    }

    if (_isCurrentCardStudied) {
      await ProgressService.markAsUnstudied(card.id);
    } else {
      await ProgressService.markAsStudied(card.id);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isCurrentCardStudied = !_isCurrentCardStudied;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCurrentCardStudied
              ? 'Marked as studied.'
              : 'Removed from studied cards.',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  void _nextCard() {
    if (_currentIndex >= _flashcards.length - 1) {
      return;
    }

    setState(() {
      _currentIndex++;
      _showAnswer = false;
      _updateStudiedStatus();
    });
  }

  void _previousCard() {
    if (_currentIndex <= 0) {
      return;
    }

    setState(() {
      _currentIndex--;
      _showAnswer = false;
      _updateStudiedStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_flashcards.isEmpty) {
      return _buildEmptyState(context);
    }

    final card = _currentCard!;

    return Scaffold(
      appBar: AppBar(title: const Text('Study Mode')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              _buildTopProgress(context),

              const SizedBox(height: 20),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.96,
                          end: 1,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _buildFlashcard(context, card, key: ValueKey(card.id)),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showAnswer ? _toggleStudied : null,
                  icon: Icon(
                    _isCurrentCardStudied
                        ? Icons.check_circle_rounded
                        : Icons.check_circle_outline,
                  ),
                  label: Text(
                    _isCurrentCardStudied ? 'Studied' : 'Mark as Studied',
                  ),
                ),
              ),

              const SizedBox(height: 12),

              _buildNavigation(context),

              const SizedBox(height: 10),

              Text(
                'Mark each card as studied to track your progress.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopProgress(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Card ${_currentIndex + 1}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const Spacer(),
            Text(
              '${_currentIndex + 1} / ${_flashcards.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _progress,
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

  Widget _buildFlashcard(
    BuildContext context,
    FlashcardModel card, {
    required Key key,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    card.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  _showAnswer
                      ? Icons.visibility_rounded
                      : Icons.help_outline_rounded,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Text(
              _showAnswer ? 'Answer' : 'Question',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.78),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      _showAnswer ? card.answer : card.question,
                      key: ValueKey(_showAnswer),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (!_showAnswer)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showAnswerCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryColor,
                    minimumSize: const Size(double.infinity, 54),
                  ),
                  icon: const Icon(Icons.visibility_rounded),
                  label: const Text('Show Answer'),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Answer revealed',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    final isFirstCard = _currentIndex == 0;
    final isLastCard = _currentIndex == _flashcards.length - 1;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isFirstCard ? null : _previousCard,
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Previous'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isLastCard ? null : _nextCard,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Next'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Mode')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.style_outlined,
                  size: 44,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'No flashcards available',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Create some flashcards first, then come back to study.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
