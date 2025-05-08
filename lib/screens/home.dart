import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/cart_item.dart';
import '../widgets/item_card.dart';
import 'cart.dart';
import 'shoe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Item> items = [
    Item(
      name: 'Nike Air Jordan',
      price: 119.99,
      image: 'assets/Shoes1/air_jordan.jpg',
      description: 'Classic running shoe with exceptional cushioning.',
      extraImages: [
        'assets/Shoes1/air_jordan.jpg',
        'assets/Shoes1/air_jordan1.jpg',
        'assets/Shoes1/air_jordan_back.jpg',
        'assets/Shoes1/air_jordan_front.jpg',
      ],
    ),
    Item(
      name: 'Adidas Ultraboost',
      price: 179.99,
      image: 'assets/Shoes2/ultraboost.jpg',
      description: 'High-performance runner with responsive Boost midsole.',
      extraImages: [
        'assets/Shoes2/ultraboost.jpg',
        'assets/Shoes2/ultraboost_sideback.jpg',
        'assets/Shoes2/ultraboost_bottom.jpg',
        'assets/Shoes2/ultraboost_top.jpg',
        'assets/Shoes2/ultraboost_side.jpg',
      ],
    ),
    Item(
      name: 'Puma RS-X',
      price: 109.99,
      image: 'assets/Shoes3/rs-x.jpg',
      description: 'Retro-inspired design with bold style and cushioning for daily wear.',
      extraImages: [
        'assets/Shoes3/rs-x.jpg',
        'assets/Shoes3/rs-x_top.jpg',
        'assets/Shoes3/rs-x_side.jpg',
        'assets/Shoes3/rs-x_bottom.jpg',
      ],
    ),
    Item(
      name: 'New Balance 574',
      price: 84.99,
      image: 'assets/Shoes4/nb.jpg',
      description: 'Iconic design with suede and mesh for a mix of comfort and style.',
      extraImages: [
        'assets/Shoes4/nb.jpg',
        'assets/Shoes4/nb_side.jpg',
        'assets/Shoes4/nb_side2.jpg',
        'assets/Shoes4/nb_bottom.jpg',
      ],
    ),
    Item(
      name: 'Reebok Classics Leather',
      price: 74.99,
      image: 'assets/Shoes5/reebok_classics.jpg',
      description: 'Sleek leather upper and cushioned feel, great for everyday style.',
      extraImages: [
        'assets/Shoes5/reebok_classics.jpg',
        'assets/Shoes5/reebok_2.jpg',
        'assets/Shoes5/reebok_bottom.jpg',
        'assets/Shoes5/reebok_top.jpg',
        'assets/Shoes5/reebok_side.jpg',
      ],
    ),
  ];

  final List<CartItem> cart = [];

  void addToCart(CartItem item) {
    setState(() => cart.add(item));
  }

  @override
  Widget build(BuildContext context) {
    final uniqueCartCount = cart.map((e) => '${e.item.name}_${e.size}').toSet().length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Deals of the Day"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_bag),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen(cart: cart)),
                  );
                  setState(() {}); // Refresh UI after returning from cart
                },
              ),
              if (uniqueCartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$uniqueCartCount',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, index) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShoeDetailScreen(
                    shoe: items[index],
                    onAddToCart: addToCart,
                  ),
                ),
              );
            },
            child: ItemCard(
              item: items[index],
              onAdd: () => addToCart(
                CartItem(item: items[index], size: "9"), // default size when added via quick add
              ),
            ),
          ),
        ),
      ),
    );
  }
}
