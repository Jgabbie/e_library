import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = MockDatabase.cart;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Shopping Cart",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: cart.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      final book = item["book"] as Map<String, dynamic>;
                      final quantity = item["quantity"] as int;
                      return Card(
                        elevation: 3,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: Image.network(
                            book["imageUrl"],
                            width: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.book, color: Colors.orange),
                          ),
                          title: Text(
                            book["title"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "By ${book["author"]}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () => setState(
                                      () => MockDatabase.updateCartQuantity(
                                        book["id"],
                                        quantity - 1,
                                      ),
                                    ),
                                  ),
                                  Text("Quantity: $quantity"),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => setState(
                                      () => MockDatabase.updateCartQuantity(
                                        book["id"],
                                        quantity + 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => setState(
                              () => MockDatabase.updateCartQuantity(
                                book["id"],
                                0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(0, 50),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        final bookIds = cart
                            .expand(
                              (item) => List<String>.filled(
                                item["quantity"] as int,
                                (item["book"] as Map<String, dynamic>)["id"]
                                    .toString(),
                              ),
                            )
                            .toList();
                        MockDatabase.createOrder(bookIds);
                        setState(() {
                          MockDatabase.cart.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Borrow request submitted."),
                          ),
                        );
                      },
                      child: const Text(
                        "Borrow Selected Books",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
