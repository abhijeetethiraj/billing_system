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
  Meal? featuredMeal;
  List<Meal> vegMeals = [];
  List<Meal> nonVegMeals = [];

  String selectedCategory = "";

  Future<void> loadDietMeals() async {
    if (vegMeals.isNotEmpty && nonVegMeals.isNotEmpty) return;

    try {
      final vegResponse = await _apiService.get(Endpoints.mealsByCategory('Vegetarian'));
      if (vegResponse.isSuccess) {
        vegMeals = MealResponse.fromJson(vegResponse.data).meals;
      }

      final nonVegResponse = await _apiService.get(Endpoints.mealsByCategory('Chicken'));
      if (nonVegResponse.isSuccess) {
        nonVegMeals = MealResponse.fromJson(nonVegResponse.data).meals;
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> getRandomMeal() async {
    final response = await _apiService.get(Endpoints.randomMeal);

    if (response.isSuccess) {
      featuredMeal = MealResponse.fromJson(response.data).meals.first;
    }
  }

  Future<void> getCategories() async {
    isLoading = true;
    notifyListeners();

    await getRandomMeal();

    final response = await _apiService.get(Endpoints.categories);

    if (response.isSuccess) {
      final categoryResponse = CategoryResponse.fromJson(response.data);

      // First assign categories
      categories = categoryResponse.meals;

      // Then load thumbnail for each category
      for (final category in categories) {
        final mealResponse = await _apiService.get(
          Endpoints.mealsByCategory(category.strCategory),
        );

        if (mealResponse.isSuccess) {
          final meals = MealResponse.fromJson(mealResponse.data).meals;

          if (meals.isNotEmpty) {
            category.thumbnail = meals.first.strMealThumb;
          }
        }
      }

      // Load meals for first category
      if (categories.isNotEmpty) {
        await getMealsByCategory(categories.first.strCategory);
      }

      await loadDietMeals();

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

    final response = await _apiService.get(Endpoints.mealsByCategory(category));

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
