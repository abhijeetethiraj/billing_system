import 'package:flutter/material.dart';
import 'package:billing_system/data/api/api_service.dart';
import 'package:billing_system/data/api/endpoints.dart';
import 'package:billing_system/models/meal_model.dart';

class SearchViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isLoading = false;
  String errorMessage = "";

  List<Meal> searchMeals = [];

  Future<void> searchMeal(String mealName) async {
    if (mealName.trim().isEmpty) {
      searchMeals.clear();
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = "";
    notifyListeners();

    final response = await _apiService.get(
      Endpoints.searchMeal(mealName),
    );

    if (response.isSuccess) {
      final data = MealResponse.fromJson(response.data);
      print(response.data);
      searchMeals = data.meals;
    } else {
      searchMeals = [];
      errorMessage = response.errorMessage ?? "No meals found";
    }

    isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    searchMeals.clear();
    errorMessage = "";
    notifyListeners();
  }
}