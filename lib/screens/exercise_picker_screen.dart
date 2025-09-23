import 'package:flutter/material.dart';
import '../data/exercise_store.dart';
import '../models/selected_exercise.dart';
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
  final List<SelectedExercise> _selected = [];

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
      await _load(); // listeyi tazele
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Eklendi: $addedName")),
      );
    }
  }

  Future<void> _openDetail(String name) async {
    final res = await Navigator.push<SelectedExercise>(
      context,
      MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exerciseName: name)),
    );
    if (res != null) {
      setState(() {
        _selected.add(res);
      });
    }
  }

  void _finish() {
    Navigator.pop(context, _selected); // Home'a seçilenleri geri dön
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
    return Column(
      children: [
        if (_selected.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(child: Text("${_selected.length} egzersiz seçildi")),
                TextButton.icon(onPressed: _finish, icon: const Icon(Icons.check), label: const Text("Bitir")),
              ],
            ),
          ),
        Expanded(
          child: ListView.separated(
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
          ),
        ),
      ],
    );
  }

  Widget _buildTemplates() {
    // Şimdilik placeholder — ileride şablonları burada listeleyeceğiz
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
    final canFinish = _selected.isNotEmpty;

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
          IconButton(
            tooltip: "Seçimi bitir",
            icon: const Icon(Icons.check),
            onPressed: canFinish ? _finish : null,
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
