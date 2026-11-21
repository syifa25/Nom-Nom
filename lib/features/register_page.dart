import 'package:flutter/material.dart';
import 'package:nom_nom/features/center_notice.dart';
import 'package:nom_nom/features/home/main_navigation.dart';
import 'package:nom_nom/service/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  static const _backgroundColor = Color(0xFFFFF4E5);
  static const _primaryColor = Color(0xFFE66A3C);
  static const _brownColor = Color(0xFF8B3E20);

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showCenterNotice(
        context,
        message: 'Semua kolom wajib diisi',
        icon: Icons.error_outline_rounded,
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      showCenterNotice(
        context,
        message: 'Format email tidak valid',
        icon: Icons.error_outline_rounded,
      );
      return;
    }

    if (password.length < 6) {
      showCenterNotice(
        context,
        message: 'Password minimal 6 karakter',
        icon: Icons.error_outline_rounded,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AuthService.instance.register(
        name: name,
        email: email,
        password: password,
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (response.session == null) {
        Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 250));
        if (!context.mounted) return;
        showCenterNotice(
          context,
          message: 'Registrasi berhasil. Cek email untuk verifikasi akun',
          icon: Icons.mark_email_read_outlined,
        );
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const MainNavigation(),
        ),
            (route) => false,
      );

      await Future.delayed(const Duration(milliseconds: 250));
      if (!context.mounted) return;
      showCenterNotice(
        context,
        message: 'Akun berhasil dibuat. Selamat datang di NomNom!',
        icon: Icons.check_circle_rounded,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      showCenterNotice(
        context,
        message: e.message,
        icon: Icons.error_outline_rounded,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      showCenterNotice(
        context,
        message: 'Registrasi gagal. Silakan coba lagi',
        icon: Icons.error_outline_rounded,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: _brownColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.soup_kitchen,
                size: 70,
                color: _primaryColor,
              ),
              const SizedBox(height: 12),
              const Text(
                'Buat Akun NomNom',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _brownColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Daftar untuk menyimpan dan mencari resep favorit',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.brown),
              ),
              const SizedBox(height: 28),

              // Field Nama
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(Icons.person, color: _primaryColor),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Field Email
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: _primaryColor),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Field Password
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Min. 6 karakter',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    prefixIcon: Icon(Icons.lock, color: _primaryColor),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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