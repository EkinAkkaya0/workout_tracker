import 'package:flutter/material.dart';
import '../../models/exercise_with_sets.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String exerciseName;
  const ExerciseDetailScreen({super.key, required this.exerciseName});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  double _weight = 20.0;
  int _reps = 10;

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  final List<Map<String, dynamic>> _sets = [];

  @override
  void initState() {
    super.initState();
    _weightController.text = _weight.toStringAsFixed(1);
    _repsController.text = _reps.toString();
  }

  void _updateWeight(double delta) {
    setState(() {
      _weight = (_weight + delta).clamp(0, 999).toDouble();
      _weightController.text = _weight.toStringAsFixed(1);
    });
  }

  void _updateReps(int delta) {
    setState(() {
      _reps = (_reps + delta).clamp(0, 999);
      _repsController.text = _reps.toString();
    });
  }

  void _addSet() {
    setState(() {
      _sets.add({
        'setNo': _sets.length + 1,
        'weight': _weight,
        'reps': _reps,
      });
    });
  }

  void _save() {
    if (_sets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("En az bir set ekleyin")),
      );
      return;
    }
    final result = ExerciseWithSets(
      name: widget.exerciseName,
      sets: List<Map<String, dynamic>>.from(_sets),
    );
    // Detay -> Picker'a dön (tek egzersiz)
    Navigator.pop(context, result);
  }

  Widget _circleButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 56,
      height: 56,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(const CircleBorder()),
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onDec,
    required VoidCallback onInc,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleButton(Icons.remove, onDec),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (val) {
                    if (label.contains("Ağırlık")) {
                      final parsed = double.tryParse(val);
                      if (parsed != null) _weight = parsed;
                    } else {
                      final parsed = int.tryParse(val);
                      if (parsed != null) _reps = parsed;
                    }
                  },
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 16),
              _circleButton(Icons.add, onInc),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSetRow(Map<String, dynamic> set) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Text("Set ${set['setNo']}", style: const TextStyle(fontWeight: FontWeight.w600)),
            Expanded(
              child: Center(
                child: Text("${set['weight']} kg × ${set['reps']} tekrar", style: const TextStyle(fontSize: 16)),
              ),
            ),
            const Icon(Icons.note_add_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
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
            _buildLabeledField(
              label: "Ağırlık (kg)",
              controller: _weightController,
              onDec: () => _updateWeight(-2.5),
              onInc: () => _updateWeight(2.5),
            ),
            _buildLabeledField(
              label: "Tekrar",
              controller: _repsController,
              onDec: () => _updateReps(-1),
              onInc: () => _updateReps(1),
            ),
            ElevatedButton.icon(
              onPressed: _addSet,
              icon: const Icon(Icons.add),
              label: const Text("Set Ekle"),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _sets.isEmpty
                  ? const Center(child: Text("Henüz set yok"))
                  : ListView(children: _sets.map(_buildSetRow).toList()),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text("Kaydet"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
