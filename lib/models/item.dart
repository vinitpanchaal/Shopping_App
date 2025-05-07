class Item {
  final String name;
  final double price;
  final String image;
  final String description;
  final List<String>? extraImages;
  int quantity;

  Item({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    this.extraImages,
    this.quantity = 1,
  });
}
