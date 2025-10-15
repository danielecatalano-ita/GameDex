import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class AuthViewModel extends ChangeNotifier {
  // Mostra la pagina di Register per default
  final PageController pageController = PageController(initialPage: 1);
  int _page = 1;

  // Login controllers
  final TextEditingController loginUsernameController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  // Signup controllers
  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupSurnameController = TextEditingController();
  final TextEditingController signupUsernameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();

  String? loginError;
  String? signupError;

  // Simulazione di un database di utenti
  final Map<String, String> _userDatabase = {};
  String? _loggedInUser;

  // Percorso dell'asset nel bundle (solo lettura)
  final String _assetCredentialsPath = 'assets/json/credentials.json';
  // Percorso risolto del file locale usabile dall'app (cartella documenti)
  String? _credentialsFilePathResolved;

  AuthViewModel() {
    // avvia il caricamento/migrazione in background
    _init();
  }

  Future<void> _init() async {
    try {
      // Risolvi il percorso nella cartella documenti dell'app
      final dir = await getApplicationDocumentsDirectory();
      final localFile = File('${dir.path}/credentials.json');
      _credentialsFilePathResolved = localFile.path;

      // Se il file locale non esiste, prova a copiarlo dall'asset (se presente), altrimenti crea un file vuoto
      if (!await localFile.exists()) {
        try {
          final assetContent = await rootBundle.loadString(_assetCredentialsPath);
          if (assetContent.trim().isEmpty) {
            await localFile.writeAsString(jsonEncode({}));
          } else {
            await localFile.writeAsString(assetContent);
          }
        } catch (_) {
          // Asset non presente o errore nel caricamento: crea file vuoto
          await localFile.writeAsString(jsonEncode({}));
        }
      }

      await _loadCredentialsFromFile();
    } catch (e) {
      // ignore: avoid_print
      print('AuthViewModel init error: $e');
    }
  }

  Future<bool> _saveCredentialsToFile() async {
    final jsonContent = jsonEncode(_userDatabase);
    try {
      final path = _credentialsFilePathResolved ?? '';
      if (path.isEmpty) return false;
      final file = File(path);
      await file.writeAsString(jsonContent);
      // ignore: avoid_print
      print('Saved credentials to ${file.path}: $jsonContent');
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Save credentials error: $e');
      return false;
    }
  }

  Future<void> _loadCredentialsFromFile() async {
    _userDatabase.clear();
    try {
      // Assicurati che il percorso locale sia risolto
      if (_credentialsFilePathResolved == null) {
        final dir = await getApplicationDocumentsDirectory();
        _credentialsFilePathResolved = '${dir.path}/credentials.json';
      }

      final file = File(_credentialsFilePathResolved!);
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isEmpty) return;
        final Map<String, dynamic> data = jsonDecode(content);
        data.forEach((k, v) => _userDatabase[k] = v.toString());
      } else {
        // Inizializza il file se non esiste
        await file.writeAsString(jsonEncode({}));
      }
    } catch (e) {
      // ignore: avoid_print
      print('Load credentials error: $e');
    }
    notifyListeners();
  }

  int get page => _page;

  void setPage(int p) {
    _page = p;
    // Notifica subito lo stato (utile per rebuild di UI non legate al controller)
    notifyListeners();

    // Se il PageController ha client animiamo subito, altrimenti aspettiamo il frame
    try {
      if (pageController.hasClients) {
        pageController.animateToPage(p, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        return;
      }
    } catch (_) {}

    // Prova ad animare dopo il prossimo frame (gestisce casi in cui il controller non è ancora attaccato)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (pageController.hasClients) {
          pageController.animateToPage(p, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      } catch (_) {}
    });
  }

  Future<bool> login() async {
    loginError = null;
    final email = loginUsernameController.text.trim();
    final password = loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      loginError = "Compila tutti i campi";
      notifyListeners();
      return false;
    }

    await _loadCredentialsFromFile();
    if (_userDatabase.containsKey(email) && _userDatabase[email] == password) {
      _loggedInUser = email;
      return true;
    } else {
      loginError = "Credenziali non valide";
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup() async {
    signupError = null;
    final name = signupNameController.text.trim();
    final surname = signupSurnameController.text.trim();
    final email = signupEmailController.text.trim();
    final password = signupPasswordController.text;

    if (name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty) {
      signupError = "Compila tutti i campi";
      notifyListeners();
      return false;
    }

    await _loadCredentialsFromFile();
    if (_userDatabase.containsKey(email)) {
      signupError = "Email già registrata";
      notifyListeners();
      return false;
    }

    // registra
    _userDatabase[email] = password;
    final saved = await _saveCredentialsToFile();
    if (!saved) {
      signupError = "Errore durante il salvataggio delle credenziali";
      notifyListeners();
      return false;
    }
    // Ricarica dal file per essere sicuri che i dati siano persistiti correttamente
    await _loadCredentialsFromFile();
    // aggiorna la UI per mostrare l'email appena registrata
    notifyListeners();
    return true;
  }

  String? get loggedInUser => _loggedInUser;

  /// Lista di email registrate (solo lettura)
  List<String> get registeredEmails => _userDatabase.keys.toList();

  /// Path del file JSON usato per le credenziali
  String? get credentialsFilePath => _credentialsFilePathResolved;

  // Metodi helper per aggiornare gli errori dalla UI senza usare notifyListeners esternamente
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
    signupUsernameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    super.dispose();
  }
}
