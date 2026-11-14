
import 'package:supabase_flutter/supabase_flutter.dart';

class AiRecipeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> generateRecipes({
    required Set<String> ingredients,
    required Set<String> tools,
    required int portions,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'generate-recipes',
        body: {
          'ingredients': ingredients.toList(),
          'tools': tools.toList(),
          'portions': portions,
        },
      );

      if (response.status != 200) {
        throw Exception('Gagal membuat rekomendasi resep.');
      }

      final result = response.data;

      if (result == null || result['success'] != true) {
        throw Exception(
          result?['error'] ?? 'AI gagal menghasilkan resep.',
        );
      }

      final data = result['data'];
      final recipes = data?['recipes'];

      if (recipes is! List || recipes.isEmpty) {
        throw Exception('AI tidak menghasilkan daftar resep.');
      }

      return recipes
          .map<Map<String, dynamic>>(
            (recipe) => Map<String, dynamic>.from(recipe),
          )
          .toList();
    } on FunctionException catch (e) {
      throw Exception(
        'Gagal menghubungi AI (${e.status}): ${e.details}',
      );
    } catch (e) {
      throw Exception(
        'Terjadi kesalahan: ${e.toString()}',
      );
    }
  }
}
