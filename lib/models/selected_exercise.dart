class SelectedExercise {
  final String name;
  final double weight; // kg
  final int reps;

  SelectedExercise({required this.name, required this.weight, required this.reps});

  Map<String, dynamic> toJson() => {
    'name': name,
    'weight': weight,
    'reps': reps,
  };

  factory SelectedExercise.fromJson(Map<String, dynamic> m) => SelectedExercise(
    name: m['name'] as String,
    weight: (m['weight'] as num).toDouble(),
    reps: m['reps'] as int,
  );

  @override
  String toString() => '$name — ${weight}kg x $reps';
}
