import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:billing_system/models/food_model.dart';
import 'package:billing_system/models/meal_model.dart';
import 'package:billing_system/provider/cart_provider.dart';
import 'package:billing_system/utils/apptheme.dart';
import 'package:billing_system/utils/colors.dart';
import 'package:billing_system/viewmodels/search_viewmodel.dart';
import 'package:billing_system/views/details/food_details_page.dart';
import '../../widgets/food_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  static const List<String> _popularSuggestions = [
    'Pizza',
    'Burger',
    'Biryani',
    'Chicken',
    'Pasta',
    'Salad',
    'Cake',
    'Soup',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSelectQuery(String query) {
    _controller.text = query;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    context.read<SearchViewModel>().searchMeal(query);
    setState(() {});
  }

  void _openDetails(Meal meal, double price) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailsPage(meal: meal, price: price),
      ),
    );
  }

  Future<void> _addToCart(Meal meal, double price) async {
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

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${meal.strMeal} added to cart'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    final cs = context.cs;
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLow,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input Bar
              Container(
                decoration: BoxDecoration(
                  color: cs.surfaceContainer,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (value) => vm.searchMeal(value),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Search food...",
                    hintStyle: TextStyle(color: cs.onSurfaceVariant),
                    prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close, color: cs.onSurfaceVariant),
                            onPressed: () {
                              _controller.clear();
                              vm.clearSearch();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 1. Loading State
              if (vm.isLoading) ...[
                const SizedBox(height: 60),
                const Center(child: CircularProgressIndicator()),
              ]
              // 2. Active Search Results State
              else if (_controller.text.isNotEmpty && vm.searchMeals.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Search Results",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      "${vm.searchMeals.length} found",
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vm.searchMeals.length,
                  itemBuilder: (context, index) {
                    final meal = vm.searchMeals[index];
                    final price = (120 + meal.idMeal.hashCode % 250).toDouble();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        height: 340,
                        child: FoodCard(
                          width: double.infinity,
                          margin: EdgeInsets.zero,
                          meal: meal,
                          onTap: () => _openDetails(meal, price),
                          onAddToCart: () => _addToCart(meal, price),
                        ),
                      ),
                    );
                  },
                ),
              ]
              // 3. No Results Found State
              else if (_controller.text.isNotEmpty && vm.errorMessage.isNotEmpty) ...[
                const SizedBox(height: 50),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        vm.errorMessage,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Try searching for another dish or ingredient",
                        style: TextStyle(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ]
              // 4. Default State: Suggestions + Search History + Recommended Food Boxes
              else ...[
                // Recent Searches
                if (vm.searchHistory.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.history, size: 20, color: cs.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text(
                            "Recent Searches",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => vm.clearHistory(),
                        child: Text(
                          "Clear All",
                          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: vm.searchHistory.map((historyItem) {
                      return InputChip(
                        avatar: Icon(
                          Icons.history,
                          size: 16,
                          color: cs.onSurfaceVariant,
                        ),
                        label: Text(historyItem),
                        labelStyle: TextStyle(
                          color: cs.onSurface,
                          fontSize: 13,
                        ),
                        backgroundColor: cs.surfaceContainer,
                        side: BorderSide(
                          color: cs.outlineVariant.withValues(alpha: 0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () => _onSelectQuery(historyItem),
                        onDeleted: () => vm.removeHistoryItem(historyItem),
                        deleteIconColor: cs.onSurfaceVariant,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 25),
                ],

                // Popular Cravings
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 20, color: AppColors.brand),
                    const SizedBox(width: 8),
                    Text(
                      "Popular Cravings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _popularSuggestions.map((suggestion) {
                    return ActionChip(
                      label: Text(suggestion),
                      labelStyle: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                      backgroundColor: cs.surfaceContainer,
                      side: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.4),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      onPressed: () => _onSelectQuery(suggestion),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),

                // Recommended Food Boxes (Trending / Top Picks)
                if (vm.popularMeals.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.restaurant_menu, size: 20, color: cs.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text(
                            "Recommended For You",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.brand.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Top Picks",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brand,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 340,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: vm.popularMeals.take(8).length,
                      itemBuilder: (context, index) {
                        final meal = vm.popularMeals[index];
                        final price = (120 + meal.idMeal.hashCode % 250).toDouble();

                        return FoodCard(
                          meal: meal,
                          onTap: () => _openDetails(meal, price),
                          onAddToCart: () => _addToCart(meal, price),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  // More Dishes to Explore (Vertical Food Boxes)
                  Text(
                    "Explore More Dishes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vm.popularMeals.skip(8).take(6).length,
                    itemBuilder: (context, index) {
                      final meal = vm.popularMeals.skip(8).toList()[index];
                      final price = (120 + meal.idMeal.hashCode % 250).toDouble();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          height: 340,
                          child: FoodCard(
                            width: double.infinity,
                            margin: EdgeInsets.zero,
                            meal: meal,
                            onTap: () => _openDetails(meal, price),
                            onAddToCart: () => _addToCart(meal, price),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
