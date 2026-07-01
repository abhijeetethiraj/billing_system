import 'package:flutter/material.dart';

class RecentSearchSection extends StatelessWidget {
  final List<String> recentSearches;
  final Function(String)? onSearchTap;

  const RecentSearchSection({
    super.key,
    required this.recentSearches,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Searches",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        recentSearches.isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: const Text(
                  "No recent searches",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              )
            : Wrap(
                spacing: 10,
                runSpacing: 10,
                children: recentSearches.map((item) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      if (onSearchTap != null) {
                        onSearchTap!(item);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.history,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
}