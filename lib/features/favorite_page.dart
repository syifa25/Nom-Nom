import 'package:flutter/material.dart';

class FavoritPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteRecipes;
  final Function(Map<String, dynamic>)? onRemoveFavorite;

  const FavoritPage({
    super.key,
    this.favoriteRecipes = const [],
    this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFF4E5);
    const primaryColor = Color(0xFFE66A3C);
    const brownColor = Color(0xFF8B3E20);
    const yellowColor = Color(0xFFFFC857);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resep Favorit',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: brownColor,
                ),
              ),
              const SizedBox(height: 16),

              // Jika Belum Ada Favorit (Empty State)
              if (favoriteRecipes.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            size: 60,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum Ada Resep Favorit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: brownColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tandai resep favoritmu dengan menekan ikon hati di halaman Beranda.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
              // Jika Ada Resep Favorit
                Expanded(
                  child: GridView.builder(
                    itemCount: favoriteRecipes.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final item = favoriteRecipes[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE8D8C8)),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: Image.asset(
                                    item['image'] as String? ?? '',
                                    height: 95,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        height: 95,
                                        width: double.infinity,
                                        color: yellowColor.withValues(alpha: 0.35),
                                        child: const Icon(
                                          Icons.restaurant,
                                          color: brownColor,
                                          size: 40,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'] ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: brownColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item['time']} · ${item['rating']} ★',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.brown,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  if (onRemoveFavorite != null) {
                                    onRemoveFavorite!(item);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: primaryColor,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}