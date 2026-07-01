import 'package:flutter/material.dart';

class FoodDetailPage extends StatefulWidget {
  final Map<String, dynamic> food;

  const FoodDetailPage({
    super.key,
    required this.food,
  });

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final food = widget.food;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Food Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            //================ IMAGE =================

            SizedBox(
              height: 260,
              width: double.infinity,

              child: food["image"] != null
                  ? Image.asset(
                      food["image"],
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: const Color(0xFFFFF3E0),
                      child: const Icon(
                        Icons.fastfood,
                        size: 90,
                        color: Colors.deepOrange,
                      ),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    food["name"] ?? "",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    food["restaurant"] ?? "",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [

                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        "${food["rating"] ?? 0}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        "₹${food["price"] ?? 0}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    food["description"] ??
                        "Freshly prepared using premium ingredients. Delicious taste with rich flavours and perfect for every craving.",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Quantity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [

                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),

                      Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),

                    ],
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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