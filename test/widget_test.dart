import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:codealpha_flashcard_quiz/app/app.dart';
import 'package:codealpha_flashcard_quiz/services/progress_service.dart';
import 'package:codealpha_flashcard_quiz/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory testDirectory;

  setUp(() async {
    testDirectory = await Directory.systemTemp.createTemp('flashlearn_test_');

    await StorageService.init(testPath: testDirectory.path);

    await ProgressService.init();

    await StorageService.clearAllFlashcards();
    await ProgressService.clearProgress();

    await StorageService.seedSampleData();
  });

  tearDown(() async {
    await StorageService.clearAllFlashcards();
    await ProgressService.clearProgress();

    await Hive.close();

    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
  });

  testWidgets('FlashLearn app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const FlashcardApp());

    await tester.pumpAndSettle();

    expect(find.text('FlashLearn'), findsOneWidget);

    expect(find.text('Welcome back!'), findsOneWidget);

    expect(find.text('Start Studying'), findsOneWidget);

    expect(find.text('Start Quiz'), findsOneWidget);

    expect(find.text('Manage Flashcards'), findsOneWidget);

    expect(find.text('Add Flashcard'), findsOneWidget);

    expect(find.text('6'), findsOneWidget);

    expect(find.text('0%'), findsNWidgets(3));
  });
}
