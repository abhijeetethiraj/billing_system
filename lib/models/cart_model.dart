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

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'restaurant': restaurant,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }

  factory CartModel.fromMap(Map<String, Object?> map) {
    return CartModel(
      id: map['id'] as String,
      name: map['name'] as String,
      restaurant: map['restaurant'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: (map['quantity'] as num).toInt(),
      image: map['image'] as String,
    );
  }
}