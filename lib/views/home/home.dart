import 'package:billing_system/models/meal_model.dart';
import 'package:billing_system/viewmodels/home_viewmodel.dart';
import 'package:billing_system/views/category/category_meals_page.dart';
import 'package:billing_system/views/details/food_details_page.dart';
import 'package:billing_system/views/home/featured_carousel.dart';
import 'package:billing_system/views/home/popular_hero_card.dart';
import 'package:billing_system/views/widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;

  const HomeScreen({super.key, this.onSearchTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<HomeViewmodel>().getCategories();
    });
  }

  void _openDetails(Meal meal, double price) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailsPage(meal: meal, price: price),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewmodel>();
    final cs = Theme.of(context).colorScheme;

    final featured = vm.featuredMeal;
    final featuredPrice = featured == null
        ? 0.0
        : (120 + featured.idMeal.hashCode % 300).toDouble();

    return SafeArea(
      child: Builder(
        builder: (_) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage.isNotEmpty) {
            return Center(child: Text(vm.errorMessage));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ThemeToggleButton(),
                      const Text(
                        'GourmetGo',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ---- Popular Near You (now first) ----
                  if (featured != null) ...[
                    const Text(
                      'Popular Near You',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    PopularHeroCard(
                      meal: featured,
                      price: featuredPrice,
                      onTap: () => _openDetails(featured, featuredPrice),
                    ),
                    const SizedBox(height: 30),
                  ],

                  // ---- Categories ----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: vm.categories.length,
                      itemBuilder: (context, index) {
                        final category = vm.categories[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryMealsPage(
                                  categoryName: category.strCategory,
                                  categoryImage: category.thumbnail,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 15),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: cs.surfaceContainerHighest,
                                  backgroundImage: category.thumbnail != null
                                      ? NetworkImage(category.thumbnail!)
                                      : null,
                                  child: category.thumbnail == null
                                      ? const Icon(Icons.fastfood)
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.strCategory,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  // ---- Featured Today (auto-scrolling, loops) ----
                  if (vm.meals.isNotEmpty) ...[
                    const Text(
                      'Featured Today',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    FeaturedCarousel(
                      meals: vm.meals.take(8).toList(),
                      onMealTap: _openDetails,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}