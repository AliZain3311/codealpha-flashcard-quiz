import 'package:flutter/material.dart';

import '../models/flashcard_model.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'add_edit_flashcard_screen.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  List<FlashcardModel> _flashcards = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  void _loadFlashcards() {
    setState(() {
      _flashcards = StorageService.getFlashcards();
    });
  }

  List<FlashcardModel> get _filteredFlashcards {
    return _flashcards.where((flashcard) {
      final matchesSearch =
          flashcard.question.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          flashcard.answer.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'All' || flashcard.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> get _categories {
    final categories = _flashcards
        .map((flashcard) => flashcard.category)
        .toSet()
        .toList();

    categories.sort();

    return ['All', ...categories];
  }

  Future<void> _addFlashcard() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditFlashcardScreen()),
    );

    if (result == true) {
      _loadFlashcards();
    }
  }

  Future<void> _editFlashcard(FlashcardModel flashcard) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditFlashcardScreen(flashcard: flashcard),
      ),
    );

    if (result == true) {
      _loadFlashcards();
    }
  }

  Future<void> _deleteFlashcard(FlashcardModel flashcard) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Flashcard?'),
          content: const Text(
            'This flashcard will be permanently removed from your collection.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await StorageService.deleteFlashcard(flashcard.id);

    if (!mounted) {
      return;
    }

    _loadFlashcards();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Flashcard deleted successfully.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFlashcards = _filteredFlashcards;

    return Scaffold(
      appBar: AppBar(title: const Text('My Flashcards')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addFlashcard,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Card'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search flashcards...',
                  prefixIcon: Icon(Icons.search_rounded),
                  suffixIcon: Icon(Icons.tune_rounded),
                ),
              ),
            ),

            SizedBox(
              height: 54,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  Text(
                    '${filteredFlashcards.length} flashcards',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const Spacer(),
                  if (_searchQuery.isNotEmpty || _selectedCategory != 'All')
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _selectedCategory = 'All';
                        });
                      },
                      child: const Text('Clear filters'),
                    ),
                ],
              ),
            ),

            Expanded(
              child: filteredFlashcards.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: filteredFlashcards.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final flashcard = filteredFlashcards[index];

                        return _FlashcardListItem(
                          flashcard: flashcard,
                          onEdit: () {
                            _editFlashcard(flashcard);
                          },
                          onDelete: () {
                            _deleteFlashcard(flashcard);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasFilters = _searchQuery.isNotEmpty || _selectedCategory != 'All';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.style_outlined,
                size: 38,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasFilters ? 'No flashcards found' : 'No flashcards yet',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try changing your search or category filter.'
                  : 'Create your first flashcard and start learning.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            if (!hasFilters) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _addFlashcard,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create Flashcard'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FlashcardListItem extends StatelessWidget {
  final FlashcardModel flashcard;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FlashcardListItem({
    required this.flashcard,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.style_rounded,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      flashcard.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    flashcard.question,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    flashcard.answer,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(
                        Icons.delete_outline,
                        color: AppTheme.errorColor,
                      ),
                      title: Text('Delete'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
