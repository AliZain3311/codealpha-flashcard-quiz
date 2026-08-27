// TODO Implement this library.
import 'package:hive_flutter/hive_flutter.dart';

class QuizHistoryService {
  static const String _boxName = 'quiz_history_box';
  static const String _historyKey = 'quiz_history';

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  static bool get isInitialized {
    return Hive.isBoxOpen(_boxName);
  }

  static Box get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw StateError(
        'QuizHistoryService is not initialized. '
        'Call QuizHistoryService.init() first.',
      );
    }

    return Hive.box(_boxName);
  }

  static List<Map<String, dynamic>> getHistory() {
    if (!isInitialized) {
      return <Map<String, dynamic>>[];
    }

    final dynamic data = _box.get(_historyKey, defaultValue: <dynamic>[]);

    if (data is! List) {
      return <Map<String, dynamic>>[];
    }

    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  static Future<void> saveQuizResult({
    required int score,
    required int totalQuestions,
  }) async {
    await init();

    final history = getHistory();

    history.add({
      'score': score,
      'totalQuestions': totalQuestions,
      'percentage': totalQuestions == 0
          ? 0
          : ((score / totalQuestions) * 100).round(),
      'date': DateTime.now().toIso8601String(),
    });

    await _box.put(_historyKey, history);
  }

  static int getTotalQuizzes() {
    return getHistory().length;
  }

  static double getAverageScore() {
    final history = getHistory();

    if (history.isEmpty) {
      return 0;
    }

    final totalPercentage = history.fold<double>(
      0,
      (sum, quiz) => sum + ((quiz['percentage'] as num?)?.toDouble() ?? 0),
    );

    return totalPercentage / history.length;
  }

  static double getBestScore() {
    final history = getHistory();

    if (history.isEmpty) {
      return 0;
    }

    return history.fold<double>(0, (best, quiz) {
      final percentage = (quiz['percentage'] as num?)?.toDouble() ?? 0;

      return percentage > best ? percentage : best;
    });
  }

  static Future<void> clearHistory() async {
    await init();

    await _box.delete(_historyKey);
  }
}
