import 'package:flutter/material.dart';


import '../../theme/app_colors.dart';
import 'cooking_tool_page.dart';

class IngredientPage extends StatefulWidget {
  final int portions;

  const IngredientPage({
    super.key,
    required this.portions,
  });

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  final Set<String> selectedIngredients = {};

  final List<Map<String, String>> ingredients = [
    {
      'name': 'Ayam',
      'image': 'assets/ingredients/ayam.png',
    },
    {
      'name': 'Telur',
      'image': 'assets/ingredients/telur.png',
    },
    {
      'name': 'Daging Sapi',
      'image': 'assets/ingredients/daging.jpeg',
    },
    {
      'name': 'Ikan',
      'image': 'assets/ingredients/ikan.jpeg',
    },
    {
      'name': 'Udang',
      'image': 'assets/ingredients/udang.jpeg',
    },
    {
      'name': 'Tahu',
      'image': 'assets/ingredients/tahu.png',
    },
    {
      'name': 'Tempe',
      'image': 'assets/ingredients/tempe.png',
    },
    {
      'name': 'Wortel',
      'image': 'assets/ingredients/wortel.png',
    },
    {
      'name': 'Kentang',
      'image': 'assets/ingredients/kentang.png',
    },
    {
      'name': 'Tomat',
      'image': 'assets/ingredients/tomat.png',
    },
    {
      'name': 'Bawang',
      'image': 'assets/ingredients/bawang.png',
    },
    {
      'name': 'Cabai',
      'image': 'assets/ingredients/cabai.png',
    },
  ];

  void toggleIngredient(String name) {
    setState(() {
      if (selectedIngredients.contains(name)) {
        selectedIngredients.remove(name);
      } else {
        selectedIngredients.add(name);
      }
    });
  }

  void nextPage() {
    if (selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih minimal satu bahan dulu ya 😊',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CookingToolPage(
            portions: widget.portions,
            selectedIngredients: selectedIngredients,
          );
        },
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
          'Bahan yang Tersedia',
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
                    'Apa saja bahan yang kamu punya?',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pilih bahan yang tersedia di dapurmu.',
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
                itemCount: ingredients.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final ingredient = ingredients[index];

                  return _buildIngredientCard(
                    name: ingredient['name']!,
                    image: ingredient['image']!,
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
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Berikutnya',
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

  Widget _buildIngredientCard({
    required String name,
    required String image,
  }) {
    final bool isSelected = selectedIngredients.contains(name);

    return GestureDetector(
      onTap: () => toggleIngredient(name),
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        image,
                        fit: BoxFit.contain,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return Icon(
                            Icons.fastfood_rounded,
                            size: 48,
                            color: AppColors.coral.withValues(
                              alpha: 0.7,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4,
                      right: 4,
                      bottom: 12,
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