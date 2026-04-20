import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/config/app_config.dart';

// Events
abstract class RoutineEvent extends Equatable {
  const RoutineEvent();
  @override
  List<Object?> get props => [];
}

class FetchRoutine extends RoutineEvent {
  final String name;
  final String goal;
  final String? injuries;

  const FetchRoutine({
    required this.name,
    required this.goal,
    this.injuries,
  });

  @override
  List<Object?> get props => [name, goal, injuries];
}

// States
abstract class RoutineState extends Equatable {
  const RoutineState();
  @override
  List<Object?> get props => [];
}

class RoutineInitial extends RoutineState {}
class RoutineLoading extends RoutineState {}
class RoutineSuccess extends RoutineState {
  final List<dynamic> exercises;
  final String message;
  const RoutineSuccess(this.exercises, this.message);
  @override
  List<Object?> get props => [exercises, message];
}
class RoutineFailure extends RoutineState {
  final String error;
  const RoutineFailure(this.error);
  @override
  List<Object?> get props => [error];
}

// BLoC
class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  RoutineBloc() : super(RoutineInitial()) {
    on<FetchRoutine>((event, emit) async {
      emit(RoutineLoading());
      try {
        final response = await http.post(
          Uri.parse('${AppConfig.apiBaseUrl}/routines/generate'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': event.name,
            'goal': event.goal,
            'injuries': event.injuries,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          emit(RoutineSuccess(data['routine'], data['message']));
        } else {
          final data = jsonDecode(response.body);
          emit(RoutineFailure(data['message'] ?? 'Failed to generate routine'));
        }
      } catch (e) {
        emit(const RoutineFailure('Connection error: API unavailable.'));
      }
    });
  }
}
