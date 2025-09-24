import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasGoals = false;

    void _addGoal() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hedef ekleme (placeholder)")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text("Hedeflerim"),
        actions: [IconButton(icon: const Icon(Icons.add_task), onPressed: _addGoal)],
      ),
      body: Center(
        child: hasGoals
            ? const Text("Hedefler listelenecek")
            : GestureDetector(
          onTap: _addGoal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.flag_outlined, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text("Henüz hedef yok.\nHedef koy!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
