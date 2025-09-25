import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import 'exercise_picker_screen.dart';
import 'goals/goals_screen.dart';
import 'exercises/exercise_detail_screen.dart';
import '../models/exercise_with_sets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int dayOffset = 0;
  final Map<int, List<ExerciseWithSets>> _selectedByDay = {};

  List<ExerciseWithSets> get _todayExercises => _selectedByDay[dayOffset] ?? [];

  String getDayLabel() {
    if (dayOffset == 0) return "Bugün";
    if (dayOffset == -1) return "Dün";
    if (dayOffset == 1) return "Yarın";
    if (dayOffset < -1) return "${-dayOffset} gün önce";
    return "$dayOffset gün sonra";
  }

  Future<void> openExercisePicker() => _openPicker();

  Future<void> _openPicker() async {
    final picked = await Navigator.push<ExerciseWithSets>(
      context,
      MaterialPageRoute(builder: (_) => const ExercisePickerScreen()),
    );
    if (picked != null) {
      setState(() {
        _selectedByDay[dayOffset] = [..._todayExercises, picked];
      });
    }
  }

  Widget _buildExerciseCard(ExerciseWithSets ex, int index) {
    return InkWell(
      onTap: () async {
        final updated = await Navigator.push<ExerciseWithSets>(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciseDetailScreen(
              exercise: Exercise(
                name: ex.name,
                category: "?", // kategori opsiyonel burada
                metricType: ex.metricType, // 🔑 artık buradan alıyoruz
              ),
              initialData: ex,
            ),
          ),
        );
        if (updated != null) {
          setState(() {
            _todayExercises[index] = updated;
          });
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ex.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Column(
                children: ex.sets.map((set) {
                  final hasNote = (set['note'] ?? "").toString().isNotEmpty;

                  String display;
                  switch (ex.metricType) {
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

                  return Row(
                    children: [
                      Text("Set ${set['setNo']}"),
                      Expanded(
                        child: Center(
                          child: Text(
                            display,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 28,
                        child: hasNote
                            ? GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Set ${set['setNo']} notu"),
                                  content: Text(set['note']),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Kapat"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.note_add_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                        )
                            : null,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    final isEmpty = _todayExercises.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Üst bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: "Hedefler",
                    icon: const Icon(Icons.flag),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalsScreen()));
                    },
                  ),
                  IconButton(
                    tooltip: "Kronometre",
                    icon: const Icon(Icons.timer),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kronometre açılacak")));
                    },
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
                  Expanded(
                    child: Center(
                      child: Text(getDayLabel(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
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
                  : ListView.builder(
                itemCount: _todayExercises.length,
                itemBuilder: (context, i) => _buildExerciseCard(_todayExercises[i], i),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
