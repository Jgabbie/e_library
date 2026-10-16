// lib/screens/home.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Welcome to E-Library!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 36),

            // Go to Book Catalog
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              icon: const Icon(Icons.menu_book, color: Colors.white),
              label: const Text(
                "Browse Book Catalog",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/bookcatalog');
              },
            ),
            const SizedBox(height: 16),

            // Go to My Library (Bookmarks)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              icon: const Icon(Icons.bookmark, color: Colors.white),
              label: const Text(
                "My Library",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/mylibrary');
              },
            ),
          ],
        ),
      ),
    );
  }
}
