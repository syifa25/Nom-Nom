import 'package:flutter/material.dart';
import 'package:nom_nom/service/meal_plan_service.dart';
import 'recipe_data.dart';
import 'package:nom_nom/features/center_notice.dart';

class RecipeDetailPage extends StatelessWidget {
  final Map<String, dynamic> recipe;

  /// Opsional: dipanggil setelah resep berhasil ditambahkan ke Meal Plan.
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
            onPressed: () => _showMealPlanSheet(context, name),
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

  void _showMealPlanSheet(BuildContext context, String name) {
    final today = dateOnly(DateTime.now());
    DateTime selectedDate = today;
    String selectedMeal = MealPlanService.mealTypes.first;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (innerContext, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambah ke Meal Plan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _brownColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 13, color: Colors.brown),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Pilih tanggal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _brownColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: innerContext,
                          initialDate: selectedDate,
                          firstDate: today,
                          lastDate: today.add(const Duration(days: 365)),
                          helpText: 'Pilih Tanggal Rencana Masak',
                          builder: (pickerContext, child) {
                            return Theme(
                              data: Theme.of(pickerContext).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: _primaryColor,
                                  onPrimary: Colors.white,
                                  surface: _backgroundColor,
                                  onSurface: _brownColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          setSheetState(() {
                            selectedDate = dateOnly(picked);
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE8D8C8)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: _primaryColor,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                formatMealDate(selectedDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _brownColor,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.edit_calendar_outlined,
                              color: _brownColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Waktu makan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _brownColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: MealPlanService.mealTypes.map((meal) {
                        final isSelected = meal == selectedMeal;
                        return ChoiceChip(
                          label: Text(meal),
                          selected: isSelected,
                          showCheckmark: false,
                          selectedColor: _primaryColor,
                          backgroundColor: _backgroundColor,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : _brownColor,
                          ),
                          onSelected: (_) {
                            setSheetState(() => selectedMeal = meal);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final added = MealPlanService.instance.add(
                            recipe: recipe,
                            date: selectedDate,
                            mealType: selectedMeal,
                          );
                          Navigator.pop(sheetContext);

                          if (added) {
                            onAddToMealPlan?.call(recipe);
                          }

                          final label = shortMealDate(selectedDate);
                          showCenterNotice(
                            context,
                            message: added
                                ? '$name ditambahkan ke rencana masak'
                                : '$name sudah ada di rencana masak',
                            icon: Icons.check_circle_rounded,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Simpan ke Meal Plan'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCenterMealPlanNotice(BuildContext context, String message) {
    final overlay = Overlay.of(context, rootOverlay: true);
    late OverlayEntry entry;

    const softOrangeBg = Color(0xFFFFE5D9);
    const softOrangeBorder = Color(0xFFFFB596);

    entry = OverlayEntry(
      builder: (overlayContext) {
        return IgnorePointer(
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: softOrangeBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: softOrangeBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: _brownColor.withValues(alpha: 0.14),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: _primaryColor.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: _primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: _brownColor,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (entry.mounted) {
        entry.remove();
      }
    });

    overlay.insert(entry);

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
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