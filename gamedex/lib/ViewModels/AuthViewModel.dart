import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  // PageController per PageView
  final PageController pageController = PageController(initialPage: 1);

  // Login controllers
  final TextEditingController loginUsernameController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  // Signup controllers
  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupSurnameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();

  String? loginError;
  String? signupError;

  // Lista utenti in memoria
  List<Map<String, dynamic>> _users = [];

  AuthViewModel() {
    _loadUsers();
  }

  // 🔹 Carica utenti da SharedPreferences
  Future<void> _loadUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('users');
      if (jsonString != null && jsonString.isNotEmpty) {
        final List data = jsonDecode(jsonString);
        _users = data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint('⚠️ Errore lettura utenti: $e');
    }
    notifyListeners();
  }

  // 🔹 Salva utenti su SharedPreferences
  Future<bool> _saveUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('users', jsonEncode(_users));
      debugPrint('✅ Utenti salvati correttamente!');
      return true;
    } catch (e) {
      debugPrint('❌ Errore nel salvataggio utenti: $e');
      return false;
    }
  }

  // 🔹 LOGIN
  Future<bool> login() async {
    loginError = null;
    final email = loginUsernameController.text.trim();
    final password = loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      loginError = 'Compila tutti i campi';
      notifyListeners();
      return false;
    }

    // cerca utente
    final user = _users.firstWhere(
          (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (user.isEmpty) {
      loginError = 'Email o password errati';
      notifyListeners();
      return false;
    }

    return true;
  }

  // 🔹 SIGNUP
  Future<bool> signup() async {
    signupError = null;

    final name = signupNameController.text.trim();
    final surname = signupSurnameController.text.trim();
    final email = signupEmailController.text.trim();
    final password = signupPasswordController.text;

    if (name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty) {
      signupError = 'Compila tutti i campi';
      notifyListeners();
      return false;
    }

    if (_users.any((u) => u['email'] == email)) {
      signupError = 'Email già registrata';
      notifyListeners();
      return false;
    }

    // aggiungi nuovo utente
    _users.add({
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
    });

    final saved = await _saveUsers();
    if (!saved) {
      signupError = 'Errore nel salvataggio delle credenziali';
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  // 🔹 Cambio pagina PageView
  void setPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  // 🔹 Aggiorna errori
  void setSignupError(String? e) {
    signupError = e;
    notifyListeners();
  }

  void setLoginError(String? e) {
    loginError = e;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    signupNameController.dispose();
    signupSurnameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    super.dispose();
  }
}
