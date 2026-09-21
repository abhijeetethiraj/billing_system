import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int cartCount;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartCount = 0,
  });

  // Every icon gets the same padding so all five labels line up.
  Widget _icon(IconData icon, {Color? color, Color? background}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: background ?? Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cartSelected = currentIndex == 2;

    final cartIconWidget = _icon(
      Icons.shopping_cart_outlined,
      color: cartSelected ? Colors.white : cs.onSurfaceVariant,
      background: cartSelected ? const Color(0xFFFF6B3A) : null,
    );

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      // Selected/unselected colors come from the app theme.
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(icon: _icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: _icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(
          icon: cartCount > 0
              ? Badge.count(
                  count: cartCount,
                  backgroundColor: const Color(0xFFFF6B3A),
                  textColor: Colors.white,
                  child: cartIconWidget,
                )
              : cartIconWidget,
          label: "Cart",
        ),
        BottomNavigationBarItem(icon: _icon(Icons.receipt_long_outlined), label: "Orders"),
        BottomNavigationBarItem(icon: _icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}