import 'package:billing_system/views/cart/cart_page.dart';
import 'package:billing_system/views/home/home.dart';
import 'package:billing_system/views/orders/order_history_page.dart';
import 'package:billing_system/views/search/search_page.dart';
import 'package:billing_system/views/widgets/bottom_nav_bar.dart';
import 'package:billing_system/provider/cart_provider.dart';
import 'package:billing_system/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppShell extends StatefulWidget {
  final int initialIndex;

  const AppShell({super.key, this.initialIndex = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().loadCartItems();
      context.read<OrderProvider>().loadOrders();
    });
  }

  late final List<Widget> _pages = [
    HomeScreen(
      onSearchTap: () => setState(() {
        _currentIndex = 1;
      }),
    ),
    const SearchPage(),
    const CartPage(),
    const OrderHistoryPage(),
    const _ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Text(
            'Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
