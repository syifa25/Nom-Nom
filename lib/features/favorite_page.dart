import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FavoritPage extends StatelessWidget {
  const FavoritPage({super.key});

  static const _favorites = [
    {'name': 'Nasi Goreng Kampung', 'meta': '20 menit · mudah'},
    {'name': 'Soto Ayam', 'meta': '45 menit · sedang'},
    {'name': 'Perkedel Kentang', 'meta': '25 menit · mudah'},
    {'name': 'Ayam Bakar Rujak', 'meta': '30 menit · sedang'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resep Favorit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _favorites.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final item = _favorites[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border:
                  Border.all(color: AppColors.textSecondary.withOpacity(0.12)),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: AppColors.cream,
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(14)),
                          ),
                          child: const Icon(Icons.restaurant,
                              color: AppColors.amber, size: 28),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name']!,
                                  style: const TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(
                                item['meta']!,
                                style: const TextStyle(
                                    fontSize: 10, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite,
                            color: AppColors.coral, size: 14),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
