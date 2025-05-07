import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemCard extends StatefulWidget {
  final Item item;
  final VoidCallback onAdd;

  ItemCard({required this.item, required this.onAdd});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Card(
        margin: EdgeInsets.all(12),
        child: ListTile(
          leading: Image.asset(widget.item.image, width: 50, fit: BoxFit.cover),
          title: Text(widget.item.name),
          subtitle: Text('\$${widget.item.price.toStringAsFixed(2)}'),
          trailing: ElevatedButton(
            child: Text('Add'),
            onPressed: widget.onAdd,
          ),
        ),
      ),
    );
  }
}
