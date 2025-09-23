import 'package:flutter/material.dart';

import 'screens/body_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/home_screen.dart';
import 'screens/exercise_picker_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const WorkoutTrackerApp());
}

class WorkoutTrackerApp extends StatelessWidget {
  const WorkoutTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Navbar üzerindeki görsel index (0..4). Varsayılan: Home (2)
  int _navIndex = 2;

  // Uygulamada gerçek sayfalar: Vücut, Takvim, Home, Ayarlar
  final List<Widget> _pages = const [
    BodyScreen(),      // 0
    CalendarScreen(),  // 1
    HomeScreen(),      // 2
    SettingsScreen(),  // 3  (navbar'da 4. indexe denk gelecek)
  ];

  // Navbar index -> Page index eşlemesi (Başlat = null)
  int? _pageIndexFor(int navIndex) {
    if (navIndex == 3) return null;          // Başlat
    return navIndex > 3 ? navIndex - 1 : navIndex;
  }

  Future<void> _openExercisePicker() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExercisePickerScreen()),
    );
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      // Başlat: sadece picker aç
      _openExercisePicker();
      return;
    }
    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = _pageIndexFor(_navIndex) ?? 2; // Başlat'ta Home'u göstermeye devam et

    return Scaffold(
      body: _pages[pageIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(thickness: 1, height: 1), // Navbar üst çizgisi
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _navIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.accessibility_new), label: "Vücut"),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Takvim"),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Başlat"),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayarlar"),
            ],
          ),
        ],
      ),
    );
  }
}
