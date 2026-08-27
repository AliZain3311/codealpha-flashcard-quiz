import '../models/flashcard_model.dart';

class SampleFlashcards {
  static List<FlashcardModel> get items {
    final now = DateTime.now();

    return [
      FlashcardModel(
        id: 'flutter-001',
        question: 'What is Flutter?',
        answer:
            'Flutter is an open-source UI framework developed by Google for building cross-platform applications.',
        category: 'Flutter',
        createdAt: now,
      ),
      FlashcardModel(
        id: 'dart-001',
        question: 'What programming language does Flutter use?',
        answer: 'Flutter uses the Dart programming language.',
        category: 'Dart',
        createdAt: now,
      ),
      FlashcardModel(
        id: 'firebase-001',
        question: 'What is Firebase?',
        answer:
            'Firebase is a Google platform that provides backend services such as authentication, databases, storage, and analytics.',
        category: 'Firebase',
        createdAt: now,
      ),
      FlashcardModel(
        id: 'api-001',
        question: 'What does API stand for?',
        answer: 'API stands for Application Programming Interface.',
        category: 'Programming',
        createdAt: now,
      ),
      FlashcardModel(
        id: 'git-001',
        question: 'What is Git?',
        answer:
            'Git is a distributed version control system used to track changes in source code.',
        category: 'Tools',
        createdAt: now,
      ),
      FlashcardModel(
        id: 'github-001',
        question: 'What is GitHub used for?',
        answer:
            'GitHub is a platform for hosting Git repositories and collaborating on software projects.',
        category: 'Tools',
        createdAt: now,
      ),
    ];
  }
}
