import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> book;

  const CheckoutPage({super.key, required this.book});

  @override
  State<CheckoutPage> createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  late bool isBookmarked;

  @override
  void initState() {
    super.initState();
    isBookmarked = MockDatabase.isBookmarked(widget.book["id"]);
  }

  void handleBookmarkToggle() {
    setState(() {
      MockDatabase.toggleBookmark(widget.book["id"]);
      isBookmarked = !isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isBookmarked ? "Added to My Library" : "Removed from My Library",
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> currentBook = widget.book;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Book Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: handleBookmarkToggle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.orange[50],
              child: Center(
                child: Image.network(
                  currentBook["imageUrl"],
                  height: 220,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.book, size: 80, color: Colors.orange),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentBook["title"],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "By ${currentBook["author"]}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Chip(
                        label: Text(
                          currentBook["category"],
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            currentBook["rating"].toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(height: 30),

                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentBook["description"],
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  side: const BorderSide(color: Colors.orange),
                ),
                onPressed: handleBookmarkToggle,
                child: Text(
                  isBookmarked ? "Saved" : "Save",
                  style: const TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(0, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Checkout successful!"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/my-orders',
                    (route) => route.isFirst,
                  );
                },
                child: const Text(
                  "Proceed",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
