import 'package:hive_flutter/hive_flutter.dart';

import '../data/sample_flashcards.dart';
import '../models/flashcard_model.dart';

class StorageService {
  static const String _boxName = 'flashcards_box';

  static Future<void> init({String? testPath}) async {
    if (testPath != null) {
      Hive.init(testPath);
    } else {
      await Hive.initFlutter();
    }

    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  static Box get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw StateError(
        'Flashcard storage has not been initialized. '
        'Call StorageService.init() first.',
      );
    }

    return Hive.box(_boxName);
  }

  static List<FlashcardModel> getFlashcards() {
    final flashcards = _box.values.map((item) {
      return FlashcardModel.fromMap(Map<String, dynamic>.from(item as Map));
    }).toList();

    return flashcards;
  }

  static Future<void> addFlashcard(FlashcardModel flashcard) async {
    await _box.put(flashcard.id, flashcard.toMap());
  }

  static Future<void> updateFlashcard(FlashcardModel flashcard) async {
    await _box.put(flashcard.id, flashcard.toMap());
  }

  static Future<void> deleteFlashcard(String id) async {
    await _box.delete(id);
  }

  static Future<void> clearAllFlashcards() async {
    await _box.clear();
  }

  static Future<void> seedSampleData() async {
    if (_box.isEmpty) {
      for (final flashcard in SampleFlashcards.items) {
        await addFlashcard(flashcard);
      }
    }
  }
}
