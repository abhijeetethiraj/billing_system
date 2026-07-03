import 'package:flutter/material.dart';

class PopularDishesSection extends StatelessWidget {
  final List<Map<String, dynamic>> dishes;
  final Function(Map<String, dynamic>)? onDishTap;

  const PopularDishesSection({
    super.key,
    required this.dishes,
    this.onDishTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.local_fire_department,
              color: Colors.orange,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              "Popular Dishes",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dishes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 18),

            itemBuilder: (context, index) {
              final dish = dishes[index];

              return InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  if (onDishTap != null) {
                    onDishTap!(dish);
                  }
                },

                child: SizedBox(
                  width: 80,

                  child: Column(
                    children: [

                      Container(
                        width: 70,
                        height: 70,

                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.orange.shade200,
                          ),
                        ),

                        child: dish["image"] != null
                            ? ClipOval(
                                child: Image.asset(
                                  dish["image"],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.fastfood,
                                size: 32,
                                color: Colors.deepOrange,
                              ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        dish["name"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}