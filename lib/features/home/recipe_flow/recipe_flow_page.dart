
import 'package:flutter/material.dart';

class RecipeFlowPage extends StatelessWidget {
  const RecipeFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi Masakan'),
      ),
      body: const Center(
        child: Text('Halaman alur rekomendasi masakan'),
      ),
    );
  }
}
