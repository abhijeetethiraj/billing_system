class CartModel {
  final String id;
  final String name;
  final String restaurant;
  final double price;
  int quantity;
  final String image;

  CartModel({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.price,
    this.quantity = 1,
    required this.image,
  });
}