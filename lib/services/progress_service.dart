import 'package:hive_flutter/hive_flutter.dart';

class ProgressService {
  static const String _boxName = 'progress_box';
  static const String _studiedKey = 'studied_cards';

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
        'ProgressService is not initialized. '
        'Call ProgressService.init() before using progress data.',
      );
    }

    return Hive.box(_boxName);
  }

  static Set<String> getStudiedCardIds() {
    if (!isInitialized) {
      return <String>{};
    }

    final dynamic data = _box.get(_studiedKey, defaultValue: <String>[]);

    if (data is! List) {
      return <String>{};
    }

    return data.map((item) => item.toString()).toSet();
  }

  static bool isStudied(String cardId) {
    return getStudiedCardIds().contains(cardId);
  }

  static Future<void> markAsStudied(String cardId) async {
    await init();

    final studiedCards = getStudiedCardIds();

    if (studiedCards.contains(cardId)) {
      return;
    }

    studiedCards.add(cardId);

    await _box.put(_studiedKey, studiedCards.toList());
  }

  static Future<void> markAsUnstudied(String cardId) async {
    await init();

    final studiedCards = getStudiedCardIds();

    if (!studiedCards.contains(cardId)) {
      return;
    }

    studiedCards.remove(cardId);

    await _box.put(_studiedKey, studiedCards.toList());
  }

  static int getStudiedCount() {
    if (!isInitialized) {
      return 0;
    }

    return getStudiedCardIds().length;
  }

  static Future<void> clearProgress() async {
    await init();

    await _box.delete(_studiedKey);
  }
}
