import 'dart:async';

import 'package:billing_system/models/meal_model.dart';
import 'package:billing_system/utils/apptheme.dart';
import 'package:billing_system/utils/colors.dart';
import 'package:flutter/material.dart';

/// "Featured Today" carousel.
///
/// * Slides to the next card every [autoPlayInterval] and loops forever.
/// * The moment the user drags it, auto-play stops. It starts again
///   [autoPlayInterval] after they let go.
///   (To stop it for good instead, delete the `_startAutoPlay();` call
///   inside `_handleScroll`.)
class FeaturedCarousel extends StatefulWidget {
  final List<Meal> meals;
  final void Function(Meal meal, double price) onMealTap;
  final Duration autoPlayInterval;

  const FeaturedCarousel({super.key, required this.meals, required this.onMealTap, this.autoPlayInterval = const Duration(seconds: 3)});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  // Start far into an "infinite" page range so the user can swipe
  // backwards as well as forwards without ever hitting an end.
  static const int _loopMultiplier = 1000;

  late final PageController _controller;
  Timer? _timer;
  int _current = 0;
  bool _userIsDragging = false;

  int get _count => widget.meals.length;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.78, initialPage: _count * _loopMultiplier);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (_count < 2) {
      return;
    }

    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted || !_controller.hasClients) {
        return;
      }
      _controller.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    });
  }

  bool _handleScroll(ScrollNotification notification) {
    // dragDetails is only set when a finger starts the scroll, so our own
    // nextPage() animations don't count as the user taking over.
    if (notification is ScrollStartNotification && notification.dragDetails != null) {
      _userIsDragging = true;
      _timer?.cancel();
    } else if (notification is ScrollEndNotification && _userIsDragging) {
      _userIsDragging = false;
      _startAutoPlay();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_count == 0) {
      return const SizedBox.shrink();
    }

    final cs = context.cs;

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScroll,
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (page) {
                setState(() {
                  _current = page % _count;
                });
              },
              itemBuilder: (context, page) {
                final index = page % _count;
                final meal = widget.meals[index];
                final price = ((index + 1) * 120).toDouble();

                return _FeaturedCard(meal: meal, price: price, onTap: () => widget.onMealTap(meal, price));
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_count, (i) {
            final active = i == _current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: active ? 22 : 6,
              decoration: BoxDecoration(color: active ? AppColors.brand : cs.outlineVariant, borderRadius: BorderRadius.circular(3)),
            );
          }),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Meal meal;
  final double price;
  final VoidCallback onTap;

  const _FeaturedCard({required this.meal, required this.price, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  meal.strMealThumb,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: cs.surfaceContainerHighest,
                    child: const Center(child: Icon(Icons.fastfood, size: 40)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    meal.strMeal,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹ ${price.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.deepOrange, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
