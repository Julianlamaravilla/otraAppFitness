import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../../main.dart';

class VerifyScreen extends StatelessWidget {
  final String name;
  final int age;
  final double weight;
  final double height;
  final String goal;
  final String? injuries;
  final String? restrictions;

  const VerifyScreen({
    super.key,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.goal,
    this.injuries,
    this.restrictions,
  });

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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Icon(
                    Icons.verified_user_outlined,
                    size: 80,
                    color: AppTheme.secondaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Verification\nSummary',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GlassContainer(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            _buildSummaryRow('Name', name),
                            const Divider(color: Colors.white10),
                            _buildSummaryRow('Age', '$age years'),
                            const Divider(color: Colors.white10),
                            _buildSummaryRow('Weight', '$weight kg'),
                            const Divider(color: Colors.white10),
                            _buildSummaryRow('Height', '$height cm'),
                            const Divider(color: Colors.white10),
                            _buildSummaryRow('Goal', goal),
                            const Divider(color: Colors.white10),
                            _buildSummaryRow('Injuries', (injuries == null || injuries!.isEmpty) ? 'None' : injuries!),
                            const Divider(color: Colors.white10),
                            _buildSummaryRow('Restrictions', (restrictions == null || restrictions!.isEmpty) ? 'None' : restrictions!),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => MainNavigationShell(
                              name: name,
                              age: age,
                              weight: weight,
                              height: height,
                              goal: goal,
                              injuries: injuries,
                              restrictions: restrictions,
                            ),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'START TRAINING',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
