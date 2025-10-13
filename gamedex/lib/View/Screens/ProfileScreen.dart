import 'package:flutter/material.dart';

/// --- PROFILE SCREEN (vuota per ora) ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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