// lib/screens/home.dart
import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              MockDatabase.activeUser = null;
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dynamic user = MockDatabase.activeUser;

    final String username = user is Map
        ? (user["username"] ?? user["email"] ?? "My Profile").toString()
        : 'My Profile';

    final String? profileImagePath = user is Map
        ? user["profileImage"]?.toString()
        : null;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(context, '/profile');
            setState(() {});
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: profileImagePath != null
                    ? AssetImage(profileImagePath)
                    : null,
                child: profileImagePath == null
                    ? const Icon(Icons.person, color: Colors.orange)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        actions: [
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed: _confirmLogout,
      ),
    ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Welcome to Book Central!",
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
              onPressed: () => Navigator.pushNamed(context, '/bookcatalog'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),

              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: const Text(
                "Shopping Cart",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () => Navigator.pushNamed(context, '/cart'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              icon: const Icon(Icons.receipt_long, color: Colors.white),
              label: const Text(
                "My Orders",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () => Navigator.pushNamed(context, '/myorders'),
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
              onPressed: () => Navigator.pushNamed(context, '/mylibrary'),
            ),
          ],
        ),
      ),
    );
  }
}
