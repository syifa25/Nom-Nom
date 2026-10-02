import 'package:flutter/material.dart';
import 'portion_page.dart';
import 'ingredient_page.dart';

class RecipeBuilderPage extends StatefulWidget {
  const RecipeBuilderPage({super.key});

  @override
  State<RecipeBuilderPage> createState() => _RecipeBuilderPageState();
}

class _RecipeBuilderPageState extends State<RecipeBuilderPage> {
  int portions = 1;

  void increasePortion() {
    if (portions >= 8) return;

    setState(() {
      portions++;
    });
  }

  void decreasePortion() {
    if (portions <= 1) return;

    setState(() {
      portions--;
    });
  }

  void nextToIngredients() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientPage(
          portions: portions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PortionPage(
        portions: portions,
        onMinus: decreasePortion,
        onPlus: increasePortion,
        onNext: nextToIngredients,
      ),
    );
  }
}