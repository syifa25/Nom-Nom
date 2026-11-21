import 'package:flutter/material.dart';
import 'package:nom_nom/service/meal_plan_service.dart';
import 'home/recipe_detail_page.dart';
import 'package:nom_nom/features/center_notice.dart';

class MealPlanPage extends StatelessWidget {
  const MealPlanPage({super.key});

  static const _backgroundColor = Color(0xFFFFF4E5);
  static const _primaryColor = Color(0xFFE66A3C);
  static const _brownColor = Color(0xFF8B3E20);
  static const _yellowColor = Color(0xFFFFC857);
  static const _chipColor = Color(0xFFFFE9B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: _brownColor,
        title: const Text(
          'Rencana Masak',
          style: TextStyle(fontWeight: FontWeight.bold, color: _brownColor),
        ),
      ),
      body: AnimatedBuilder(
        animation: MealPlanService.instance,
        builder: (context, _) {
          final entries = MealPlanService.instance.entries;

          if (entries.isEmpty) {
            return _buildEmptyState();
          }

          // Susun daftar: header tanggal, lalu kartu-kartu di bawahnya
          final children = <Widget>[];
          DateTime? lastDate;

          for (final entry in entries) {
            if (lastDate == null || lastDate != entry.date) {
              children.add(
                Padding(
                  padding: EdgeInsets.only(
                    top: lastDate == null ? 0 : 18,
                    bottom: 10,
                  ),
                  child: Text(
                    formatMealDate(entry.date),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _brownColor,
                    ),
                  ),
                ),
              );
              lastDate = entry.date;
            }
            children.add(_buildEntry(context, entry));
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: children,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_rounded, size: 64, color: _primaryColor),
            SizedBox(height: 16),
            Text(
              'Belum Ada Rencana Masak',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _brownColor,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Buka detail resep lalu tekan "Tambah ke Meal Plan" untuk mulai merencanakan menu masakmu.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.brown),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntry(BuildContext context, MealPlanEntry entry) {
    final recipe = entry.recipe;
    final imagePath = recipe['image'] as String? ?? '';
    final time = recipe['time'] as String? ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RecipeDetailPage(recipe: recipe),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8D8C8)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 64,
                    height: 64,
                    color: _yellowColor,
                    child: const Icon(Icons.restaurant, color: _brownColor),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.recipeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _brownColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _chipColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _yellowColor),
                        ),
                        child: Text(
                          entry.mealType,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _brownColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: _primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Hapus dari Meal Plan',
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                MealPlanService.instance.remove(entry.id);
                showCenterNotice(
                  context,
                  message: '${entry.recipeName} dihapus dari rencana masak',
                  icon: Icons.delete_outline_rounded,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}