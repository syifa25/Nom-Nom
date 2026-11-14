
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class RecommendationPage extends StatelessWidget {
  final int portions;
  final Set<String> selectedIngredients;
  final Set<String> selectedTools;
  final List<Map<String, dynamic>> recipes;

  const RecommendationPage({
    super.key,
    required this.portions,
    required this.selectedIngredients,
    required this.selectedTools,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
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
                    'Resep pilihan Nom-Nom AI berdasarkan '
                    'bahan dan peralatanmu.',
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
                      color: AppColors.coral.withValues(alpha: 0.10),
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: recipes.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final recipe = recipes[index];

                  return _buildRecipeCard(context, recipe);
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
    final name = recipe['name'] ?? 'Resep Tanpa Nama';
    final duration = recipe['duration'] ?? 0;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showRecipeDetail(context, recipe),
      child: Container(
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
                color: AppColors.coral.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.restaurant_rounded,
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
                    name.toString(),
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
                    recipe['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                        '$duration menit',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.people_alt_rounded,
                        size: 16,
                        color: AppColors.coral,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe['portions'] ?? portions} porsi',
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
      ),
    );
  }

  void _showRecipeDetail(
    BuildContext context,
    Map<String, dynamic> recipe,
  ) {
    final ingredients =
        recipe['ingredients'] as List? ?? [];

    final additionalIngredients =
        recipe['additional_ingredients'] as List? ?? [];

    final tools = recipe['tools'] as List? ?? [];

    final steps = recipe['steps'] as List? ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: AppColors.bgPage,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      recipe['name'] ?? 'Detail Resep',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      recipe['description'] ?? '',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: AppColors.coral,
                        ),
                        const SizedBox(width: 6),
                        Text('${recipe['duration']} menit'),
                        const SizedBox(width: 18),
                        const Icon(
                          Icons.people_alt_rounded,
                          color: AppColors.coral,
                        ),
                        const SizedBox(width: 6),
                        Text('${recipe['portions']} porsi'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle('Bahan yang dibutuhkan'),

                    ...ingredients.map((item) {
                      final ingredient =
                          Map<String, dynamic>.from(item);

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: Icon(
                          ingredient['available'] == true
                              ? Icons.check_circle_rounded
                              : Icons.add_circle_outline,
                          color: ingredient['available'] == true
                              ? Colors.green
                              : AppColors.coral,
                        ),
                        title: Text(
                          ingredient['name'] ?? '',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        trailing: Text(
                          ingredient['quantity'] ?? '',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }),

                    if (additionalIngredients.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _sectionTitle('Bahan tambahan'),
                      ...additionalIngredients.map(
                        (item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: const Icon(
                            Icons.shopping_basket_outlined,
                            color: AppColors.coral,
                          ),
                          title: Text(item.toString()),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    _sectionTitle('Peralatan masak'),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tools.map((tool) {
                        return Chip(
                          label: Text(tool.toString()),
                          backgroundColor:
                              AppColors.coral.withValues(alpha: 0.10),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle('Cara memasak'),

                    ...steps.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColors.coral,
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.value.toString(),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
