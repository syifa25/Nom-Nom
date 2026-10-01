import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import '../theme/app_colors.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userName = AuthService.instance.currentUserName ?? 'Pengguna NomNom';
    final userEmail = AuthService.instance.currentUserEmail ?? 'email@domain.com';
    final initialLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Circle Avatar Sesuai Inisial Nama User
              CircleAvatar(
                radius: 45,
                backgroundColor: const Color(0xFFD36327),
                child: Text(
                  initialLetter,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Nama & Email Dinamis
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              // Card Statistik (18 Favorit | 42 Resep Dicoba | 7 Hari Berturut)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('18', 'Favorit'),
                    _buildStatItem('42', 'Resep Dicoba'),
                    _buildStatItem('7', 'Hari Berturut'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // List Menu Pilihan (Preferensi Diet & Resep Pribadi Sudah Dihapus)
              _buildMenuItem(
                Icons.calendar_month_rounded,
                'Rencana Masak (Meal Plan)',
                const Color(0xFF6C8EBF),
                onTap: () {
                  // Aksi untuk membuka Rencana Masak
                },
              ),
              _buildMenuItem(
                Icons.settings_outlined,
                'Pengaturan Akun',
                const Color(0xFF9E9E9E),
              ),
              _buildMenuItem(
                Icons.help_outline_rounded,
                'Bantuan',
                const Color(0xFFE53935),
              ),
              _buildMenuItem(
                Icons.door_sliding_outlined,
                'Keluar',
                const Color(0xFFD36327),
                isLogout: true,
                onTap: () {
                  AuthService.instance.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD36327),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
      IconData icon,
      String title,
      Color iconColor, {
        bool isLogout = false,
        VoidCallback? onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor, size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isLogout ? const Color(0xFFD36327) : Colors.black87,
          ),
        ),
      ),
    );
  }
}