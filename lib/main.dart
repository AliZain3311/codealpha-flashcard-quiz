import 'package:flutter/material.dart';

import 'app/app.dart';
import 'services/progress_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();

  await ProgressService.init();

  await StorageService.seedSampleData();

  runApp(const FlashcardApp());
}
