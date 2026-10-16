import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final books = MockDatabase.getOrderBooks(order);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            order["id"],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "Placed on ${order["date"]}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: Colors.orange[50],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.orange),
                  const SizedBox(width: 10),
                  Text(
                    "Status: ${order["status"]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Books in this order",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...books.map(
            (book) => Card(
              elevation: 3,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Image.network(
                  book["imageUrl"],
                  width: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.book, color: Colors.orange),
                ),
                title: Text(
                  book["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("By ${book["author"]}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
