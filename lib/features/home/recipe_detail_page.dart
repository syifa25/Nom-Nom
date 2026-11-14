import 'package:flutter/material.dart';
import 'recipe_data.dart';

class RecipeDetailPage extends StatelessWidget {
  final Map<String, dynamic> recipe;

  /// Opsional: dipanggil saat tombol "Tambah ke Meal Plan" ditekan.
  /// Kalau di file lamamu tombol itu sudah punya aksi sendiri,
  /// pindahkan aksinya ke callback ini atau ke onPressed di bawah.
  final void Function(Map<String, dynamic> recipe)? onAddToMealPlan;

  const RecipeDetailPage({
    super.key,
    required this.recipe,
    this.onAddToMealPlan,
  });

  static const _backgroundColor = Color(0xFFFFF4E5);
  static const _primaryColor = Color(0xFFE66A3C);
  static const _brownColor = Color(0xFF8B3E20);
  static const _yellowColor = Color(0xFFFFC857);
  static const _chipColor = Color(0xFFFFE9B8);
  static const _tipColor = Color(0xFFFFF0C9);

  @override
  Widget build(BuildContext context) {
    final name = recipe['name'] as String? ?? '';
    final category = recipe['category'] as String? ?? '';
    final time = recipe['time'] as String? ?? '-';
    final rating = recipe['rating'] as String? ?? '-';
    final imagePath = recipe['image'] as String? ?? '';

    // Detail resep spesifik per menu (bahan + langkah + tips)
    final detail = RecipeData.of(name);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 230,
            backgroundColor: _primaryColor,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black38,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: _yellowColor,
                    child: const Icon(
                      Icons.restaurant,
                      size: 80,
                      color: _brownColor,
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul + kategori
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: _brownColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: _chipColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _yellowColor),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _brownColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Waktu, rating, porsi
                  Wrap(
                    spacing: 16,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _metaItem(Icons.access_time, time, _primaryColor),
                      _metaItem(
                        Icons.star,
                        '$rating (120+ ulasan)',
                        _yellowColor,
                      ),
                      _metaItem(
                        Icons.people_outline,
                        '${detail.servings} porsi',
                        _primaryColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  const Divider(color: Color(0xFFE8D8C8)),
                  const SizedBox(height: 14),

                  // Bahan-bahan
                  const Text(
                    'Bahan-Bahan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _brownColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...detail.ingredients.map(_buildIngredient),

                  const SizedBox(height: 22),

                  // Langkah pembuatan
                  const Text(
                    'Langkah Pembuatan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _brownColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    detail.steps.length,
                        (i) => _buildStep(i + 1, detail.steps[i]),
                  ),

                  // Tips (hanya tampil kalau ada)
                  if (detail.tip != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _tipColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _yellowColor),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: _primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              detail.tip!,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: _brownColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: ElevatedButton.icon(
            onPressed: () {
              if (onAddToMealPlan != null) {
                onAddToMealPlan!(recipe);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name ditambahkan ke Meal Plan')),
              );
            },
            icon: const Icon(Icons.calendar_today_outlined, size: 20),
            label: const Text('Tambah ke Meal Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(54),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _metaItem(IconData icon, String text, Color iconColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _brownColor,
          ),
        ),
      ],
    );
  }

  /// Teks berawalan '# ' ditampilkan sebagai sub-judul, selain itu bullet biasa.
  Widget _buildIngredient(String text) {
    if (text.startsWith('# ')) {
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        child: Text(
          text.substring(2),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.4,
                color: _brownColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: _yellowColor,
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _brownColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.45,
                  color: _brownColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}