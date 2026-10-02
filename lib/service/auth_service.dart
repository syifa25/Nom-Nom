class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  String? currentUserName;
  String? currentUserEmail; // Tambahkan variabel email ini

  final List<Map<String, String>> _users = [
    {
      'name': 'User',
      'email': 'user@gmail.com',
      'password': 'Password123',
    },
  ];

  void login(String email, String password) {
    for (var user in _users) {
      if (user['email'] == email && user['password'] == password) {
        currentUserName = user['name'];
        currentUserEmail = user['email']; // Simpan email saat login
        return;
      }
    }
    currentUserName = null;
    currentUserEmail = null;
  }

  bool register({
    required String name,
    required String email,
    required String password,
  }) {
    bool isExist = _users.any((user) => user['email'] == email);
    if (isExist) {
      return false;
    }

    _users.add({
      'name': name,
      'email': email,
      'password': password,
    });

    currentUserName = name;
    currentUserEmail = email;

    return true;
  }

  void logout() {
    currentUserName = null;
    currentUserEmail = null;
  }
}