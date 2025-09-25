import 'package:flutter/material.dart';
import '../../data/exercise_store.dart';
import '../../models/exercise_model.dart';

class NewExerciseScreen extends StatefulWidget {
  const NewExerciseScreen({super.key});

  @override
  State<NewExerciseScreen> createState() => _NewExerciseScreenState();
}

class _NewExerciseScreenState extends State<NewExerciseScreen> {
  final _nameCtrl = TextEditingController();
  String _selectedCategory = "Göğüs";

  final List<String> categories = [
    "Karın", "Sırt", "Biceps", "Triceps", "Göğüs", "Bacak", "Omuz", "Cardio"
  ];

  void _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;

    // kategoriye göre metricType seç
    MetricType type;
    switch (_selectedCategory) {
      case "Karın":
        type = MetricType.weightTime;
        break;
      case "Cardio":
        type = MetricType.speedTime;
        break;
      default:
        type = MetricType.weightReps;
    }

    final ex = Exercise(
      name: _nameCtrl.text.trim(),
      category: _selectedCategory,
      metricType: type,
    );

    await ExerciseStore.addExercise(ex);
    Navigator.pop(context, ex.name);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yeni Egzersiz")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Egzersiz adı"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v ?? "Göğüs"),
              decoration: const InputDecoration(labelText: "Kategori"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text("Ekle")),
          ],
        ),
      ),
    );
  }
}
