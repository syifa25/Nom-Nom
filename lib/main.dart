import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nom_nom/features/login_page.dart';
import 'package:nom_nom/features/home/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hwspqocyfrqeopdcdxiw.supabase.co',
    anonKey: 'sb_publishable__VYKLGfaJp9ay3Ic7aYqeQ_qSNikjm-',
  );

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

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final session = Supabase.instance.client.auth.currentSession;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => session != null
              ? const MainNavigation()
              : const LoginPage(),
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