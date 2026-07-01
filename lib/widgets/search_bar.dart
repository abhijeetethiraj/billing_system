import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomSearchBar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 18),

              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(30),
              ),

              child: const Row(
                children: [

                  Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),

                  SizedBox(width: 10),

                  Text(
                    "What are you craving?",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Container(
          height: 56,
          width: 56,

          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(18),
          ),

          child: const Icon(
            Icons.tune,
            color: Colors.black,
          ),
        ),

      ],
    );
  }
}