enum MetricType { weightReps, weightTime, speedTime }

class Exercise {
  final String name;
  final String category;
  final MetricType metricType;

  Exercise({
    required this.name,
    required this.category,
    required this.metricType,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'metricType': metricType.toString(),
  };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      category: json['category'],
      metricType: MetricType.values.firstWhere(
            (e) => e.toString() == json['metricType'],
        orElse: () => MetricType.weightReps,
      ),
    );
  }
}
