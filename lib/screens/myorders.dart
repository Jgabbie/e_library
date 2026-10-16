import 'package:flutter/material.dart';
import '../data/mock_db.dart';
import 'orderdetails.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange, iconTheme: const IconThemeData(color: Colors.white)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: MockDatabase.orders.length,
        itemBuilder: (context, index) {
          final order = MockDatabase.orders[index];
          final books = MockDatabase.getOrderBooks(order);
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(order: order))),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(order["id"], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Chip(label: Text(order["status"], style: const TextStyle(color: Colors.white)), backgroundColor: Colors.orange),
                  ]),
                  Text(order["date"], style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  Text("${books.length} book${books.length == 1 ? "" : "s"}"),
                  const SizedBox(height: 8),
                  const Align(alignment: Alignment.centerRight, child: Text("View order details",
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
