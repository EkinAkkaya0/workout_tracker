import 'package:flutter/material.dart';
import '../../models/exercise_model.dart';
import '../../models/exercise_with_sets.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  final ExerciseWithSets? initialData;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    this.initialData,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  double _firstValue = 0; // Ağırlık / Hız
  int _secondValue = 0;   // Tekrar / Süre

  final TextEditingController _firstCtrl = TextEditingController();
  final TextEditingController _secondCtrl = TextEditingController();

  final List<Map<String, dynamic>> _sets = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _firstCtrl.text = _firstValue.toStringAsFixed(1);
    _secondCtrl.text = _secondValue.toString();

    if (widget.initialData != null) {
      _sets.addAll(widget.initialData!.sets.map((s) {
        return {
          'setNo': s['setNo'],
          'first': s['first'],
          'second': s['second'],
          'note': s.containsKey('note') ? s['note'] : "",
        };
      }));
    }
  }

  void _updateFirst(double delta) {
    setState(() {
      _firstValue = (_firstValue + delta).clamp(0, 999).toDouble();
      _firstCtrl.text = _firstValue.toStringAsFixed(1);
    });
  }

  void _updateSecond(int delta) {
    setState(() {
      _secondValue = (_secondValue + delta).clamp(0, 999);
      _secondCtrl.text = _secondValue.toString();
    });
  }

  void _addSet() {
    setState(() {
      _sets.add({
        'setNo': _sets.length + 1,
        'first': _firstValue,
        'second': _secondValue,
        'note': "",
      });
    });
  }

  void _updateSet() {
    if (_editingIndex == null) return;
    setState(() {
      _sets[_editingIndex!] = {
        'setNo': _editingIndex! + 1,
        'first': _firstValue,
        'second': _secondValue,
        'note': _sets[_editingIndex!]['note'],
      };
      _editingIndex = null;
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
      name: widget.exercise.name,
      metricType: widget.exercise.metricType, // 🔑 eklendi
      sets: List<Map<String, dynamic>>.from(_sets),
    );
    Navigator.pop(context, result);
  }


  void _editNoteDialog(int index) {
    final controller = TextEditingController(text: _sets[index]['note'] ?? "");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Set ${_sets[index]['setNo']} için not"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Notunuzu yazın...",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _sets[index]['note'] = controller.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text("Kaydet"),
            ),
          ],
        );
      },
    );
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
          backgroundColor:
          WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(const CircleBorder()),
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
          Text(label,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null) {
                      if (label.contains("Ağırlık") || label.contains("Hız")) {
                        _firstValue = parsed;
                      } else {
                        _secondValue = parsed.toInt();
                      }
                    }
                  },
                  decoration:
                  const InputDecoration(border: OutlineInputBorder()),
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

  Widget _buildInputs() {
    switch (widget.exercise.metricType) {
      case MetricType.weightReps:
        return Column(
          children: [
            _buildLabeledField(
              label: "Ağırlık (kg)",
              controller: _firstCtrl,
              onDec: () => _updateFirst(-2.5),
              onInc: () => _updateFirst(2.5),
            ),
            _buildLabeledField(
              label: "Tekrar",
              controller: _secondCtrl,
              onDec: () => _updateSecond(-1),
              onInc: () => _updateSecond(1),
            ),
          ],
        );
      case MetricType.weightTime:
        return Column(
          children: [
            _buildLabeledField(
              label: "Ağırlık (kg)",
              controller: _firstCtrl,
              onDec: () => _updateFirst(-2.5),
              onInc: () => _updateFirst(2.5),
            ),
            _buildLabeledField(
              label: "Süre (sn)",
              controller: _secondCtrl,
              onDec: () => _updateSecond(-5),
              onInc: () => _updateSecond(5),
            ),
          ],
        );
      case MetricType.speedTime:
        return Column(
          children: [
            _buildLabeledField(
              label: "Hız (km/s)",
              controller: _firstCtrl,
              onDec: () => _updateFirst(-0.5),
              onInc: () => _updateFirst(0.5),
            ),
            _buildLabeledField(
              label: "Süre (dk)",
              controller: _secondCtrl,
              onDec: () => _updateSecond(-1),
              onInc: () => _updateSecond(1),
            ),
          ],
        );
    }
  }

  Widget _buildSetRow(Map<String, dynamic> set, int index) {
    final hasNote = (set['note'] ?? "").toString().isNotEmpty;

    // Görüntü formatı metricType'a göre
    String display;
    switch (widget.exercise.metricType) {
      case MetricType.weightReps:
        display = "${set['first']} kg × ${set['second']} tekrar";
        break;
      case MetricType.weightTime:
        display = "${set['first']} kg × ${set['second']} sn";
        break;
      case MetricType.speedTime:
        display = "${set['first']} km/s × ${set['second']} dk";
        break;
    }

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        final removedSetNo = set['setNo'];
        setState(() {
          _sets.removeAt(index);
          for (int i = 0; i < _sets.length; i++) {
            _sets[i]['setNo'] = i + 1;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Set $removedSetNo silindi")),
        );
      },
      child: InkWell(
        onTap: () {
          setState(() {
            _editingIndex = index;
            _firstValue = set['first'].toDouble();
            _secondValue = set['second'];
            _firstCtrl.text = _firstValue.toStringAsFixed(1);
            _secondCtrl.text = _secondValue.toString();
          });
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Text("Set ${set['setNo']}",
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Expanded(
                  child: Center(
                    child: Text(
                      display,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.note_add_outlined,
                    color: hasNote ? Colors.blue : Colors.grey,
                  ),
                  tooltip: "Sete not ekle",
                  onPressed: () => _editNoteDialog(index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (_editingIndex != null) {
      return ElevatedButton.icon(
        onPressed: _updateSet,
        icon: const Icon(Icons.check),
        label: const Text("Seti Güncelle"),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: _addSet,
        icon: const Icon(Icons.add),
        label: const Text("Set Ekle"),
      );
    }
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
        title: Text(widget.exercise.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputs(),
            _buildActionButton(),
            const SizedBox(height: 12),
            Expanded(
              child: _sets.isEmpty
                  ? const Center(child: Text("Henüz set yok"))
                  : ListView.builder(
                itemCount: _sets.length,
                itemBuilder: (context, i) => _buildSetRow(_sets[i], i),
              ),
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
