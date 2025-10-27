import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final PageController pageController = PageController(initialPage: 0);

  final TextEditingController loginUsernameController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupSurnameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();

  String? loginError;
  String? signupError;

  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic>? currentUser;
  bool isLoggedIn = false;

  AuthViewModel() {
    _loadUsers();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('currentUser');
    if (userString != null && userString.isNotEmpty) {
      currentUser = jsonDecode(userString);
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<void> _saveCurrentUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', jsonEncode(user));
    currentUser = user;
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
    currentUser = null;
    isLoggedIn = false;
    notifyListeners();
  }

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

  Future<bool> _saveUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('users', jsonEncode(_users));
      debugPrint('Utenti salvati correttamente!');
      return true;
    } catch (e) {
      debugPrint('Errore nel salvataggio utenti: $e');
      return false;
    }
  }

  Future<bool> login() async {
    loginError = null;
    final email = loginUsernameController.text.trim();
    final password = loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      loginError = 'Compila tutti i campi';
      notifyListeners();
      return false;
    }

    final user = _users.firstWhere(
          (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (user.isEmpty) {
      loginError = 'Email o password errati';
      notifyListeners();
      return false;
    }

    await _saveCurrentUser(user);
    return true;
  }

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

    final newUser = {
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
    };

    _users.add(newUser);

    final saved = await _saveUsers();
    if (!saved) {
      signupError = 'Errore nel salvataggio delle credenziali';
      notifyListeners();
      return false;
    }

    await _saveCurrentUser(newUser);
    notifyListeners();
    return true;
  }

  void setPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

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
