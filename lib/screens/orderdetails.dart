import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final books = MockDatabase.getOrderBooks(order);
    final bookCounts = <String, int>{};
    for (final book in books) {
      final id = book["id"].toString();
      bookCounts[id] = (bookCounts[id] ?? 0) + 1;
    }
    final uniqueBooks = <Map<String, dynamic>>[];
    for (final book in books) {
      if (!uniqueBooks.any((item) => item["id"] == book["id"])) {
        uniqueBooks.add(book);
      }
    }

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
          if (books.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  "No books found for this order.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ...uniqueBooks.map(
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
                subtitle: Text(
                  "By ${book["author"]}\n"
                  "Quantity: ${bookCounts[book["id"].toString()] ?? 1}",
                ),
                isThreeLine: true,
              ),
            ),
          ),
          if (books.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              "Total books: ${books.length}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }
}
