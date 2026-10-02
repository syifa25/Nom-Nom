import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'loading_page.dart';

class CookingToolPage extends StatefulWidget {
  final int portions;
  final Set<String> selectedIngredients;

  const CookingToolPage({
    super.key,
    required this.portions,
    required this.selectedIngredients,
  });

  @override
  State<CookingToolPage> createState() => _CookingToolPageState();
}

class _CookingToolPageState extends State<CookingToolPage> {
  final Set<String> selectedTools = {};

  final List<Map<String, dynamic>> cookingTools = [
    {
      'name': 'Kompor',
      'icon': Icons.local_fire_department_rounded,
    },
    {
      'name': 'Wajan',
      'icon': Icons.soup_kitchen_rounded,
    },
    {
      'name': 'Panci',
      'icon': Icons.rice_bowl_rounded,
    },
    {
      'name': 'Oven',
      'icon': Icons.kitchen_rounded,
    },
    {
      'name': 'Rice Cooker',
      'icon': Icons.rice_bowl_outlined,
    },
    {
      'name': 'Blender',
      'icon': Icons.blender_rounded,
    },
    {
      'name': 'Pisau',
      'icon': Icons.content_cut_rounded,
    },
    {
      'name': 'Talenan',
      'icon': Icons.crop_square_rounded,
    },
    {
      'name': 'Spatula',
      'icon': Icons.restaurant_rounded,
    },
    {
      'name': 'Saringan',
      'icon': Icons.filter_alt_outlined,
    },
    {
      'name': 'Mangkuk',
      'icon': Icons.ramen_dining_rounded,
    },
    {
      'name': 'Sendok',
      'icon': Icons.restaurant_menu_rounded,
    },
  ];

  void toggleTool(String name) {
    setState(() {
      if (selectedTools.contains(name)) {
        selectedTools.remove(name);
      } else {
        selectedTools.add(name);
      }
    });
  }

  void createRecommendation() {
    if (selectedTools.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih minimal satu alat masak dulu ya 😊',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeLoadingPage(
          portions: widget.portions,
          selectedIngredients: widget.selectedIngredients,
          selectedTools: selectedTools,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Peralatan Dapur',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                8,
                24,
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Apa yang ada di dapurmu?',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pilih peralatan yang bisa kamu gunakan.',
                    style: TextStyle(
                      color: AppColors.textPrimary.withValues(
                        alpha: 0.60,
                      ),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  20,
                ),
                itemCount: cookingTools.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final tool = cookingTools[index];

                  return _buildToolCard(
                    name: tool['name'] as String,
                    icon: tool['icon'] as IconData,
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                20,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: createRecommendation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Buat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required String name,
    required IconData icon,
  }) {
    final bool isSelected = selectedTools.contains(name);

    return GestureDetector(
      onTap: () => toggleTool(name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.coral
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 48,
                    color: isSelected
                        ? AppColors.coral
                        : AppColors.textPrimary.withValues(
                            alpha: 0.65,
                          ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: AppColors.coral,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}