import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gamedex/ViewModels/AuthViewModel.dart';
import 'package:gamedex/Views/TabBarView.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Consumer<AuthViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
                  child: SizedBox(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo
                        Center(
                          child: Column(
                            children: [
                              Image.asset('assets/images/gamedex_logo.png', width: 80, height: 80),
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
                        // (debug removed)
                      ],
                    ),
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
      decoration: BoxDecoration(
        color: const Color(0xFFf6f2f2),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(156, 39, 176, 0.35),
            offset: const Offset(6, 6),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: child,
    );
  }

  Widget _actionButton({required String label, required VoidCallback onPressed}) {
    return Center(
      child: SizedBox(
        width: 140,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9C27B0), // purple
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            elevation: 0,
          ),
          onPressed: onPressed,
          child: Text(label),
        ),
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
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            ),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final ok = await vm.login();
              if (ok) {
                navigator.pushReplacement(
                  MaterialPageRoute(builder: (_) => const AppTabBarView()),
                );
              } else {
                // Errore mostrato nel widget tramite vm.loginError
              }
            },
            child: const Text('Accedi'),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: GestureDetector(
            onTap: () => vm.setPage(1),
            child: const Text('Non hai ancora un account? Registrati ora!', style: TextStyle(fontWeight: FontWeight.bold)),
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
          child: TextField(controller: vm.signupNameController, decoration: const InputDecoration(border: InputBorder.none, hintText: ''),),
        ),
        const SizedBox(height: 10),
        const Text('Cognome'),
        const SizedBox(height: 6),
        _decoratedField(
          child: TextField(controller: vm.signupSurnameController, decoration: const InputDecoration(border: InputBorder.none, hintText: ''),),
        ),
        const SizedBox(height: 10),
        const Text('Email:'),
        const SizedBox(height: 6),
        _decoratedField(
          child: TextField(controller: vm.signupEmailController, decoration: const InputDecoration(border: InputBorder.none, hintText: ''),),
        ),
        const SizedBox(height: 10),
        const Text('Password:'),
        const SizedBox(height: 6),
        _decoratedField(
          child: TextField(controller: vm.signupPasswordController, obscureText: false, decoration: const InputDecoration(border: InputBorder.none, hintText: ''),),
        ),
        const SizedBox(height: 12),
        if (vm.signupError != null) ...[
          Text(vm.signupError!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
        ],
        _actionButton(label: 'Registrati', onPressed: () async {
          // disabilita il focus
          FocusScope.of(context).unfocus();
          try {
            final ok = await vm.signup();
            if (ok) {
              // precompila i campi di login con email e password appena registrati
              vm.loginUsernameController.text = vm.signupEmailController.text.trim();
              vm.loginPasswordController.text = vm.signupPasswordController.text;
              // pulisci i campi di signup
              vm.signupNameController.clear();
              vm.signupSurnameController.clear();
              vm.signupEmailController.clear();
              vm.signupPasswordController.clear();
              // Non mostrare SnackBar: l'eventuale messaggio di successo può essere mostrato nella UI tramite vm state
              // aspetta un momento per permettere al framework di attaccare il controller se necessario
              await Future.delayed(const Duration(milliseconds: 200));
              try {
                vm.setPage(0);
              } catch (_) {
                // ignore
              }
            } else {
              // Errore mostrato nel widget tramite vm.signupError
            }
          } catch (e) {
            // Mostriamo l'errore nel ViewModel in modo consistente
            vm.setSignupError('Errore: $e');
           }
         }),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () => vm.setPage(0),
            child: const Text('Hai già un account? Accedi ora!', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
