import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:billing_system/models/food_model.dart';
import 'package:billing_system/models/meal_model.dart';
import 'package:billing_system/provider/auth_provider.dart';
import 'package:billing_system/provider/cart_provider.dart';
import 'package:billing_system/utils/apptheme.dart';
import 'package:billing_system/utils/colors.dart';
import 'package:billing_system/viewmodels/home_viewmodel.dart';
import 'package:billing_system/views/category/category_meals_page.dart';
import 'package:billing_system/views/details/food_details_page.dart';
import 'package:billing_system/views/home/featured_carousel.dart';
import 'package:billing_system/views/home/popular_hero_card.dart';
import 'package:billing_system/views/profiles/profile_page.dart';
import 'package:billing_system/views/search/search_page.dart';
import 'package:billing_system/views/widgets/theme_toggle_button.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;

  const HomeScreen({
    super.key,
    this.onSearchTap,
    this.onProfileTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0: All, 1: Pure Veg, 2: Non-Veg
  int _dietFilter = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final vm = context.read<HomeViewmodel>();
      vm.getCategories();
      vm.loadDietMeals();
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

  Widget _buildVegBadge({required bool isVeg}) {
    final color = isVeg ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: isVeg ? BoxShape.circle : BoxShape.rectangle,
          ),
        ),
      ),
    );
  }

  Widget _buildDietFoodCard({
    required Meal meal,
    required double price,
    required bool isVeg,
    required ColorScheme cs,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => _openDetails(meal, price),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    meal.strMealThumb,
                    height: 125,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: _buildVegBadge(isVeg: isVeg),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.strMeal,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        "4.8",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "₹${price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brand,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: () => _addToCart(meal, price),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isVeg ? const Color(0xFF2E7D32) : AppColors.brand,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text(
                        "ADD",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewmodel>();
    final cs = context.cs;
    final isDark = context.isDark;

    final authUser = context.watch<AuthProvider>().user;
    final rawName = authUser?.displayName?.trim() ?? '';
    final name = rawName.isNotEmpty
        ? rawName
        : (authUser?.email?.isNotEmpty == true ? authUser!.email! : 'Foodie');
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

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

          if (vm.errorMessage.isNotEmpty && vm.categories.isEmpty) {
            return Center(child: Text(vm.errorMessage));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header (Theme Toggle + GourmetGo + User Profile Avatar)
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
                      GestureDetector(
                        onTap: () {
                          if (widget.onProfileTap != null) {
                            widget.onProfileTap!();
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProfilePage()),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.brand,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.brand.withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. Search Bar
                  GestureDetector(
                    onTap: () {
                      if (widget.onSearchTap != null) {
                        widget.onSearchTap!();
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 52,
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: cs.onSurfaceVariant),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'What are you craving?',
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: cs.surface,
                            child: Icon(Icons.tune, size: 16, color: cs.onSurface),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 3. Popular Near You (Hero Card)
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

                  // 4. Categories
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

                  // 5. Featured Today (Auto-scrolling carousel)
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
                    const SizedBox(height: 30),
                  ],

                  // 6. Diet Preferences Filter (All / Veg / Non-Veg)
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text("All Dishes"),
                        selected: _dietFilter == 0,
                        onSelected: (selected) {
                          if (selected) setState(() => _dietFilter = 0);
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        avatar: _buildVegBadge(isVeg: true),
                        label: const Text("Pure Veg"),
                        selected: _dietFilter == 1,
                        selectedColor: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                        onSelected: (selected) {
                          if (selected) setState(() => _dietFilter = 1);
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        avatar: _buildVegBadge(isVeg: false),
                        label: const Text("Non-Veg"),
                        selected: _dietFilter == 2,
                        selectedColor: const Color(0xFFC62828).withValues(alpha: 0.2),
                        onSelected: (selected) {
                          if (selected) setState(() => _dietFilter = 2);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 7. 🌱 PURE VEG SECTION
                  if ((_dietFilter == 0 || _dietFilter == 1) && vm.vegMeals.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildVegBadge(isVeg: true),
                            const SizedBox(width: 8),
                            Text(
                              "Pure Veg Delights",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "100% Green",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Fresh, plant-based & wholesome meals",
                      style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: vm.vegMeals.length,
                        itemBuilder: (context, index) {
                          final meal = vm.vegMeals[index];
                          final price = (99 + meal.idMeal.hashCode % 180).toDouble();

                          return _buildDietFoodCard(
                            meal: meal,
                            price: price,
                            isVeg: true,
                            cs: cs,
                            isDark: isDark,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  // 8. 🍗 NON-VEG SECTION
                  if ((_dietFilter == 0 || _dietFilter == 2) && vm.nonVegMeals.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildVegBadge(isVeg: false),
                            const SizedBox(width: 8),
                            Text(
                              "Non-Veg Specials",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC62828).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Meat & Poultry",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC62828),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Juicy, rich & protein-packed favorites",
                      style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: vm.nonVegMeals.length,
                        itemBuilder: (context, index) {
                          final meal = vm.nonVegMeals[index];
                          final price = (149 + meal.idMeal.hashCode % 260).toDouble();

                          return _buildDietFoodCard(
                            meal: meal,
                            price: price,
                            isVeg: false,
                            cs: cs,
                            isDark: isDark,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  // 9. 👨‍🍳 Chef's Selection / More to Explore (Vertical Feed)
                  if (vm.meals.length > 8) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Chef's Handpicked",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          "Best Sellers",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.brand,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: vm.meals.skip(8).take(6).length,
                      itemBuilder: (context, index) {
                        final meal = vm.meals.skip(8).toList()[index];
                        final price = (120 + meal.idMeal.hashCode % 250).toDouble();

                        return GestureDetector(
                          onTap: () => _openDetails(meal, price),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainer,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: cs.outlineVariant.withValues(alpha: 0.4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(
                                    meal.strMealThumb,
                                    width: 85,
                                    height: 85,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meal.strMeal,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: cs.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Freshly Prepared",
                                        style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.orange, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            "4.7",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: cs.onSurface,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "₹${price.toStringAsFixed(0)}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.brand,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton.filledTonal(
                                  onPressed: () => _addToCart(meal, price),
                                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}