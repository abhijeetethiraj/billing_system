import 'package:flutter/material.dart';
import 'package:billing_system/viewmodels/search_viewmodel.dart';
import 'package:billing_system/models/food_model.dart';
import 'package:billing_system/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:billing_system/views/details/food_details_page.dart';
import '../../widgets/food_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _controller,
                onSubmitted: (value) {
                  vm.searchMeal(value);
                },
                decoration: InputDecoration(
                  hintText: "Search food...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      vm.searchMeal(_controller.text);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Recent Searches
              const SizedBox(height: 30),

              const Text(
                "Search Results",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.searchMeals.length,

                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      height: 340,
                      child: FoodCard(
                        meal: vm.searchMeals[index],
                        onTap: () {
                          final meal = vm.searchMeals[index];
                          final price = (120 + meal.idMeal.hashCode % 250).toDouble();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodDetailsPage(
                                meal: meal,
                                price: price,
                              ),
                            ),
                          );
                        },
                        onAddToCart: () async {
                          final meal = vm.searchMeals[index];
                          final price = (120 + meal.idMeal.hashCode % 250).toDouble();

                          try {
                            await context.read<CartProvider>().addToCart(
                                FoodModel(
                                  id: meal.idMeal,
                                  name: meal.strMeal,
                                  restaurant: 'Restaurant',
                                  price: price,
                                  image: meal.strMealThumb,
                                ),
                              );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${meal.strMeal} added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to add to cart: $error'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
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
