import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codealpha_flashcard_quiz/app/app.dart';
import 'package:codealpha_flashcard_quiz/screens/splash_screen.dart';

void main() {
  testWidgets('FlashLearn app starts with splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FlashcardApp());

    // The application should start with the FlashLearn splash screen.
    expect(find.byType(SplashScreen), findsOneWidget);

    // Dispose the test widget without waiting for startup services.
    await tester.pumpWidget(const SizedBox());
  });
}
