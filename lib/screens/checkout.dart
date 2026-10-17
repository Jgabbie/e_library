// lib/screens/checkout.dart
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
    // If cart has items, checkout uses the full cart; otherwise single direct book
    final bool isCartCheckout = MockDatabase.cart.isNotEmpty;
    final List<Map<String, dynamic>> checkoutItems = isCartCheckout
        ? MockDatabase.cart
        : [
            {"book": widget.book, "quantity": 1}
          ];

    double subtotal = 0.0;
    for (final item in checkoutItems) {
      final book = item["book"] as Map<String, dynamic>;
      final quantity = item["quantity"] as int;
      final price = ((book["price"] ?? 0.0) as num).toDouble();
      subtotal += price * quantity;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: isBookmarked ? 'Remove bookmark' : 'Save book',
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: handleBookmarkToggle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...checkoutItems.map((item) {
              final book = item["book"] as Map<String, dynamic>;
              final quantity = item["quantity"] as int;
              final price = ((book["price"] ?? 0.0) as num).toDouble();
              final lineTotal = price * quantity;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          book["imageUrl"] ?? '',
                          width: 60,
                          height: 85,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 60,
                            height: 85,
                            color: const Color(0xFFFFF3E8),
                            child: const Icon(Icons.book, color: Colors.orange),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book["title"] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "By ${book["author"] ?? ''}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "₱${price.toStringAsFixed(2)} × $quantity",
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "₱${lineTotal.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Summary",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Subtotal",
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        Text(
                          "₱${subtotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shipping Fee",
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        Text(
                          "FREE",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Payment",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "₱${subtotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, -3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total to Pay",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      "₱${subtotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    final bookIds = MockDatabase.cart.isNotEmpty
                        ? MockDatabase.cart
                            .expand(
                              (item) => List<String>.filled(
                                item["quantity"] as int,
                                (item["book"] as Map<String, dynamic>)["id"]
                                    .toString(),
                              ),
                            )
                            .toList()
                        : [widget.book["id"].toString()];

                    MockDatabase.createOrder(bookIds, status: "Purchased");
                    MockDatabase.cart.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Checkout successful! Order placed."),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/myorders',
                      (route) => route.isFirst,
                    );
                  },
                  child: const Text(
                    "Place Order",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}