import 'package:flutter/material.dart';
import '../../models/food_model.dart';

class FoodCartWidget extends StatelessWidget {
  final FoodModel food;
  final VoidCallback onAddToCart;

  const FoodCartWidget({
    super.key,
    required this.food,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha:0.08), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(food.image, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(food.restaurant, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text("\$${food.price.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFF983D2A), fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, color: Color(0xFFFF6B3A), size: 36),
          onPressed: onAddToCart,
        ),
      ),
    );
  }
}