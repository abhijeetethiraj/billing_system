import 'order_item_model.dart';

class OrderModel {
  final String id;
  final String paymentId;
  final double amount;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.paymentId,
    required this.amount,
    required this.createdAt,
    required this.items,
  });
}