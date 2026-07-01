import 'package:flutter/material.dart';

import '../../widgets/search_bar.dart';
import '../../widgets/recent_search_section.dart';
import '../../widgets/food_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  final List<String> recentSearches = const [
    "Pizza",
    "Burger",
    "Pasta",
    "Cold Coffee",
  ];

  final List<Map<String, dynamic>> searchResults = const [
    {
      "name": "Cheese Pizza",
      "restaurant": "Pizza Corner",
      "price": 299,
      "rating": 4.8,
      "image": null,
    },
    {
      "name": "Veg Burger",
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

              // Search Bar
              CustomSearchBar(),

              const SizedBox(height: 30),

              // Recent Searches
              RecentSearchSection(
                recentSearches: recentSearches,
                onSearchTap: (value) {},
              ),

              const SizedBox(height: 30),

              const Text(
                "Search Results",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchResults.length,

                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),

                    child: SizedBox(
                      height: 320,

                      child: FoodCard(
                        food: searchResults[index],
                        onTap: () {},
                        onAddToCart: () {},
                      ),
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}