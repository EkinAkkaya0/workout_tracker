import 'exercise_model.dart';

class ExerciseWithSets {
  final String name;
  final MetricType metricType; // 🔑 kalıcı hale getirdik
  final List<Map<String, dynamic>> sets;

  ExerciseWithSets({
    required this.name,
    required this.metricType,
    required this.sets,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'metricType': metricType.toString(),
      'sets': sets,
    };
  }

  factory ExerciseWithSets.fromJson(Map<String, dynamic> json) {
    return ExerciseWithSets(
      name: json['name'],
      metricType: _metricTypeFromString(json['metricType']),
      sets: List<Map<String, dynamic>>.from(json['sets']),
    );
  }

  static MetricType _metricTypeFromString(String str) {
    switch (str) {
      case 'MetricType.weightReps':
        return MetricType.weightReps;
      case 'MetricType.weightTime':
        return MetricType.weightTime;
      case 'MetricType.speedTime':
        return MetricType.speedTime;
      default:
        return MetricType.weightReps;
    }
  }
}
