import 'package:flutter/material.dart';
import 'package:billing_system/models/meal_model.dart';

class FoodCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const FoodCard({
    super.key,
    required this.meal,
    this.onTap,
    this.onAddToCart,
    this.width = 220,
    this.margin = const EdgeInsets.only(right: 16),
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: width,
        margin: margin,

        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            //================ IMAGE =================
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),

                  child: Image.network(
                    meal.strMealThumb,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: cs.surfaceContainerHighest,
                        child: const Icon(
                          Icons.fastfood,
                          size: 60,
                          color: Colors.deepOrange,
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,

                  child: Container(
                    padding: const EdgeInsets.all(6),

                    decoration: BoxDecoration(
                      color: cs.surface,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(Icons.favorite_border, size: 20),
                  ),
                ),
              ],
            ),

            //================ DETAILS =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    meal.strMeal,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Restaurant",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),

                      const SizedBox(width: 4),

                      Text(
                        "4.8",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const Spacer(),

                      Text(
                        "₹${120 + meal.idMeal.hashCode % 250}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 42,

                    child: ElevatedButton.icon(
                      onPressed: onAddToCart,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),

                      icon: const Icon(Icons.add_shopping_cart),

                      label: const Text(
                        "Add to Cart",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
