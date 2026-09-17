import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const NomNomApp());
}

class NomNomApp extends StatelessWidget {
  const NomNomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_nomnom.png',
              width: 250,
            ),

            const SizedBox(height: 20),

            const Text(
              'Masak jadi lebih mudah',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5C2818),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        currentIndex: 0,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorit',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'Chat AI',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFF4E5),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    'Hai, Budi!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color(0xFFE66A3C),
                    width: 1.5,
                  ),
                ),

                child: const Row(
                  children: [
                    SizedBox(width: 15),

                    Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),

                    SizedBox(width: 10),

                    Text(
                      'Cari resep atau bahan masakan...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Rekomendasi Chef AI',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B3E20),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: const Icon(
                        Icons.restaurant,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Ayam Panggang Bumbu Rujak',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      '⭐ 4.8     ⏱ 35 menit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Berdasarkan stok bahan Anda: Ayam, Cabai, Tomat',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Kategori Masakan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  categoryItem(
                    Icons.restaurant,
                    'Nusantara',
                  ),

                  categoryItem(
                    Icons.timer,
                    'Cepat Saji',
                  ),

                  categoryItem(
                    Icons.eco,
                    'Sehat',
                  ),

                  categoryItem(
                    Icons.local_drink,
                    'Minuman',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget categoryItem(IconData icon, String title) {
  return Column(
    children: [
      CircleAvatar(
        radius: 28,
        backgroundColor: const Color(0xFFFFC857),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),

      const SizedBox(height: 6),

      Text(
        title,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    ],
  );
}