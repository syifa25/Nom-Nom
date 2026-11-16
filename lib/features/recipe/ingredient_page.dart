
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static const String _storageKey = 'nomnom_custom_ingredients';

  bool isLoading = true;

  List<Map<String, String>> ingredients = [
    {'name': 'Ayam', 'image': 'assets/ingredients/ayam.png'},
    {'name': 'Telur', 'image': 'assets/ingredients/telur.png'},
    {'name': 'Daging Sapi', 'image': 'assets/ingredients/daging.png'},
    {'name': 'Ikan', 'image': 'assets/ingredients/ikan.png'},
    {'name': 'Udang', 'image': 'assets/ingredients/udang.png'},
    {'name': 'Tahu', 'image': 'assets/ingredients/tahu.png'},
    {'name': 'Tempe', 'image': 'assets/ingredients/tempe.png'},
    {'name': 'Wortel', 'image': 'assets/ingredients/wortel.png'},
    {'name': 'Kentang', 'image': 'assets/ingredients/kentang.png'},
    {'name': 'Tomat', 'image': 'assets/ingredients/tomat.png'},
    {'name': 'Bawang', 'image': 'assets/ingredients/bawang.png'},
    {'name': 'Cabai', 'image': 'assets/ingredients/cabai.png'},
  ];

  List<Map<String, String>> customIngredients = [];

  final List<String> categories = [
    'Sayuran',
    'Daging',
    'Seafood',
    'Buah',
    'Bumbu',
    'Karbohidrat',
    'Produk Susu',
    'Lainnya',
  ];

  final Map<String, IconData> categoryIcons = {
    'Sayuran': Icons.eco_rounded,
    'Daging': Icons.set_meal_rounded,
    'Seafood': Icons.phishing_rounded,
    'Buah': Icons.apple_rounded,
    'Bumbu': Icons.spa_rounded,
    'Karbohidrat': Icons.grass_rounded,
    'Produk Susu': Icons.local_drink_rounded,
    'Lainnya': Icons.restaurant_rounded,
  };

  @override
  void initState() {
    super.initState();
    _loadCustomIngredients();
  }

  Future<void> _loadCustomIngredients() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_storageKey);

      if (savedData != null) {
        final List<dynamic> decodedData = jsonDecode(savedData);

        customIngredients = decodedData.map((item) {
          return Map<String, String>.from(item);
        }).toList();
      }
    } catch (e) {
      debugPrint('Gagal memuat bahan: $e');
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveCustomIngredients() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _storageKey,
      jsonEncode(customIngredients),
    );
  }

  List<Map<String, String>> get allIngredients {
    return [
      ...ingredients,
      ...customIngredients,
    ];
  }

  IconData _getCategoryIcon(String category) {
    return categoryIcons[category] ?? Icons.restaurant_rounded;
  }

  void toggleIngredient(String name) {
    setState(() {
      if (selectedIngredients.contains(name)) {
        selectedIngredients.remove(name);
      } else {
        selectedIngredients.add(name);
      }
    });
  }

  Widget _buildAddCard() {
    return GestureDetector(
      onTap: _showAddIngredientModal,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.coral.withValues(alpha: 0.4),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.coral,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tambah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.coral,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddIngredientModal() {
    final nameController = TextEditingController();
    String selectedCategory = 'Sayuran';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tambah Bahan Makanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nama Bahan',
                      hintText: 'Contoh: Brokoli',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategori Bahan',
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Row(
                          children: [
                            Icon(
                              _getCategoryIcon(category),
                              color: AppColors.coral,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(category),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final name = nameController.text.trim();

                        if (name.isEmpty) {
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Nama bahan wajib diisi'),
                            ),
                          );
                          return;
                        }

                        final isDuplicate = allIngredients.any(
                          (item) =>
                              (item['name'] ?? '').toLowerCase() ==
                              name.toLowerCase(),
                        );

                        if (isDuplicate) {
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Bahan sudah tersedia'),
                            ),
                          );
                          return;
                        }

                        final newIngredient = {
                          'name': name,
                          'image': '',
                          'category': selectedCategory,
                        };

                        setState(() {
                          customIngredients.add(newIngredient);
                        });

                        try {
                          await _saveCustomIngredients();

                          if (!mounted) return;

                          Navigator.pop(sheetContext);

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$name berhasil ditambahkan',
                              ),
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;

                          setState(() {
                            customIngredients.remove(newIngredient);
                          });

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Gagal menyimpan bahan. Silakan coba lagi.',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Simpan Bahan',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      nameController.dispose();
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
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.coral,
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        20,
                      ),
                      itemCount: allIngredients.length + 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (context, index) {
                        if (index == allIngredients.length) {
                          return _buildAddCard();
                        }

                        final ingredient = allIngredients[index];

                        return _buildIngredientCard(
                          name: ingredient['name'] ?? '',
                          image: ingredient['image'] ?? '',
                          category: ingredient['category'] ?? '',
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
    String category = '',
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
                      child: category.isNotEmpty
                          ? Icon(
                              _getCategoryIcon(category),
                              size: 48,
                              color: AppColors.coral.withValues(
                                alpha: 0.7,
                              ),
                            )
                          : image.isEmpty
                              ? Icon(
                                  Icons.fastfood_rounded,
                                  size: 48,
                                  color: AppColors.coral.withValues(
                                    alpha: 0.7,
                                  ),
                                )
                              : Image.asset(
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
