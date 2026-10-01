import 'package:flutter/material.dart';

import 'home_page.dart';
import '../chat_page.dart';
import '../favorite_page.dart';
import '../profile_page.dart';
import 'recipe_flow/recipe_flow_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // 0 = Beranda, 1 = Favorit, 2 = Chat AI, 3 = Profil
  int _index = 0;

  final List<Widget> _pages = [
    HomePage(),
    const FavoritPage(),
    const ChatPage(),
    const ProfilePage(),
  ];

  static const Color _orange = Color(0xFFD36327);
  static const Color _brown = Color(0xFF8B3E20);
  static const Color _cream = Color(0xFFFFF4E5);
  static const Color _navColor = Color(0xFFFFE7C2);

  void _onRecipeTap() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const RecipeFlowPage(),
    ),
  );
}
  Widget _navItem({
    required IconData icon,
    required int index,
    required String tooltip,
  }) {
    final bool selected = _index == index;

    return Expanded(
      child: IconButton(
        tooltip: tooltip,
        onPressed: () {
          setState(() => _index = index);
        },
        icon: Icon(
          icon,
          size: 29,
          color: selected ? _orange : _brown,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: _pages,
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: 96,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Navbar berbentuk kapsul
              Positioned(
                left: 16,
                right: 16,
                bottom: 8,
                child: Container(
                  height: 68,
                  decoration: BoxDecoration(
                    color: _navColor,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: _brown.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _navItem(
                        icon: _index == 0
                            ? Icons.home_rounded
                            : Icons.home_outlined,
                        index: 0,
                        tooltip: 'Beranda',
                      ),
                      _navItem(
                        icon: _index == 1
                            ? Icons.favorite
                            : Icons.favorite_border,
                        index: 1,
                        tooltip: 'Favorit',
                      ),

                      // Ruang kosong untuk tombol tengah
                      const SizedBox(width: 64),

                      _navItem(
                        icon: _index == 2
                            ? Icons.chat_bubble
                            : Icons.chat_bubble_outline,
                        index: 2,
                        tooltip: 'Chat AI',
                      ),
                      _navItem(
                        icon: _index == 3
                            ? Icons.person
                            : Icons.person_outline,
                        index: 3,
                        tooltip: 'Profil',
                      ),
                    ],
                  ),
                ),
              ),

              // Tombol utama rekomendasi masakan
              Positioned(
                top: 0,
                child: Material(
                  color: _orange,
                  shape: const CircleBorder(),
                  elevation: 6,
                  shadowColor: _brown.withValues(alpha: 0.3),
                  child: InkWell(
                    onTap: _onRecipeTap,
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 66,
                      height: 66,
                      child: Icon(
                        Icons.soup_kitchen_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
