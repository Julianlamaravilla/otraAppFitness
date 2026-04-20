import 'package:flutter/material.dart';
import 'shared/theme/app_theme.dart';
import 'features/auth/presentation/registration_screen.dart';
import 'features/routines/presentation/routine_view.dart';
import 'features/progress/presentation/charts_view.dart';

import 'features/nutrition/presentation/nutrition_view.dart';
import 'core/sync/sync_manager.dart';

void main() {
  SyncManager().start();
  runApp(const OtraAppFitness());
}

class OtraAppFitness extends StatelessWidget {
  const OtraAppFitness({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Otra App Fitness',
      theme: AppTheme.darkTheme,
      home: const RegistrationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  final String name;
  final String goal;
  final int age;
  final double weight;
  final double height;
  final String? injuries;
  final String? restrictions;

  const MainNavigationShell({
    super.key,
    required this.name,
    required this.goal,
    required this.age,
    required this.weight,
    required this.height,
    this.injuries,
    this.restrictions,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      RoutineView(name: widget.name, goal: widget.goal, injuries: widget.injuries),
      const ChartsView(),
      NutritionView(
        age: widget.age,
        weight: widget.weight,
        height: widget.height,
        goal: widget.goal,
        restrictions: widget.restrictions,
      ),
      const Center(child: Text('Settings (Coming Soon)', style: TextStyle(color: Colors.white54))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A1A2E), Color(0xFF0F0F12)],
              ),
            ),
          ),
          SafeArea(child: _screens[_currentIndex]),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        child: GlassContainer(
          borderRadius: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: Colors.white54,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Routines'),
                BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Progress'),
                BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Nutrition'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
