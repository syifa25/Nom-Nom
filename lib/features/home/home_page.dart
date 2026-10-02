import 'package:flutter/material.dart';
import 'package:nom_nom/service/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = 'Semua';
  String searchQuery = '';

  final List<String> categories = [
    'Semua',
    'Sarapan',
    'Makanan utama',
    'Camilan',
    'Dessert',
    'Minuman',
  ];

  final List<Map<String, dynamic>> recipes = [
    {
      'name': 'Nasi Goreng',
      'category': 'Makanan utama',
      'time': '20 menit',
      'rating': '4.8',
      'icon': Icons.rice_bowl,
    },
    {
      'name': 'Pancake',
      'category': 'Sarapan',
      'time': '15 menit',
      'rating': '4.9',
      'icon': Icons.breakfast_dining,
    },
    {
      'name': 'Pisang Goreng',
      'category': 'Camilan',
      'time': '15 menit',
      'rating': '4.7',
      'icon': Icons.cookie,
    },
    {
      'name': 'Brownies Cokelat',
      'category': 'Dessert',
      'time': '40 menit',
      'rating': '4.9',
      'icon': Icons.cake,
    },
    {
      'name': 'Jus Alpukat',
      'category': 'Minuman',
      'time': '10 menit',
      'rating': '4.8',
      'icon': Icons.local_drink,
    },
    {
      'name': 'Nasi Uduk',
      'category': 'Sarapan',
      'time': '30 menit',
      'rating': '4.7',
      'icon': Icons.restaurant,
    },
    {
      'name': 'Ayam Kecap',
      'category': 'Makanan utama',
      'time': '35 menit',
      'rating': '4.8',
      'icon': Icons.dinner_dining,
    },
  ];

  List<Map<String, dynamic>> get filteredRecipes {
    return recipes.where((recipe) {
      final matchesCategory = selectedCategory == 'Semua' ||
          recipe['category'] == selectedCategory;

      final matchesSearch = recipe['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sapaan pengguna (Dinamis mengambil data dari AuthService)
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: yellowColor,
                    child: Icon(
                      Icons.person,
                      color: brownColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hai, ${AuthService.instance.currentUserName ?? 'User'}!',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: brownColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Mau masak apa hari ini?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Pencarian resep
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: primaryColor,
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari resep atau bahan masakan...',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: primaryColor,
                    ),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          searchQuery = '';
                        });
                      },
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Judul kategori
              const Text(
                'Kategori Masakan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: brownColor,
                ),
              ),

              const SizedBox(height: 12),

              // Kategori bisa digeser ke samping
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;

                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : brownColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? primaryColor
                            : const Color(0xFFE8D8C8),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

              // Judul daftar resep
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Rekomendasi Masakan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: brownColor,
                      ),
                    ),
                  ),
                  Text(
                    '${filteredRecipes.length} resep',
                    style: const TextStyle(
                      color: Colors.brown,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Daftar resep mengikuti kategori dan pencarian
              Expanded(
                child: filteredRecipes.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 55,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Resep tidak ditemukan',
                        style: TextStyle(
                          color: brownColor,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Coba kategori atau kata kunci lain.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: filteredRecipes.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE8D8C8),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 145,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: yellowColor.withValues(
                                alpha: 0.35,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            child: Icon(
                              recipe['icon'] as IconData,
                              size: 65,
                              color: brownColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: brownColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 17,
                                      color: yellowColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      recipe['rating'] as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      recipe['time'] as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        recipe['category'] as String,
                                        style: const TextStyle(
                                          color: brownColor,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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