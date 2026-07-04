import 'package:flutter/foundation.dart';

class CategoryResponse {
  final List<Category> meals;

  CategoryResponse({
    required this.meals,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      meals: (json['meals'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
    );
  }
}

class Category {
  final String strCategory;
  String? thumbnail;

  Category({
    required this.strCategory,
    this.thumbnail,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      strCategory: json['strCategory'],
    );
  }
}