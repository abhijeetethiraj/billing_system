import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:billing_system/provider/cart_provider.dart';
import 'package:billing_system/provider/order_provider.dart';
import 'package:billing_system/utils/colors.dart';
import 'package:billing_system/views/cart/cart_page.dart';
import 'package:billing_system/views/home/home.dart';
import 'package:billing_system/views/orders/order_history_page.dart';
import 'package:billing_system/views/profiles/profile_page.dart';
import 'package:billing_system/views/search/search_page.dart';
import 'package:billing_system/views/widgets/bottom_nav_bar.dart';

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
      onProfileTap: () => setState(() {
        _currentIndex = 4;
      }),
    ),
    const SearchPage(),
    const CartPage(),
    const OrderHistoryPage(),
    const ProfilePage(),
  ];

  Widget _buildFloatingCartBar({
    required BuildContext context,
    required CartProvider cart,
    required int totalItems,
    required VoidCallback onTap,
  }) {
    if (cart.cartItems.isEmpty) return const SizedBox.shrink();

    // Summary of all added dishes with quantity (e.g. "Chicken Biryani (x2), Butter Naan")
    final itemsSummary = cart.cartItems
        .map((item) => item.quantity > 1 ? '${item.name} (x${item.quantity})' : item.name)
        .join(', ');

    // Take up to 3 thumbnails for overlapping avatar stack
    final previewItems = cart.cartItems.take(3).toList();
    final extraCount = cart.cartItems.length - previewItems.length;
    final totalSlots = previewItems.length + (extraCount > 0 ? 1 : 0);
    final stackWidth = ((totalSlots - 1) * 16.0) + 38.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.brand,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.brand.withValues(alpha: 0.45),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Overlapping circular dish thumbnails
            SizedBox(
              width: stackWidth,
              height: 38,
              child: Stack(
                children: [
                  ...previewItems.asMap().entries.map((e) {
                    return Positioned(
                      left: e.key * 16.0,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            e.value.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const ColoredBox(
                              color: Colors.white24,
                              child: Icon(Icons.restaurant, size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  if (extraCount > 0)
                    Positioned(
                      left: previewItems.length * 16.0,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black87,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "+$extraCount",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Item summary text & total price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$totalItems ${totalItems == 1 ? 'ITEM' : 'ITEMS'} • ₹${cart.subtotal.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    itemsSummary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // View Cart Action Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View Cart",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 15,
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
    final cart = context.watch<CartProvider>();
    final cartItems = cart.cartItems;
    final totalItems = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
    // Show floating bar whenever cart has items, except when user is already on the Cart tab (index 2)
    final showFloatingBar = cartItems.isNotEmpty && _currentIndex != 2;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              offset: showFloatingBar ? Offset.zero : const Offset(0, 1.5),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: showFloatingBar ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !showFloatingBar,
                  child: cartItems.isEmpty
                      ? const SizedBox.shrink()
                      : _buildFloatingCartBar(
                          context: context,
                          cart: cart,
                          totalItems: totalItems,
                          onTap: () {
                            setState(() {
                              _currentIndex = 2; // Switch directly to the Cart Tab
                            });
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        cartCount: totalItems,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
