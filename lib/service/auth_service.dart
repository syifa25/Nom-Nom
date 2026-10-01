import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);
  String? currentUserEmail;
  String? currentUserName;

  void login(String email, String password, {String? name}) {
    currentUserEmail = email;
    // Jika nama tidak diisi, ambil nama depan dari email (contoh: nina@gmail.com -> Nina)
    if (name != null && name.trim().isNotEmpty) {
      currentUserName = name.trim();
    } else {
      final prefix = email.split('@').first;
      currentUserName = prefix.isNotEmpty
          ? prefix[0].toUpperCase() + prefix.substring(1)
          : 'User';
    }
    isLoggedIn.value = true;
  }

  void logout() {
    currentUserEmail = null;
    currentUserName = null;
    isLoggedIn.value = false;
  }
}