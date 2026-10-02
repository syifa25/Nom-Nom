import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class RecommendationPage extends StatelessWidget {
  final int portions;
  final Set<String> selectedIngredients;
  final Set<String> selectedTools;

  const RecommendationPage({
    super.key,
    required this.portions,
    required this.selectedIngredients,
    required this.selectedTools,
  });

  List<Map<String, dynamic>> get recipes {
    final List<Map<String, dynamic>> allRecipes = [
      {
        'name': 'Nasi Goreng Ayam',
        'category': 'Makanan Utama',
        'time': '20 menit',
        'difficulty': 'Mudah',
        'icon': Icons.rice_bowl_rounded,
        'ingredients': ['Ayam', 'Telur'],
        'tools': ['Kompor', 'Wajan'],
      },
      {
        'name': 'Ayam Goreng',
        'category': 'Makanan Utama',
        'time': '35 menit',
        'difficulty': 'Mudah',
        'icon': Icons.restaurant_rounded,
        'ingredients': ['Ayam'],
        'tools': ['Kompor', 'Wajan'],
      },
      {
        'name': 'Telur Balado',
        'category': 'Lauk',
        'time': '25 menit',
        'difficulty': 'Mudah',
        'icon': Icons.egg_alt_rounded,
        'ingredients': ['Telur', 'Cabai'],
        'tools': ['Kompor', 'Wajan'],
      },
      {
        'name': 'Tumis Sayuran',
        'category': 'Sayuran',
        'time': '15 menit',
        'difficulty': 'Mudah',
        'icon': Icons.eco_rounded,
        'ingredients': ['Wortel', 'Tomat'],
        'tools': ['Kompor', 'Wajan'],
      },
      {
        'name': 'Sup Ayam',
        'category': 'Sup',
        'time': '40 menit',
        'difficulty': 'Sedang',
        'icon': Icons.soup_kitchen_rounded,
        'ingredients': ['Ayam', 'Wortel', 'Kentang'],
        'tools': ['Kompor', 'Panci'],
      },
      {
        'name': 'Tahu Goreng',
        'category': 'Lauk',
        'time': '15 menit',
        'difficulty': 'Mudah',
        'icon': Icons.restaurant_menu_rounded,
        'ingredients': ['Tahu'],
        'tools': ['Kompor', 'Wajan'],
      },
    ];

    final matchingRecipes = allRecipes.where((recipe) {
      final recipeIngredients =
          recipe['ingredients'] as List<String>;
      final recipeTools = recipe['tools'] as List<String>;

      final hasIngredient = recipeIngredients.any(
        selectedIngredients.contains,
      );

      final hasTool = recipeTools.any(
        selectedTools.contains,
      );

      return hasIngredient && hasTool;
    }).toList();

    // Kalau belum ada yang cocok, tetap tampilkan beberapa resep.
    if (matchingRecipes.isEmpty) {
      return allRecipes.take(4).toList();
    }

    return matchingRecipes;
  }

  @override
  Widget build(BuildContext context) {
    final recommendedRecipes = recipes;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Rekomendasi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                8,
                24,
                18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rekomendasi untukmu ✨',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Berdasarkan bahan dan peralatan yang kamu punya.',
                    style: TextStyle(
                      color: AppColors.textPrimary.withValues(
                        alpha: 0.60,
                      ),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.coral.withValues(
                        alpha: 0.10,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$portions porsi • '
                      '${selectedIngredients.length} bahan • '
                      '${selectedTools.length} alat',
                      style: const TextStyle(
                        color: AppColors.coral,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  24,
                ),
                itemCount: recommendedRecipes.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 14);
                },
                itemBuilder: (context, index) {
                  final recipe = recommendedRecipes[index];

                  return _buildRecipeCard(
                    context,
                    recipe,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(
    BuildContext context,
    Map<String, dynamic> recipe,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: AppColors.coral.withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              recipe['icon'] as IconData,
              size: 42,
              color: AppColors.coral,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['name'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  recipe['category'] as String,
                  style: TextStyle(
                    color: AppColors.textPrimary.withValues(
                      alpha: 0.55,
                    ),
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: AppColors.coral,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      recipe['time'] as String,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Icon(
                      Icons.signal_cellular_alt_rounded,
                      size: 16,
                      color: AppColors.coral,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      recipe['difficulty'] as String,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.coral,
            size: 28,
          ),
        ],
      ),
    );
  }
}