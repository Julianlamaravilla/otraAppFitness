import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../shared/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import 'add_entry_screen.dart';
import '../../../core/sync/sync_manager.dart';

class ChartsView extends StatefulWidget {
  const ChartsView({super.key});

  @override
  State<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {
  List<dynamic> _history = [];
  int _consistencyScore = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/progress/history'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _history = data['history'];
          _consistencyScore = data['consistencyScore'];
        });
      }
    } catch (e) {
      debugPrint('Error fetching history: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEntryScreen()),
          );
          if (result == true) _fetchData();
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppTheme.secondaryColor))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Analytics',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      StreamBuilder<bool>(
                        stream: SyncManager().isSyncingStream,
                        initialData: false,
                        builder: (context, snapshot) {
                          final isSyncing = snapshot.data ?? false;
                          final pendingCount = SyncManager().pendingCount;
                          
                          if (isSyncing) {
                            return const Row(
                              children: [
                                SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orangeAccent)),
                                SizedBox(width: 8),
                                Text('Syncing...', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
                              ],
                            );
                          } else if (pendingCount > 0) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.orangeAccent, width: 0.5),
                              ),
                              child: Text('$pendingCount pending', style: const TextStyle(color: Colors.orangeAccent, fontSize: 10)),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildConsistencyCard(),
                  const SizedBox(height: 30),
                  const Text(
                    'Weight Trend (kg)',
                    style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GlassContainer(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
                        child: _buildWeightChart(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildConsistencyCard() {
    return GlassContainer(
      borderRadius: 20,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: _consistencyScore / 100,
                    backgroundColor: Colors.white10,
                    color: AppTheme.secondaryColor,
                    strokeWidth: 8,
                  ),
                ),
                Text(
                  '$_consistencyScore%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Consistency Score', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Text('Keep it up! You are doing great.', 
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChart() {
    final weightEntries = _history.where((e) => e['type'] == 'weight').toList();
    if (weightEntries.isEmpty) {
      return const Center(child: Text('No weight data yet', style: TextStyle(color: Colors.white24)));
    }

    final spots = weightEntries.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), (entry.value['value'] as num).toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.primaryColor,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryColor.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
