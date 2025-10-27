import 'package:flutter/material.dart';
import 'package:gamedex/Views/TabBarScreensViews/HomeScreenView.dart';
import 'package:provider/provider.dart';
import 'package:gamedex/ViewModels/AuthViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    if (prefs.containsKey('currentUser')) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreenView()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Consumer<AuthViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: double.infinity),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Logo
                              Center(
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/gamedex_logo.png', width: 160, height: 160),
                                    const SizedBox(height: 8),
                                    const SizedBox(height: 18),
                                  ],
                                ),
                              ),

                              // PageView
                              SizedBox(
                                height: 520,
                                child: PageView(
                                  controller: vm.pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    _buildLogin(context, vm),
                                    _buildSignup(context, vm),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _decoratedField({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFf6f2f2),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(188, 151, 251, 1.0),
            offset: const Offset(0, 3), // ridotto per evitare taglio
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2), // 🔹 leggero margine per non tagliare l’ombra
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: child,
    );
  }

  Widget _actionButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity, // 🔹 ora si adatta alla larghezza del form
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A24F4),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 4,
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildLogin(BuildContext context, AuthViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Log In', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        const Text('Email:'),
        const SizedBox(height: 8),
        _decoratedField(
          child: TextField(
            controller: vm.loginUsernameController,
            decoration: const InputDecoration(border: InputBorder.none, hintText: ''),
          ),
        ),
        const SizedBox(height: 14),
        const Text('Password:'),
        const SizedBox(height: 8),
        _decoratedField(
          child: TextField(
            controller: vm.loginPasswordController,
            obscureText: false,
            decoration: const InputDecoration(border: InputBorder.none, hintText: ''),
          ),
        ),
        const SizedBox(height: 18),
        if (vm.loginError != null) ...[
          Text(vm.loginError!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
        ],
        _actionButton(
          label: 'Accedi',
          onPressed: () async {
            final navigator = Navigator.of(context);
            final ok = await vm.login();
            if (ok) {
              navigator.pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeScreenView()),
              );
            }
          },
        ),
        const SizedBox(height: 18),
        Center(
          child: GestureDetector(
            onTap: () => vm.setPage(1),
            child: const Text(
              'Non hai ancora un account? Registrati ora!',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignup(BuildContext context, AuthViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Register', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text('Nome:'),
        const SizedBox(height: 6),
        _decoratedField(
          child: TextField(
            controller: vm.signupNameController,
            decoration: const InputDecoration(border: InputBorder.none, hintText: ''),
          ),
        ),
        const SizedBox(height: 10),
        const Text('Cognome'),
        const SizedBox(height: 6),
        _decoratedField(
          child: TextField(
            controller: vm.signupSurnameController,
            decoration: const InputDecoration(border: InputBorder.none, hintText: ''),
          ),
        ),
        const SizedBox(height: 10),
        const Text('Email:'),
        const SizedBox(height: 6),
        _decoratedField(
          child: TextField(
            controller: vm.signupEmailController,
            decoration: const InputDecoration(border: InputBorder.none, hintText: ''),
          ),
        ),
        const SizedBox(height: 10),
        const Text('Password:'),
        const SizedBox(height: 6),
        _decoratedField(
          child: TextField(
            controller: vm.signupPasswordController,
            obscureText: false,
            decoration: const InputDecoration(border: InputBorder.none, hintText: ''),
          ),
        ),
        const SizedBox(height: 12),
        if (vm.signupError != null) ...[
          Text(vm.signupError!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
        ],
        _actionButton(
          label: 'Registrati',
          onPressed: () async {
            FocusScope.of(context).unfocus();
            try {
              final ok = await vm.signup();
              if (ok) {
                vm.loginUsernameController.text = vm.signupEmailController.text.trim();
                vm.loginPasswordController.text = vm.signupPasswordController.text;

                vm.signupNameController.clear();
                vm.signupSurnameController.clear();
                vm.signupEmailController.clear();
                vm.signupPasswordController.clear();

                await Future.delayed(const Duration(milliseconds: 200));
                try {
                  vm.setPage(0);
                } catch (_) {}
              }
            } catch (e) {
              vm.setSignupError('Errore: $e');
            }
          },
        ),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () => vm.setPage(0),
            child: const Text(
              'Hai già un account? Accedi ora!',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
