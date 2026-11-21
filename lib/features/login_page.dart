import 'package:flutter/material.dart';
import 'package:nom_nom/features/center_notice.dart';
import 'package:nom_nom/features/home/main_navigation.dart';
import 'package:nom_nom/service/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  static const _backgroundColor = Color(0xFFFFF4E5);
  static const _primaryColor = Color(0xFFE66A3C);
  static const _brownColor = Color(0xFF8B3E20);

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showCenterNotice(
        context,
        message: 'Email dan password wajib diisi',
        icon: Icons.error_outline_rounded,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.instance.login(
        email: email,
        password: password,
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      final displayName = AuthService.instance.currentUserName ?? 'Pengguna';

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );

      await Future.delayed(const Duration(milliseconds: 250));
      if (!context.mounted) return;
      showCenterNotice(
        context,
        message: 'Selamat datang kembali, $displayName',
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
        message: 'Gagal masuk. Periksa koneksi atau akunmu',
        icon: Icons.error_outline_rounded,
      );
    }
  }

  void _showForgotPasswordDialog() {
    final resetEmailController = TextEditingController(
      text: _emailController.text.trim(),
    );
    bool isSending = false;

    showDialog(
      context: context,
      barrierDismissible: !isSending,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (innerContext, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Lupa Password',
                style: TextStyle(
                  color: _brownColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Masukkan email akunmu untuk menerima tautan reset password.',
                    style: TextStyle(fontSize: 13, color: Colors.brown),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: resetEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed:
                  isSending ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isSending
                      ? null
                      : () async {
                    final email = resetEmailController.text.trim();
                    if (email.isEmpty) {
                      showCenterNotice(
                        context,
                        message: 'Masukkan email terlebih dahulu',
                        icon: Icons.error_outline_rounded,
                      );
                      return;
                    }

                    setDialogState(() => isSending = true);

                    try {
                      await AuthService.instance
                          .sendPasswordResetEmail(email);
                      if (!mounted) return;
                      Navigator.pop(dialogContext);
                      showCenterNotice(
                        context,
                        message: 'Tautan reset password dikirim ke email',
                        icon: Icons.check_circle_rounded,
                      );
                    } on AuthException catch (e) {
                      if (!mounted) return;
                      setDialogState(() => isSending = false);
                      showCenterNotice(
                        context,
                        message: e.message,
                        icon: Icons.error_outline_rounded,
                      );
                    } catch (_) {
                      if (!mounted) return;
                      setDialogState(() => isSending = false);
                      showCenterNotice(
                        context,
                        message: 'Gagal mengirim tautan reset password',
                        icon: Icons.error_outline_rounded,
                      );
                    }
                  },
                  child: Text(isSending ? 'Mengirim...' : 'Kirim'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // --- LOGO IKON DISAMAKAN DENGAN SIGN UP ---
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: _primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.soup_kitchen_rounded,
                      size: 40,
                      color: _primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Judul Halaman
              const Text(
                'Selamat Datang di NomNom',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _brownColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Masuk dan temukan makanan favoritmu.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Kotak Input Email
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: Icon(Icons.email_outlined, color: _primaryColor),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Kotak Input Password
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: Icon(Icons.lock_outline, color: _primaryColor),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _isLoading ? null : _showForgotPasswordDialog,
                  child: const Text(
                    'Lupa password?',
                    style: TextStyle(
                      color: _brownColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Masuk
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tautan ke Halaman Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun? ',
                    style: TextStyle(color: Colors.brown, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        color: _primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
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