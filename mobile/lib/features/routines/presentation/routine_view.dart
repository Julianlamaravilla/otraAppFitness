import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/routine_bloc.dart';
import '../../../shared/theme/app_theme.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/config/app_config.dart';

class RoutineView extends StatefulWidget {
  final String name;
  final String goal;
  final String? injuries;

  const RoutineView({
    super.key,
    required this.name,
    required this.goal,
    this.injuries,
  });

  @override
  State<RoutineView> createState() => _RoutineViewState();
}

class _RoutineViewState extends State<RoutineView> {
  bool _isCompleting = false;

  Future<void> _completeSession() async {
    setState(() => _isCompleting = true);
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/progress/track'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': 'workout',
          'value': 100, // Fixed score for completion
          'notes': 'Completed session: ${widget.goal}',
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF1A1A2E),
              title: const Text('Workout Completed!', style: TextStyle(color: Colors.white)),
              content: const Text('Your progress has been tracked in Analytics.', style: TextStyle(color: Colors.white70)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('AWESOME', style: TextStyle(color: AppTheme.primaryColor)),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error completing session: $e');
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoutineBloc()..add(FetchRoutine(name: widget.name, goal: widget.goal, injuries: widget.injuries)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<RoutineBloc, RoutineState>(
          builder: (context, state) {
            if (state is RoutineLoading) {
              return Center(child: CircularProgressIndicator(color: AppTheme.secondaryColor));
            } else if (state is RoutineFailure) {
              return Center(
                child: Text(state.error, style: const TextStyle(color: Colors.redAccent)),
              );
            } else if (state is RoutineSuccess) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
                            ),
                            Text(
                              widget.name,
                              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: AppTheme.secondaryColor,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildGoalBanner(widget.goal),
                    const SizedBox(height: 30),
                    const Text(
                      'Your Safe Routine for Today',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.exercises.length,
                        itemBuilder: (context, index) {
                          final ex = state.exercises[index];
                          return _buildExerciseCard(ex);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isCompleting ? null : _completeSession,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: _isCompleting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('COMPLETE SESSION', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildGoalBanner(String goal) {
    return GlassContainer(
      borderRadius: 20,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(Icons.bolt, color: AppTheme.secondaryColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Goal', style: TextStyle(color: Colors.white54, fontSize: 14)),
                  Text(goal, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(dynamic exercise) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        borderRadius: 16,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.fitness_center, color: AppTheme.primaryColor),
          ),
          title: Text(
            exercise['name'],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${exercise['category']} • ${exercise['intensity']} Intensity',
            style: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
        ),
      ),
    );
  }
}
