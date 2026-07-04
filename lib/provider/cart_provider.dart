import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/food_model.dart'; 
import '../services/cart_database.dart';

class CartProvider extends ChangeNotifier {
  final List<CartModel> _cartItems = [];
  bool _isLoaded = false;

  final double deliveryFee = 2.00;
  final double taxRate = 0.08;

  List<CartModel> get cartItems => _cartItems;

  double get subtotal => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get tax => subtotal * taxRate;
  double get total => subtotal > 0 ? (subtotal + deliveryFee + tax) : 0;

  Future<void> loadCartItems() async {
    if (_isLoaded) {
      return;
    }

    final items = await CartDatabase.instance.getCartItems();
    _cartItems
      ..clear()
      ..addAll(items);
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _syncCart() async {
    await CartDatabase.instance.replaceCartItems(_cartItems);
  }

  // Items are added here from the Home Page
  Future<void> addToCart(FoodModel food) async {
    int index = _cartItems.indexWhere((element) => element.id == food.id);
    if (index >= 0) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(
        CartModel(
          id: food.id, 
          name: food.name, 
          restaurant: food.restaurant, 
          price: food.price, 
          image: food.image,
          quantity: 1
        )
      );
    }
    await _syncCart();
    notifyListeners();
  }

  Future<void> incrementQuantity(int index) async {
    _cartItems[index].quantity++;
    await _syncCart();
    notifyListeners();
  }

  Future<void> decrementQuantity(int index) async {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      await _syncCart();
      notifyListeners();
    }
  }

  Future<void> removeItem(int index) async {
    _cartItems.removeAt(index);
    await _syncCart();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await _syncCart();
    notifyListeners();
  }
}