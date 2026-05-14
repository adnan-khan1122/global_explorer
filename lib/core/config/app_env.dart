import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  AppEnv._();

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: 'assets/dotenv.defaults');
    } catch (_) {
      // Missing asset in unusual builds; keys stay empty.
    }
  }

  static String get newsApiKey => dotenv.maybeGet('NEWS_API_KEY') ?? '';
  static String get pexelsApiKey => dotenv.maybeGet('PEXELS_API_KEY') ?? '';
}
