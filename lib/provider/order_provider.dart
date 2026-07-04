import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/order_database.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  bool _isLoaded = false;

  List<OrderModel> get orders => _orders;

  Future<void> loadOrders() async {
    if (_isLoaded) {
      return;
    }

    _orders
      ..clear()
      ..addAll(await OrderDatabase.instance.getOrders());
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> addOrder(OrderModel order) async {
    await OrderDatabase.instance.insertOrder(order);
    _orders.insert(0, order);
    notifyListeners();
  }
}