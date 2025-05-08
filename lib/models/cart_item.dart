import 'item.dart';

class CartItem {
  final Item item;
  final String size;

  CartItem({required this.item, required this.size});

  // Needed for using as Map key (e.g., in Set)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CartItem &&
              runtimeType == other.runtimeType &&
              item.name == other.item.name &&
              size == other.size;

  @override
  int get hashCode => item.name.hashCode ^ size.hashCode;
}
