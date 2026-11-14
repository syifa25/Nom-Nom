
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../service/ai_recipe_service.dart';
import 'recommendation_page.dart';

class RecipeLoadingPage extends StatefulWidget {
  final int portions;
  final Set<String> selectedIngredients;
  final Set<String> selectedTools;

  const RecipeLoadingPage({
    super.key,
    required this.portions,
    required this.selectedIngredients,
    required this.selectedTools,
  });

  @override
  State<RecipeLoadingPage> createState() =>
      _RecipeLoadingPageState();
}

class _RecipeLoadingPageState extends State<RecipeLoadingPage> {
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    generateRecipes();
  }

  Future<void> generateRecipes() async {
    try {
      final recipes = await AiRecipeService().generateRecipes(
        ingredients: widget.selectedIngredients,
        tools: widget.selectedTools,
        portions: widget.portions,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendationPage(
            portions: widget.portions,
            selectedIngredients: widget.selectedIngredients,
            selectedTools: widget.selectedTools,
            recipes: recipes,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/loading_nomnom.png',
                  width: 190,
                  height: 190,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 35),

                Text(
                  errorMessage == null
                      ? 'Sedang membuat\nrekomendasi untukmu...'
                      : 'Yah, rekomendasi gagal dibuat',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  errorMessage ??
                      'Nom-Nom AI sedang mencari resep terbaik 🍳',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary.withValues(
                      alpha: 0.60,
                    ),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                if (errorMessage == null)
                  const SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.coral,
                    ),
                  )
                else ...[
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        errorMessage = null;
                      });
                      generateRecipes();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coral,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
