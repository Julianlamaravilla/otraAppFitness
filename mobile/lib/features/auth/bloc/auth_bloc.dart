import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/config/app_config.dart';
import '../../../core/security/aes_vault.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class RegisterUser extends AuthEvent {
  final String name;
  final int age;
  final double weight;
  final double height;
  final String goal;
  final String? injuries;
  final String? restrictions;

  const RegisterUser({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.goal,
    this.injuries,
    this.restrictions,
  });

  @override
  List<Object?> get props => [name, age, weight, height, goal, injuries, restrictions];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String message;
  const AuthSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
  @override
  List<Object?> get props => [error];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<RegisterUser>((event, emit) async {
      emit(AuthLoading());
      try {
        // Encrypt sensitive health data if present
        final encryptedInjuries = event.injuries != null && event.injuries!.isNotEmpty 
            ? AesVault.encrypt(event.injuries!) 
            : null;
        final encryptedRestrictions = event.restrictions != null && event.restrictions!.isNotEmpty 
            ? AesVault.encrypt(event.restrictions!) 
            : null;

        final response = await http.post(
          Uri.parse('${AppConfig.apiBaseUrl}/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': event.name,
            'age': event.age,
            'weight': event.weight,
            'height': event.height,
            'goal': event.goal,
            'injuries': encryptedInjuries,
            'restrictions': encryptedRestrictions,
          }),
        );

        if (response.statusCode == 201) {
          final data = jsonDecode(response.body);
          emit(AuthSuccess(data['message'] ?? 'Registration successful!'));
        } else {
          final data = jsonDecode(response.body);
          emit(AuthFailure(data['message'] ?? 'Failed to register'));
        }
      } catch (e) {
        emit(const AuthFailure('Connection error: Please ensure local API is running.'));
      }
    });
  }
}
