import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final books = MockDatabase.getOrderBooks(order);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
          Container(
            padding: const EdgeInsets.all(14),
            color: Colors.orange[50],
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
          const SizedBox(height: 24),
          const Text(
            "Books in this order",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...books.map(
            (book) => Card(
              child: ListTile(
                leading: Image.network(
                  book["imageUrl"],
                  width: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.book, color: Colors.orange),
                ),
                title: Text(book["title"]),
                subtitle: Text("By ${book["author"]}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
