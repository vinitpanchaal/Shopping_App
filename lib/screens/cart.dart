import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;

  CartScreen({required this.cart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<CartItem, int> itemCounts = {};

  @override
  void initState() {
    super.initState();
    for (var item in widget.cart) {
      itemCounts[item] = (itemCounts[item] ?? 0) + 1;
    }
  }

  void increment(CartItem item) {
    setState(() {
      itemCounts[item] = itemCounts[item]! + 1;
    });
  }

  void decrement(CartItem item) {
    setState(() {
      if (itemCounts[item]! > 1) {
        itemCounts[item] = itemCounts[item]! - 1;
      } else {
        itemCounts.remove(item);
        widget.cart.removeWhere((cartItem) =>
        cartItem.item.name == item.item.name && cartItem.size == item.size);
      }
    });
  }

  void clearCart() {
    setState(() {
      itemCounts.clear();
      widget.cart.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Cart cleared")),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = itemCounts.entries
        .map((e) => e.key.item.price * e.value)
        .fold(0, (prev, amount) => prev + amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Bag'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            tooltip: "Clear All",
            onPressed: itemCounts.isNotEmpty ? clearCart : null,
          ),
        ],
      ),
      body: itemCounts.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView(
              children: itemCounts.entries.map((entry) {
                final cartItem = entry.key;
                final quantity = entry.value;
                return ListTile(
                  leading: Image.asset(cartItem.item.image, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(cartItem.item.name),
                  subtitle: Text("Size: ${cartItem.size} • \$${cartItem.item.price.toStringAsFixed(2)} x $quantity"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => decrement(cartItem),
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => increment(cartItem),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Total: \$${total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: clearCart,
                  icon: Icon(Icons.clear_all),
                  label: Text("Clear All Items"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
