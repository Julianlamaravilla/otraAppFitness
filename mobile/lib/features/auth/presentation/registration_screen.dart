import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/theme/app_theme.dart';
import '../bloc/auth_bloc.dart';
import 'verify_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _injuriesController = TextEditingController();
  final _restrictionsController = TextEditingController();
  String _selectedGoal = 'Wellness (General Quality of Life)';

  final List<String> _goals = [
    'Wellness (General Quality of Life)',
    'Performance (Muscle Gain)',
    'Performance (Endurance)',
    'Performance (Agility)',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VerifyScreen(
                  name: _nameController.text,
                  age: int.tryParse(_ageController.text) ?? 0,
                  weight: double.tryParse(_weightController.text) ?? 0.0,
                  height: double.tryParse(_heightController.text) ?? 0.0,
                  goal: _selectedGoal,
                  injuries: _injuriesController.text,
                  restrictions: _restrictionsController.text,
                ),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.redAccent),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                // Background Gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F0F12)],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Complete\nYour Profile',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'We need this data to ensure your routines are effective and medically safe.',
                            style: TextStyle(color: Colors.white54, fontSize: 16),
                          ),
                          const SizedBox(height: 30),
                          _buildInputField(
                            label: 'Full Name',
                            controller: _nameController,
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  label: 'Age (18-35)',
                                  controller: _ageController,
                                  icon: Icons.calendar_today_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildInputField(
                                  label: 'Weight (kg)',
                                  controller: _weightController,
                                  icon: Icons.monitor_weight_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          _buildInputField(
                            label: 'Height (cm)',
                            controller: _heightController,
                            icon: Icons.height,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Fitness Goal',
                            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          GlassContainer(
                            borderRadius: 16,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedGoal,
                                  isExpanded: true,
                                  dropdownColor: const Color(0xFF1A1A2E),
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                  items: _goals.map((String goal) {
                                    return DropdownMenuItem<String>(
                                      value: goal,
                                      child: Text(goal),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() => _selectedGoal = newValue!);
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildInputField(
                            label: 'Injuries / Medical Conditions (Optional)',
                            controller: _injuriesController,
                            icon: Icons.medical_services_outlined,
                            hint: 'e.g. Lower back pain, knee injury',
                          ),
                          const SizedBox(height: 15),
                          _buildInputField(
                            label: 'Dietary Restrictions (Optional)',
                            controller: _restrictionsController,
                            icon: Icons.no_food_outlined,
                            hint: 'e.g. Peanut allergy, Vegan',
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      final name = _nameController.text;
                                      final age = int.tryParse(_ageController.text) ?? 0;
                                      final weight = double.tryParse(_weightController.text) ?? 0.0;
                                      final height = double.tryParse(_heightController.text) ?? 0.0;

                                      if (name.isNotEmpty && age >= 18 && age <= 35 && weight > 0 && height > 0) {
                                        context.read<AuthBloc>().add(
                                              RegisterUser(
                                                name: name,
                                                age: age,
                                                weight: weight,
                                                height: height,
                                                goal: _selectedGoal,
                                                injuries: _injuriesController.text,
                                                restrictions: _restrictionsController.text,
                                              ),
                                            );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Please fill mandatory fields (Name, Age 18-35, Weight, Height)')),
                                        );
                                      }
                                    },
                              child: state is AuthLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      'CONTINUE',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GlassContainer(
          borderRadius: 16,
          blur: 10,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.primaryColor),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}
