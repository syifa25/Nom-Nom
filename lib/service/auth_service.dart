import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class AuthService {
  AuthService._internal() {
    _updateUser();

    // Memantau perubahan status autentikasi
    _authSubscription = client.auth.onAuthStateChange.listen((data) {
      _updateUser();
    });
  }

  static final AuthService instance = AuthService._internal();

  final SupabaseClient client = Supabase.instance.client;

  late final StreamSubscription<AuthState> _authSubscription;

  final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  String? currentUserEmail;
  String? currentUserName;
  //String? currentUserEmail; // Tambahkan variabel email ini

  final List<Map<String, String>> _users = [
    {
      'name': 'User',
      'email': 'user@gmail.com',
      'password': 'Password123',
    },
  ];

  User? get currentUser => client.auth.currentUser;

  get displayName => null;

  void _updateUser() {
    final user = client.auth.currentUser;

    isLoggedIn.value = user != null;
    currentUserEmail = user?.email;

    final metadataName = user?.userMetadata?['full_name'] as String?;

    if (metadataName != null && metadataName.isNotEmpty) {
      currentUserName = metadataName;
    } else {
      final prefix = user?.email?.split('@').first ?? '';
      currentUserName = prefix.isNotEmpty
          ? prefix[0].toUpperCase() + prefix.substring(1)
          : null;
    }
  }

  // Registrasi pengguna
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': name,
      },
    );

    _updateUser();
    return response;
  }

  // Login pengguna
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    _updateUser();
    return response;
  }

  // Logout pengguna
  Future<void> logout() async {
    await client.auth.signOut();
    _updateUser();
  }
}
