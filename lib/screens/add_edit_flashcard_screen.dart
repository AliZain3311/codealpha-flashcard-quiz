import 'package:flutter/material.dart';

import '../models/flashcard_model.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class AddEditFlashcardScreen extends StatefulWidget {
  final FlashcardModel? flashcard;

  const AddEditFlashcardScreen({super.key, this.flashcard});

  bool get isEditing => flashcard != null;

  @override
  State<AddEditFlashcardScreen> createState() => _AddEditFlashcardScreenState();
}

class _AddEditFlashcardScreenState extends State<AddEditFlashcardScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _questionController;
  late final TextEditingController _answerController;
  late final TextEditingController _categoryController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _questionController = TextEditingController(
      text: widget.flashcard?.question ?? '',
    );

    _answerController = TextEditingController(
      text: widget.flashcard?.answer ?? '',
    );

    _categoryController = TextEditingController(
      text: widget.flashcard?.category ?? '',
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveFlashcard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final now = DateTime.now();

    final flashcard =
        widget.flashcard?.copyWith(
          question: _questionController.text.trim(),
          answer: _answerController.text.trim(),
          category: _categoryController.text.trim(),
        ) ??
        FlashcardModel(
          id: now.microsecondsSinceEpoch.toString(),
          question: _questionController.text.trim(),
          answer: _answerController.text.trim(),
          category: _categoryController.text.trim(),
          createdAt: now,
        );

    if (widget.isEditing) {
      await StorageService.updateFlashcard(flashcard);
    } else {
      await StorageService.addFlashcard(flashcard);
    }

    if (!mounted) {
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.isEditing;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Flashcard' : 'Create Flashcard'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              _buildHeader(context, isEditing),

              const SizedBox(height: 28),

              Text(
                'Question',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimaryColor,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _questionController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Enter your question...',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 54),
                    child: Icon(Icons.help_outline_rounded),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a question.';
                  }

                  if (value.trim().length < 3) {
                    return 'Question is too short.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              Text(
                'Answer',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimaryColor,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _answerController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter the answer...',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 72),
                    child: Icon(Icons.lightbulb_outline_rounded),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an answer.';
                  }

                  if (value.trim().length < 2) {
                    return 'Answer is too short.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              Text(
                'Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimaryColor,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _categoryController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Flutter, Dart, Programming',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a category.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveFlashcard,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          isEditing ? Icons.save_rounded : Icons.add_rounded,
                        ),
                  label: Text(
                    _isSaving
                        ? 'Saving...'
                        : isEditing
                        ? 'Save Changes'
                        : 'Create Flashcard',
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Your flashcard will be stored locally on this device.',
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

  Widget _buildHeader(BuildContext context, bool isEditing) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isEditing ? Icons.edit_rounded : Icons.style_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Update your card' : 'Create a new card',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEditing
                      ? 'Make changes and save your progress.'
                      : 'Add a question, answer and category.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
