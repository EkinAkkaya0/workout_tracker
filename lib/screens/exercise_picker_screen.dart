import 'package:flutter/material.dart';
import '../data/exercise_store.dart';
import '../models/exercise_with_sets.dart';
import 'exercises/new_exercise_screen.dart';
import 'exercises/exercise_detail_screen.dart';

class ExercisePickerScreen extends StatefulWidget {
  const ExercisePickerScreen({super.key});

  @override
  State<ExercisePickerScreen> createState() => _ExercisePickerScreenState();
}

class _ExercisePickerScreenState extends State<ExercisePickerScreen> {
  int _tabIndex = 0; // 0 = Exercises, 1 = Templates
  List<String> _allExercises = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await ExerciseStore.getAllExercises();
    setState(() => _allExercises = list);
  }

  Future<void> _addNewExercise() async {
    final addedName = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const NewExerciseScreen()),
    );
    if (addedName != null) {
      await _load();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Eklendi: $addedName")),
      );
    }
  }

  Future<void> _openDetail(String name) async {
    final res = await Navigator.push<ExerciseWithSets>(
      context,
      MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exerciseName: name)),
    );
    if (res != null) {
      // Tek egzersiz ile Home'a dön
      Navigator.pop(context, res);
    }
  }

  Widget _buildSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SegmentedButton<int>(
        segments: const [
          ButtonSegment(value: 0, icon: Icon(Icons.fitness_center), label: Text("Exercises")),
          ButtonSegment(value: 1, icon: Icon(Icons.view_module), label: Text("Templates")),
        ],
        selected: <int>{_tabIndex},
        onSelectionChanged: (s) => setState(() => _tabIndex = s.first),
      ),
    );
  }

  Widget _buildExercises() {
    return ListView.separated(
      itemCount: _allExercises.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final name = _allExercises[i];
        return ListTile(
          title: Text(name),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openDetail(name),
        );
      },
    );
  }

  Widget _buildTemplates() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.view_module, size: 56, color: Colors.grey),
          SizedBox(height: 8),
          Text("Henüz şablon yok.\nYakında burada olacak.", textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text("Egzersiz Seç"),
        actions: [
          IconButton(
            tooltip: "Yeni egzersiz ekle",
            icon: const Icon(Icons.add),
            onPressed: _addNewExercise,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSwitch(),
          const Divider(height: 1),
          Expanded(child: _tabIndex == 0 ? _buildExercises() : _buildTemplates()),
        ],
      ),
    );
  }
}
