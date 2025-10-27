import 'package:flutter/material.dart';
import 'package:gamedex/ViewModels/AuthViewModel.dart';
import 'package:gamedex/Views/Auth/AuthView.dart';
import 'package:provider/provider.dart';

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // 🔹 centra il titolo
        title: const Text(
          'Profilo utente',
          style: TextStyle(
            color: Color(0xFF000000), // colore coerente col tema purple
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Icon(
              Icons.account_circle,
              size: 120,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 24),
            if (user != null && user['name'] != null)
              Text(
                'Ciao ${user['name']}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            else
              const Text(
                'Ciao utente!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                await authViewModel.logout();
                if (!context.mounted) return;
                // 🔹 Torna alla schermata di login rimuovendo tutte le route precedenti
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthView()),
                      (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('LOGOUT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A24F4),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
