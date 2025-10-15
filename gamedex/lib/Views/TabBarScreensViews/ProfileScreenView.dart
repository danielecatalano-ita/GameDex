import 'package:flutter/material.dart';

/// --- PROFILE SCREEN (vuota per ora) ---
class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Profilo utente",
        style: TextStyle(fontSize: 20, color: Colors.grey),
      ),
    );
  }
}