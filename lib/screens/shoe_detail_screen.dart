import 'package:flutter/material.dart';
import '../models/item.dart';

class ShoeDetailScreen extends StatefulWidget {
  final Item shoe;
  final Function(Item) onAddToCart; // callback for adding item to cart

  const ShoeDetailScreen({required this.shoe, required this.onAddToCart});

  @override
  State<ShoeDetailScreen> createState() => _ShoeDetailScreenState();
}

class _ShoeDetailScreenState extends State<ShoeDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  late String selectedImage;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.shoe.image;

    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeMainImage(String image) {
    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shoe = widget.shoe;

    return Scaffold(
      appBar: AppBar(title: Text(shoe.name)),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade100, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      selectedImage,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain, // or use BoxFit.cover for tighter crop
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(shoe.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(shoe.description),
                SizedBox(height: 16),
                Text("Price: \$${shoe.price}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () {
                    widget.onAddToCart(shoe);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${shoe.name} added to cart')),
                    );
                  },
                  icon: Icon(Icons.shopping_cart),
                  label: Text("Add to Cart"),
                ),

                SizedBox(height: 20),
                Text("More Photos", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: shoe.extraImages?.length ?? 0,
                    itemBuilder: (_, index) {
                      final img = shoe.extraImages![index];
                      return GestureDetector(
                        onTap: () => changeMainImage(img),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepOrange),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              img,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
