import 'package:flutter/material.dart';

import '../../widgets/search_bar.dart';
import '../../widgets/recent_search_section.dart';
import '../../widgets/popular_dishes_section.dart';
import '../../widgets/food_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<String> recentSearches = const [
    "Pizza",
    "Burger",
    "Pasta",
    "Cold Coffee",
  ];

  final List<Map<String, dynamic>> popularDishes = const [
    {
      "name": "Pizza",
      "image": null,
    },
    {
      "name": "Burger",
      "image": null,
    },
    {
      "name": "Pasta",
      "image": null,
    },
    {
      "name": "Noodles",
      "image": null,
    },
    {
      "name": "Sandwich",
      "image": null,
    },
  ];

  final List<Map<String, dynamic>> recommendedFoods = const [
    {
      "name": "Margherita Pizza",
      "restaurant": "Pizza Corner",
      "price": 299,
      "rating": 4.8,
      "image": null,
    },
    {
      "name": "Classic Burger",
      "restaurant": "Burger House",
      "price": 249,
      "rating": 4.7,
      "image": null,
    },
    {
      "name": "White Sauce Pasta",
      "restaurant": "Italian Kitchen",
      "price": 279,
      "rating": 4.6,
      "image": null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              CustomSearchBar(),

              const SizedBox(height: 30),

              RecentSearchSection(
                recentSearches: recentSearches,
                onSearchTap: (value) {},
              ),

              const SizedBox(height: 30),

              PopularDishesSection(
                dishes: popularDishes,
                onDishTap: (dish) {},
              ),

              const SizedBox(height: 30),

              const Text(
                "Recommended For You",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 340,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedFoods.length,

                  itemBuilder: (context, index) {
                    return FoodCard(
                      food: recommendedFoods[index],
                      onTap: () {},
                      onAddToCart: () {},
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}