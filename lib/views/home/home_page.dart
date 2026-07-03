import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/food_provider.dart';
import '../../provider/cart_provider.dart';
import '../widgets/food_cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodProvider>().fetchFoods();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text("Discover Meals", style: TextStyle(color: Color(0xFF983D2A), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<FoodProvider>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFF983D2A)));
          if (viewModel.errorMessage != null) return Center(child: Text("Error: ${viewModel.errorMessage}"));

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: viewModel.availableFoods.length,
            itemBuilder: (context, index) {
              final food = viewModel.availableFoods[index];
              return FoodCartWidget(
                food: food,
                onAddToCart: () {
                  context.read<CartProvider>().addToCart(food);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${food.name} added to cart!'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: const Color(0xFF983D2A),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}