import 'package:billing_system/data/api/api_service.dart';
import 'package:billing_system/data/api/endpoints.dart';
import 'package:billing_system/models/category_model.dart';
import 'package:billing_system/models/meal_model.dart';

import 'package:flutter/material.dart';

class HomeViewmodel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Category> categories = [];

  bool isLoading = false;

  String errorMessage = '';
  List<Meal> meals = [];

  String selectedCategory = "";

Future<void> getCategories() async {
  isLoading = true;
  notifyListeners();

  final response = await _apiService.get(Endpoints.categories);

  if (response.isSuccess) {
    final categoryResponse = CategoryResponse.fromJson(response.data);

    categories = categoryResponse.meals;
    for (final category in categories) {
  final mealResponse =
      await _apiService.get(Endpoints.mealsByCategory(category.strCategory));

  if (mealResponse.isSuccess) {
    final meals = MealResponse.fromJson(mealResponse.data).meals;

    if (meals.isNotEmpty) {
      category.thumbnail = meals.first.strMealThumb;
    }
  }
}

if (categories.isNotEmpty) {
  await getMealsByCategory(categories.first.strCategory);
}

    if (categories.isNotEmpty) {
      await getMealsByCategory(categories.first.strCategory);
    }

    errorMessage = '';
  } else {
    errorMessage = response.errorMessage ?? 'Something went wrong';
  }

  isLoading = false;
  notifyListeners();
}

Future<void> getMealsByCategory(String category) async {
  selectedCategory = category;

  isLoading = true;
  notifyListeners();

  final response =
      await _apiService.get(Endpoints.mealsByCategory(category));

  if (response.isSuccess) {
    final mealResponse = MealResponse.fromJson(response.data);

    meals = mealResponse.meals;

    errorMessage = '';
  } else {
    errorMessage = response.errorMessage ?? 'Something went wrong';
  }

  isLoading = false;
  notifyListeners();
}
}
