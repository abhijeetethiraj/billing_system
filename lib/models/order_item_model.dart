class OrderItemModel {
  final String id;
  final String name;
  final String restaurant;
  final double price;
  final int quantity;
  final String image;

  const OrderItemModel({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory OrderItemModel.fromMap(Map<String, Object?> map) {
    return OrderItemModel(
      id: map['id'] as String,
      name: map['name'] as String,
      restaurant: map['restaurant'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: (map['quantity'] as num).toInt(),
      image: map['image'] as String,
    );
  }

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
}