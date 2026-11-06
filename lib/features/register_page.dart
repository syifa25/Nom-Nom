import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import 'home/main_navigation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  
Future<void> _handleRegister() async {
  final name = _nameController.text.trim();
  final email = _emailController.text.trim();
  final password = _passwordController.text;

  if (name.isEmpty || email.isEmpty || password.isEmpty) {
    setState(() => _errorText = 'Semua kolom wajib diisi');
    return;
  }

  if (!email.contains('@') || !email.contains('.')) {
    setState(() => _errorText = 'Format email tidak valid');
    return;
  }

  if (password.length < 6) {
    setState(() => _errorText = 'Password minimal 6 karakter');
    return;
  }

  setState(() {
    _errorText = null;
    _isLoading = true;
  });

  try {
    final response = await AuthService.instance.register(
      name: name,
      email: email,
      password: password,
    );

    if (!mounted) return;

    // Jika konfirmasi email diaktifkan,
    // pengguna perlu verifikasi email terlebih dahulu.
    if (response.session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registrasi berhasil! Silakan cek email untuk verifikasi akun.',
          ),
          duration: Duration(seconds: 5),
        ),
      );

      Navigator.pop(context);
      return;
    }

    // Jika konfirmasi email tidak diwajibkan,
    // pengguna langsung masuk.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const MainNavigation(),
      ),
      (route) => false,
    );
  } on AuthException catch (e) {
    if (!mounted) return;

    setState(() {
      _errorText = e.message;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _errorText = 'Registrasi gagal. Silakan coba lagi.';
    });
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint) {
    final borderColor = AppColors.textSecondary.withValues(alpha: 0.2);
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
      ),
    );
  }

  Widget _label(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
          fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
    ),
  );

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFF4E5);
    const primaryColor = Color(0xFFE66A3C);
    const brownColor = Color(0xFF8B3E20);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: brownColor),
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
                color: primaryColor,
              ),
              const SizedBox(height: 12),
              const Text(
                'Buat Akun NomNom',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: brownColor,
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
                    prefixIcon: Icon(Icons.person, color: primaryColor),
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
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                          style: TextStyle(fontWeight: FontWeight.w700),
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
                    hintText: 'Min. 5 karakter (huruf besar & kecil)',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    prefixIcon: Icon(Icons.lock, color: primaryColor),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Daftar
              ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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