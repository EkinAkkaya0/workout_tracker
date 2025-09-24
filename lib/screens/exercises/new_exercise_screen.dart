import 'package:flutter/material.dart';
import '../../data/exercise_store.dart';

class NewExerciseScreen extends StatefulWidget {
  const NewExerciseScreen({super.key});

  @override
  State<NewExerciseScreen> createState() => _NewExerciseScreenState();
}

class _NewExerciseScreenState extends State<NewExerciseScreen> {
  final _controller = TextEditingController();
  bool _saving = false;

  Future<void> _save() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    await ExerciseStore.addCustomExercise(name);
    if (!mounted) return;
    Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text("Yeni Egzersiz"),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saving ? null : _save),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: "Egzersiz adı",
            hintText: "Örn. Incline Dumbbell Press",
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _save(),
        ),
      ),
    );
  }
}
