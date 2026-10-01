import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../service/auth_service.dart';
import 'main_navigation.dart';

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

  void _handleRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorText = 'Semua kolom wajib diisi');
      return;
    }

    setState(() => _errorText = null);
    AuthService.instance.login(email, password, name: name);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint) {
    final borderColor = AppColors.textSecondary.withOpacity(0.2);
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
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Logo Aplikasi dari Assets
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  'assets/logo_nomnom.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Buat Akun NomNom',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Yuk, Daftar dan temukan makanan yang kamu suka!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 24),
              _label('Nama Lengkap'),
              const SizedBox(height: 6),
              TextField(controller: _nameController, decoration: _fieldDecoration('Nama kamu')),
              const SizedBox(height: 14),
              _label('Email'),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _fieldDecoration('Masukkan Email Anda'),
              ),
              const SizedBox(height: 14),
              _label('Password'),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _fieldDecoration('Buat password'),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 11.5)),
                ),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Daftar', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    children: const [
                      TextSpan(text: 'Sudah punya akun? '),
                      TextSpan(
                        text: 'Masuk',
                        style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.w700),
                      ),
                    ],
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