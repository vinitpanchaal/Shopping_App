import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/cart_item.dart';

class ShoeDetailScreen extends StatefulWidget {
  final Item shoe;
  final Function(CartItem) onAddToCart;

  const ShoeDetailScreen({required this.shoe, required this.onAddToCart});

  @override
  State<ShoeDetailScreen> createState() => _ShoeDetailScreenState();
}

class _ShoeDetailScreenState extends State<ShoeDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  late String selectedImage;
  String selectedSize = '9';
  final List<String> sizes = ['7', '8', '9', '10', '11'];

  @override
  void initState() {
    super.initState();
    selectedImage = widget.shoe.image;
    _controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _slideAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeMainImage(String image) {
    setState(() => selectedImage = image);
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
              gradient: LinearGradient(colors: [Colors.orange.shade100, Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(selectedImage, width: 200, height: 200, fit: BoxFit.contain),
                  ),
                ),
                SizedBox(height: 12),
                Text(shoe.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(shoe.description),
                SizedBox(height: 12),
                Text("Price: \$${shoe.price}", style: TextStyle(fontSize: 18)),

                SizedBox(height: 16),
                Text("Select Size", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sizes.length,
                    itemBuilder: (context, index) {
                      final size = sizes[index];
                      final isSelected = size == selectedSize;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text("US $size"),
                          selected: isSelected,
                          onSelected: (_) => setState(() => selectedSize = size),
                          selectedColor: Colors.deepOrange,
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.onAddToCart(CartItem(item: shoe, size: selectedSize));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${shoe.name} (Size $selectedSize) added to cart')));
                  },
                  icon: Icon(Icons.shopping_cart),
                  label: Text("Add to Cart"),
                ),

                SizedBox(height: 16),
                Text("More Photos", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: shoe.extraImages?.length ?? 0,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    separatorBuilder: (_, __) => SizedBox(width: 12), // space between items
                    itemBuilder: (_, index) {
                      final img = shoe.extraImages![index];
                      return GestureDetector(
                        onTap: () => changeMainImage(img),
                        child: Container(
                          width: 90,
                          height: 90,
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepOrange),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              img,
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
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
