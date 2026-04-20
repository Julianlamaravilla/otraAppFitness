import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/config/app_config.dart';

// Events
abstract class NutritionEvent extends Equatable {
  const NutritionEvent();
  @override
  List<Object?> get props => [];
}

class FetchNutrition extends NutritionEvent {
  final int age;
  final double weight;
  final double height;
  final String goal;
  final String? restrictions;

  const FetchNutrition({
    required this.age,
    required this.weight,
    required this.height,
    required this.goal,
    this.restrictions,
  });

  @override
  List<Object?> get props => [age, weight, height, goal, restrictions];
}

// States
abstract class NutritionState extends Equatable {
  const NutritionState();
  @override
  List<Object?> get props => [];
}

class NutritionInitial extends NutritionState {}
class NutritionLoading extends NutritionState {}
class NutritionSuccess extends NutritionState {
  final int calories;
  final Map<String, int> macros;
  final List<dynamic> suggestions;

  const NutritionSuccess({
    required this.calories,
    required this.macros,
    required this.suggestions,
  });

  @override
  List<Object?> get props => [calories, macros, suggestions];
}

class NutritionFailure extends NutritionState {
  final String error;
  const NutritionFailure(this.error);
  @override
  List<Object?> get props => [error];
}

// Bloc
class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  NutritionBloc() : super(NutritionInitial()) {
    on<FetchNutrition>((event, emit) async {
      emit(NutritionLoading());
      try {
        final response = await http.post(
          Uri.parse('${AppConfig.apiBaseUrl}/nutrition/suggest'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'age': event.age,
            'weight': event.weight,
            'height': event.height,
            'goal': event.goal,
            'restrictions': event.restrictions,
          }),
        );
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          emit(NutritionSuccess(
            calories: data['targetCalories'],
            macros: Map<String, int>.from(data['macros']),
            suggestions: data['suggestions'],
          ));
        } else {
          final data = jsonDecode(response.body);
          emit(NutritionFailure(data['message'] ?? 'Failed to fetch nutrition'));
        }
      } catch (e) {
        emit(const NutritionFailure('Connection error: Ensure local API is running.'));
      }
    });
  }
}
