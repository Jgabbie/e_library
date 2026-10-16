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
      appBar: AppBar(
        title: const Text("Shopping Cart", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: cart.isEmpty
          ? const Center(child: Text("Your cart is empty.", style: TextStyle(fontSize: 18, color: Colors.grey)))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      final book = item["book"] as Map<String, dynamic>;
                      final quantity = item["quantity"] as int;
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: Image.network(book["imageUrl"], width: 55, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.book, color: Colors.orange)),
                          title: Text(book["title"], maxLines: 2, overflow: TextOverflow.ellipsis),
                          subtitle: Row(
                            children: [
                              IconButton(icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => setState(() => MockDatabase.updateCartQuantity(book["id"], quantity - 1))),
                              Text("$quantity"),
                              IconButton(icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => setState(() => MockDatabase.updateCartQuantity(book["id"], quantity + 1))),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => setState(() => MockDatabase.updateCartQuantity(book["id"], 0)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(0, 50),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Borrow request submitted."))),
                      child: const Text("Borrow Selected Books", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
