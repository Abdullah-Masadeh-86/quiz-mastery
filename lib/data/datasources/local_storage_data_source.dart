import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_result.dart';

class LocalStorageDataSource {
  static const String _highScoresKey = 'high_scores';
  static const String _soundEnabledKey = 'sound_enabled';

  Future<void> saveHighScore(QuizResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getHighScores();

    scores.add(result);
    scores.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    final topScores = scores.take(10).toList();

    final jsonList = topScores.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_highScoresKey, jsonList);
  }

  Future<List<QuizResult>> getHighScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_highScoresKey);

      if (jsonList == null) return [];

      final results = <QuizResult>[];
      for (final json in jsonList) {
        try {
          results.add(QuizResult.fromJson(jsonDecode(json)));
        } catch (_) {}
      }
      return results;
    } catch (_) {
      return [];
    }
  }

  Future<void> clearHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_highScoresKey);
  }

  Future<bool> isSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }
}
