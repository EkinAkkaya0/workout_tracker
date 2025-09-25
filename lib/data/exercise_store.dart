import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise_model.dart';
import 'dart:convert';

class ExerciseStore {
  static const _key = "exercises";

  static Future<List<Exercise>> getAllExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    if (list.isEmpty) {
      return _seedDefaults(prefs);
    }

    try {
      return list.map((s) => Exercise.fromJson(json.decode(s))).toList();
    } catch (_) {
      // Eski format bozuk → resetle
      return _seedDefaults(prefs);
    }
  }

  static Future<List<Exercise>> _seedDefaults(SharedPreferences prefs) async {
    final defaults = [
      Exercise(name: "Bench Press", category: "Göğüs", metricType: MetricType.weightReps),
      Exercise(name: "Squat", category: "Bacak", metricType: MetricType.weightReps),
      Exercise(name: "Plank", category: "Karın", metricType: MetricType.weightTime),
      Exercise(name: "Running", category: "Cardio", metricType: MetricType.speedTime),
      Exercise(name: "Cycling", category: "Cardio", metricType: MetricType.speedTime),
    ];
    final encoded = defaults.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
    return defaults;
  }



  static Future<void> addExercise(Exercise ex) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.add(json.encode(ex.toJson()));
    await prefs.setStringList(_key, list);
  }
}
