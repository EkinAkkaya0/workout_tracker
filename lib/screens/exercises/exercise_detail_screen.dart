import 'package:flutter/material.dart';
import '../../models/selected_exercise.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String exerciseName;
  const ExerciseDetailScreen({super.key, required this.exerciseName});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  double _weight = 20.0;
  int _reps = 10;

  void _incWeight() => setState(() => _weight = double.parse((_weight + 2.5).toStringAsFixed(1)));
  void _decWeight() => setState(() => _weight = (_weight - 2.5).clamp(0, 999).toDouble());

  void _incReps() => setState(() => _reps = (_reps + 1).clamp(0, 999));
  void _decReps() => setState(() => _reps = (_reps - 1).clamp(0, 999));

  void _save() {
    final result = SelectedExercise(name: widget.exerciseName, weight: _weight, reps: _reps);
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "Egzersizlere dön",
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.exerciseName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Ağırlık
            Row(
              children: [
                const Expanded(child: Text("Ağırlık (kg)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                IconButton(onPressed: _decWeight, icon: const Icon(Icons.remove_circle_outline)),
                Text("${_weight.toStringAsFixed(1)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: _incWeight, icon: const Icon(Icons.add_circle_outline)),
              ],
            ),
            const SizedBox(height: 12),
            // Tekrar
            Row(
              children: [
                const Expanded(child: Text("Tekrar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                IconButton(onPressed: _decReps, icon: const Icon(Icons.remove_circle_outline)),
                Text("$_reps", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: _incReps, icon: const Icon(Icons.add_circle_outline)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text("Kaydet"),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
