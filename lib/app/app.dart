import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../theme/app_theme.dart';

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashLearn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
