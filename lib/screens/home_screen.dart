import 'package:flutter/material.dart';
import 'exercise_picker_screen.dart';
import 'goals/goals_screen.dart';
import '../models/selected_exercise.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int dayOffset = 0; // 0=Bugün
  final Map<int, List<SelectedExercise>> _selectedByDay = {};

  List<SelectedExercise> get _todayExercises => _selectedByDay[dayOffset] ?? [];

  String getDayLabel() {
    if (dayOffset == 0) return "Bugün";
    if (dayOffset == -1) return "Dün";
    if (dayOffset == 1) return "Yarın";
    if (dayOffset < -1) return "${-dayOffset} gün önce";
    return "$dayOffset gün sonra";
  }

  Future<void> _openPicker() async {
    final picked = await Navigator.push<List<SelectedExercise>>(
      context,
      MaterialPageRoute(builder: (_) => const ExercisePickerScreen()),
    );
    if (picked != null && picked.isNotEmpty) {
      setState(() {
        _selectedByDay[dayOffset] = [..._todayExercises, ...picked];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _todayExercises.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Üst butonlar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: "Hedefler",
                    icon: const Icon(Icons.flag),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalsScreen())),
                  ),
                  IconButton(
                    tooltip: "Kronometre",
                    icon: const Icon(Icons.timer),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Kronometre açılacak")),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 1),

            // Gün seçici
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => setState(() => dayOffset--)),
                  Expanded(child: Center(child: Text(getDayLabel(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
                  IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: () => setState(() => dayOffset++)),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 1),

            // İçerik
            Expanded(
              child: isEmpty
                  ? Center(
                child: InkWell(
                  onTap: _openPicker,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1.2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.fitness_center, size: 44),
                        SizedBox(height: 10),
                        Text("Yeni Antrenman Başlat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: _todayExercises.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final ex = _todayExercises[i];
                  return ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(ex.name),
                    subtitle: Text("${ex.weight.toStringAsFixed(1)} kg × ${ex.reps}"),
                    trailing: IconButton(
                      tooltip: "Kaldır",
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        setState(() {
                          final list = List<SelectedExercise>.from(_todayExercises);
                          list.removeAt(i);
                          if (list.isEmpty) {
                            _selectedByDay.remove(dayOffset);
                          } else {
                            _selectedByDay[dayOffset] = list;
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
