
import 'package:flutter/material.dart';
import '../data/mock_db.dart';
import 'bookdetails.dart';

class MyLibraryPage extends StatefulWidget {
  const MyLibraryPage({super.key});

  @override
  State<MyLibraryPage> createState() => MyLibraryPageState();
}

class MyLibraryPageState extends State<MyLibraryPage> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> savedBooks = MockDatabase.getBookmarkedBooks();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Library", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: savedBooks.isEmpty
          ? const Center(
              child: Text(
                "No bookmarked books yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedBooks.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> book = savedBooks[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Image.network(
                      book["imageUrl"],
                      width: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.book, size: 40, color: Colors.orange),
                    ),
                    title: Text(
                      book["title"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${book["author"]} • ${book["category"]}"),
                        const SizedBox(height: 4),
                        Text(
                          "₱${((book["price"] ?? 0.0) as num).toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          MockDatabase.toggleBookmark(book["id"]);
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsPage(book: book),
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}