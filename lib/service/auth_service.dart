import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  User? get currentUser => client.auth.currentUser;

  String? get displayName => currentUserName;

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
      email: email.trim(),
      password: password,
      data: {
        'full_name': name.trim(),
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
      email: email.trim(),
      password: password,
    );

    _updateUser();
    return response;
  }

  // Perbarui nama lengkap pengguna di metadata Supabase
  Future<UserResponse> updateProfileName(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) {
      throw const AuthException('Nama tidak boleh kosong.');
    }

    final response = await client.auth.updateUser(
      UserAttributes(
        data: {'full_name': trimmed},
      ),
    );

    _updateUser();
    return response;
  }

  // Ganti password saat pengguna sedang login
  Future<UserResponse> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final email = client.auth.currentUser?.email;
    if (email == null || email.isEmpty) {
      throw const AuthException('Email pengguna tidak ditemukan.');
    }

    // Verifikasi ulang password lama agar lebih aman
    await client.auth.signInWithPassword(
      email: email,
      password: currentPassword,
    );

    // Perbarui password di Supabase
    final response = await client.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    _updateUser();
    return response;
  }

  // Kirim link reset password ke email jika pengguna lupa password
  Future<void> sendPasswordResetEmail(String email) async {
    await client.auth.resetPasswordForEmail(email.trim());
  }

  // Logout pengguna
  Future<void> logout() async {
    await client.auth.signOut();
    _updateUser();
  }

  void dispose() {
    _authSubscription.cancel();
    isLoggedIn.dispose();
  }
}