import 'dart:async';

import 'package:flutter/material.dart';

import '../services/progress_service.dart';
import '../services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    // Start app initialization and splash timer at the same time.
    final initialization = _initializeServices();
    final splashDelay = Future<void>.delayed(const Duration(seconds: 3));

    // Wait until both initialization and the 3-second splash duration
    // are complete.
    await Future.wait<void>([initialization, splashDelay]);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> _initializeServices() async {
    try {
      await StorageService.init();
      await ProgressService.init();
      await StorageService.seedSampleData();
    } catch (error, stackTrace) {
      debugPrint('FlashLearn startup error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/flashlearn_splash.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
