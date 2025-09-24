import 'package:flutter/material.dart';

import 'screens/body_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/home_screen.dart';
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
  // DİKKAT: Public state tipi
  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();
  int _navIndex = 2; // Home

  late final List<Widget> _pages = [
    const BodyScreen(),
    const CalendarScreen(),
    HomeScreen(key: _homeKey),
    const SettingsScreen(),
  ];

  int _pageIndexFor(int navIndex) {
    if (navIndex == 3) return 2; // Başlat tıklandığında Home göster
    return navIndex > 3 ? navIndex - 1 : navIndex;
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      // Başlat: önce Home'a geç, sonra Home içinden picker aç
      setState(() => _navIndex = 2);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _homeKey.currentState?.openExercisePicker();
      });
      return;
    }
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = _pageIndexFor(_navIndex);
    return Scaffold(
      body: _pages[pageIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(thickness: 1, height: 1), // navbar üst çizgisi
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
