import 'package:flutter/material.dart';
import 'package:nom_nom/service/auth_service.dart';
import 'recipe_detail_page.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteRecipes;
  final Function(Map<String, dynamic>) onToggleFavorite;

  const HomePage({
    super.key,
    this.favoriteRecipes = const [],
    required this.onToggleFavorite,
  });

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
  ];

  final List<Map<String, dynamic>> recipes = [
    {'name': 'Nasi Goreng', 'category': 'Makanan utama', 'time': '20 menit', 'rating': '4.8', 'image': 'assets/Menu/nasi_goreng.jpg', 'description': 'Nasi goreng dengan bumbu gurih dan aroma khas kecap manis, cocok disajikan dengan telur dan pelengkap favorit.'},
    {'name': 'Mie Goreng', 'category': 'Makanan utama', 'time': '20 menit', 'rating': '4.7', 'image': 'assets/Menu/mie_goreng.jpg', 'description': 'Mie yang ditumis bersama bumbu pilihan, sayuran, dan pelengkap sehingga menghasilkan rasa gurih yang nikmat.'},
    {'name': 'Ayam Goreng', 'category': 'Makanan utama', 'time': '35 menit', 'rating': '4.8', 'image': 'assets/Menu/ayam_goreng.jpg', 'description': 'Potongan ayam berbumbu yang digoreng hingga matang dengan bagian luar renyah dan bagian dalam tetap juicy.'},
    {'name': 'Ayam Bakar', 'category': 'Makanan utama', 'time': '45 menit', 'rating': '4.9', 'image': 'assets/Menu/ayam_bakar.jpg', 'description': 'Ayam yang dimarinasi dengan bumbu rempah lalu dibakar hingga harum dengan rasa manis dan gurih.'},
    {'name': 'Rendang', 'category': 'Makanan utama', 'time': '90 menit', 'rating': '4.9', 'image': 'assets/Menu/rendang.jpg', 'description': 'Hidangan daging sapi khas Minang yang dimasak perlahan bersama santan dan rempah hingga bumbunya meresap.'},
    {'name': 'Soto Ayam', 'category': 'Makanan utama', 'time': '40 menit', 'rating': '4.8', 'image': 'assets/Menu/soto_ayam.jpg', 'description': 'Sup ayam berkuah kuning dengan aroma rempah yang segar, biasanya disajikan bersama soun, telur, dan pelengkap.'},
    {'name': 'Bakso', 'category': 'Makanan utama', 'time': '30 menit', 'rating': '4.7', 'image': 'assets/Menu/bakso.jpg', 'description': 'Bola daging sapi bertekstur kenyal yang disajikan dengan kuah kaldu hangat, mie, dan sayuran.'},
    {'name': 'Seblak', 'category': 'Camilan', 'time': '25 menit', 'rating': '4.8', 'image': 'assets/Menu/seblak.jpg', 'description': 'Hidangan bercita rasa pedas dengan kerupuk kenyal, telur, sayuran, dan bumbu kencur yang khas.'},
    {'name': 'Capcay', 'category': 'Makanan utama', 'time': '25 menit', 'rating': '4.7', 'image': 'assets/Menu/capcay.jpg', 'description': 'Tumis aneka sayuran dengan tambahan ayam dan saus gurih, cocok untuk menu sehari-hari.'},
    {'name': 'Sayur Asem', 'category': 'Makanan utama', 'time': '30 menit', 'rating': '4.6', 'image': 'assets/Menu/sayur_asem.jpg', 'description': 'Sayur berkuah bening dengan rasa asam dan segar, berisi aneka sayuran seperti jagung, labu siam, dan kacang panjang.'},
    {'name': 'Gado-Gado', 'category': 'Makanan utama', 'time': '25 menit', 'rating': '4.8', 'image': 'assets/Menu/gado_gado.jpg', 'description': 'Salad khas Indonesia berisi sayuran, tahu, tempe, dan telur yang disiram saus kacang gurih.'},
    {'name': 'Kwetiau Goreng', 'category': 'Makanan utama', 'time': '25 menit', 'rating': '4.7', 'image': 'assets/Menu/kwetiau_goreng.jpg', 'description': 'Kwetiau yang ditumis dengan telur, sayuran, dan pilihan protein menggunakan bumbu gurih manis.'},
    {'name': 'Spaghetti Bolognese', 'category': 'Makanan utama', 'time': '30 menit', 'rating': '4.8', 'image': 'assets/Menu/spaghetti_bolognese.jpg', 'description': 'Spaghetti yang disajikan dengan saus tomat dan daging sapi cincang berbumbu ala Italia.'},
    {'name': 'Macaroni Schotel', 'category': 'Makanan utama', 'time': '45 menit', 'rating': '4.9', 'image': 'assets/Menu/macaroni_schotel.jpg', 'description': 'Olahan makaroni panggang yang dicampur susu, telur, keju, dan isian gurih hingga lembut di dalam.'},
    {'name': 'Pancake', 'category': 'Sarapan', 'time': '15 menit', 'rating': '4.9', 'image': 'assets/Menu/pancake.jpg', 'description': 'Kue dadar tebal dan lembut dengan rasa manis, cocok disajikan bersama madu, sirup, atau buah segar.'},
    {'name': 'French Toast', 'category': 'Sarapan', 'time': '15 menit', 'rating': '4.7', 'image': 'assets/Menu/french_toast.jpg', 'description': 'Roti tawar yang dicelup campuran telur dan susu lalu dipanggang hingga keemasan, lembut di dalam.'},
    {'name': 'Omelet', 'category': 'Sarapan', 'time': '10 menit', 'rating': '4.7', 'image': 'assets/Menu/omelet.jpg', 'description': 'Telur dadar lembut yang dapat dipadukan dengan keju, tomat, bawang, dan bahan isian lainnya.'},
    {'name': 'Sup Ayam', 'category': 'Makanan utama', 'time': '35 menit', 'rating': '4.8', 'image': 'assets/Menu/sup_ayam.jpg', 'description': 'Sup hangat berisi ayam, wortel, dan kentang dalam kuah kaldu ringan dengan aroma rempah.'},
    {'name': 'Tumis Kangkung', 'category': 'Makanan utama', 'time': '15 menit', 'rating': '4.6', 'image': 'assets/Menu/tumis_kangkung.jpg', 'description': 'Kangkung yang ditumis cepat bersama bawang dan cabai sehingga tetap renyah dengan rasa gurih.'},
    {'name': 'Pisang Goreng', 'category': 'Camilan', 'time': '15 menit', 'rating': '4.7', 'image': 'assets/Menu/pisang_goreng.jpg', 'description': 'Pisang matang berbalut adonan tepung yang digoreng hingga keemasan dan renyah, nikmat disantap hangat.'},
  ];

  List<Map<String, dynamic>> get filteredRecipes {
    return recipes.where((recipe) {
      final matchesCategory =
          selectedCategory == 'Semua' || recipe['category'] == selectedCategory;

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
              // Sapaan pengguna
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: yellowColor,
                    child: Icon(Icons.person, color: brownColor, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // displayName sudah pasti berisi teks (tidak null),
                        // dan currentUserName sudah tidak ada di AuthService baru
                        'Hai, ${AuthService.instance.displayName}!',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: brownColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Mau masak apa hari ini?',
                        style: TextStyle(fontSize: 13, color: Colors.brown),
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
                  border: Border.all(color: primaryColor, width: 1.5),
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
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: primaryColor),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Kategori Masakan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: brownColor,
                ),
              ),

              const SizedBox(height: 12),

              // ChoiceChips kategori
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
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
                        color: isSelected ? primaryColor : const Color(0xFFE8D8C8),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

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
                    style: const TextStyle(color: Colors.brown, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Daftar resep
              Expanded(
                child: filteredRecipes.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off, size: 55, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        'Resep tidak ditemukan',
                        style: TextStyle(color: brownColor, fontSize: 15),
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
                    final isFav = widget.favoriteRecipes.any(
                          (item) => item['name'] == recipe['name'],
                    );

                    return GestureDetector(
                      // (onTemplateTap dihapus: parameter itu tidak ada di Flutter)
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipe: recipe,
                            ),
                          ),
                        );
                      },
                      child: Container(
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
                                    recipe['image'] as String,
                                    width: double.infinity,
                                    height: 145,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 145,
                                        width: double.infinity,
                                        color: yellowColor.withValues(alpha: 0.35),
                                        child: const Icon(
                                          Icons.restaurant,
                                          size: 65,
                                          color: brownColor,
                                        ),
                                      );
                                    },
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
                                      const SizedBox(height: 6),
                                      Text(
                                        recipe['description'] as String,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          height: 1.4,
                                          color: Colors.brown,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
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
                                            style: const TextStyle(fontSize: 12),
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
                                            style: const TextStyle(fontSize: 12),
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

                            // Tombol hati favorit
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  widget.onToggleFavorite(recipe);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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