import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text("Welcome to the E-Library Dashboard!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}