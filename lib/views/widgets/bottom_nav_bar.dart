import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.grey.shade500,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        const BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: currentIndex == 2 ? const Color(0xFFFF6B3A) : Colors.transparent, shape: BoxShape.circle),
            child: Icon(Icons.shopping_cart_outlined, color: currentIndex == 2 ? Colors.white : Colors.grey.shade500),
          ),
          label: "Cart",
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: "Orders"),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}
