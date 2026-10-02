import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
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
  State<RecipeLoadingPage> createState() => _RecipeLoadingPageState();
}

class _RecipeLoadingPageState extends State<RecipeLoadingPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(
      const Duration(seconds: 4),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecommendationPage(
              portions: widget.portions,
              selectedIngredients: widget.selectedIngredients,
              selectedTools: widget.selectedTools,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
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

                const Text(
                  'Sedang membuat\nrekomendasi untukmu...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  'Tunggu sebentar ya 🍳',
                  style: TextStyle(
                    color: AppColors.textPrimary.withValues(
                      alpha: 0.60,
                    ),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                const SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.coral,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}