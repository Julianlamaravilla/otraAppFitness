import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../shared/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import '../sync/sync_manager.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  String _type = 'weight';
  bool _isLoading = false;

  Future<void> _submitEntry() async {
    final value = double.tryParse(_valueController.text);
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid numeric value')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final bodyData = {
        'type': _type,
        'value': value,
        'notes': _notesController.text,
      };

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/progress/track'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) {
        if (mounted) Navigator.of(context).pop(true);
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      // Background Sync Fallback
      SyncManager().addToQueue('/progress/track', {
        'type': _type,
        'value': value,
        'notes': '${_notesController.text} (Offline Entry)',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offline: Entry queued for background sync'),
            backgroundColor: Colors.orangeAccent,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pop(true); // Still pop as it's "handled"
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Entry'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Track Your Progress',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  const Text('Metric Type', style: TextStyle(color: Colors.white54, fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTypeTab('Weight', 'weight', Icons.monitor_weight_outlined),
                      const SizedBox(width: 12),
                      _buildTypeTab('Workout', 'workout', Icons.fitness_center),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildInputField(
                    label: _type == 'weight' ? 'Weight (kg)' : 'Workout Score / Reps',
                    controller: _valueController,
                    icon: Icons.edit_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: 'Notes (Optional)',
                    controller: _notesController,
                    icon: Icons.notes,
                    hint: 'How did it feel?',
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitEntry,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('SAVE ENTRY', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildTypeTab(String label, String value, IconData icon) {
    final isSelected = _type == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = value),
        child: GlassContainer(
          borderRadius: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor.withOpacity(0.2) : Colors.transparent,
              border: isSelected ? Border.all(color: AppTheme.primaryColor, width: 1) : null,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.white54),
                const SizedBox(height: 8),
                Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white54)),
              ],
            ),
          ),
        ),
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
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        GlassContainer(
          borderRadius: 16,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.secondaryColor),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}
