import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseStore {
  static const _customKey = 'custom_exercises_v1';

  static const List<String> _baseExercises = [
    "Bench Press",
    "Squat",
    "Deadlift",
    "Overhead Press",
    "Barbell Row",
    "Pull-up",
    "Dip",
    "Biceps Curl",
    "Triceps Pushdown",
    "Leg Press",
  ];

  static Future<List<String>> getCustomExercises() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_customKey);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).cast<String>();
    return list;
  }

  static Future<void> addCustomExercise(String name) async {
    final sp = await SharedPreferences.getInstance();
    final cur = await getCustomExercises();
    if (!cur.contains(name)) {
      cur.add(name);
      await sp.setString(_customKey, jsonEncode(cur));
    }
  }

  static Future<List<String>> getAllExercises() async {
    final custom = await getCustomExercises();
    return [..._baseExercises, ...custom];
  }
}
