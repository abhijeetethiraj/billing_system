import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/food_model.dart'; 

class CartProvider extends ChangeNotifier {
  final List<CartModel> _cartItems = [];

  final double deliveryFee = 2.00;
  final double taxRate = 0.08;

  List<CartModel> get cartItems => _cartItems;

  double get subtotal => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get tax => subtotal * taxRate;
  double get total => subtotal > 0 ? (subtotal + deliveryFee + tax) : 0;

  // Items are added here from the Home Page
  void addToCart(FoodModel food) {
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
    notifyListeners();
  }

  void incrementQuantity(int index) {
    _cartItems[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      notifyListeners();
    }
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }
}