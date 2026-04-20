import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/nutrition_bloc.dart';
import '../../../shared/theme/app_theme.dart';

class NutritionView extends StatelessWidget {
  final int age;
  final double weight;
  final double height;
  final String goal;
  final String? restrictions;

  const NutritionView({
    super.key,
    required this.age,
    required this.weight,
    required this.height,
    required this.goal,
    this.restrictions,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NutritionBloc()..add(FetchNutrition(
        age: age,
        weight: weight,
        height: height,
        goal: goal,
        restrictions: restrictions,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<NutritionBloc, NutritionState>(
          builder: (context, state) {
            if (state is NutritionLoading) {
              return Center(child: CircularProgressIndicator(color: AppTheme.secondaryColor));
            } else if (state is NutritionFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                      const SizedBox(height: 16),
                      Text(state.error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              );
            } else if (state is NutritionSuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<NutritionBloc>().add(FetchNutrition(
                    age: age,
                    weight: weight,
                    height: height,
                    goal: goal,
                    restrictions: restrictions,
                  ));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nutrition Plan',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      _buildCalorieCard(state.calories),
                      const SizedBox(height: 24),
                      const Text(
                        'Target Macros',
                        style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      _buildMacroGrid(state.macros),
                      const SizedBox(height: 30),
                      const Text(
                        'Safe Meal Suggestions',
                        style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      ...state.suggestions.map((meal) => _buildMealCard(meal)).toList(),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildCalorieCard(int calories) {
    return GlassContainer(
      borderRadius: 24,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.restaurant_menu, color: AppTheme.secondaryColor, size: 32),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daily Target', style: TextStyle(color: Colors.white54, fontSize: 14)),
                Text('$calories kcal', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroGrid(Map<String, int> macros) {
    return Row(
      children: [
        _buildMacroItem('Protein', '${macros['protein']}g', Colors.orangeAccent),
        const SizedBox(width: 12),
        _buildMacroItem('Carbs', '${macros['carbs']}g', Colors.lightBlueAccent),
        const SizedBox(width: 12),
        _buildMacroItem('Fats', '${macros['fats']}g', Colors.pinkAccent),
      ],
    );
  }

  Widget _buildMacroItem(String label, String value, Color color) {
    return Expanded(
      child: GlassContainer(
        borderRadius: 16,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard(dynamic meal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        borderRadius: 20,
        child: Theme(
          data: ThemeData.dark().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: const Icon(Icons.fastfood_outlined, color: Colors.white54),
            title: Text(meal['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text('${meal['calories']} kcal • ${meal['tags'].join(', ')}', 
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.white10),
                    const Text('Main Ingredients:', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: (meal['ingredients'] as List).map((i) => Chip(
                        label: Text(i, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.white.withOpacity(0.05),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
