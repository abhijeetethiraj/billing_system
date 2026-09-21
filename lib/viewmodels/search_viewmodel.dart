import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:billing_system/data/api/api_service.dart';
import 'package:billing_system/data/api/endpoints.dart';
import 'package:billing_system/models/meal_model.dart';

class SearchViewModel extends ChangeNotifier {
  static const String _historyKey = 'search_history';
  final ApiService _apiService = ApiService();

  bool isLoading = false;
  String errorMessage = "";
  List<Meal> searchMeals = [];
  List<String> searchHistory = [];
  List<Meal> popularMeals = [];
  bool isPopularLoading = false;
  String currentQuery = "";

  SearchViewModel() {
    loadHistory();
    loadPopularMeals();
  }

  Future<void> loadPopularMeals() async {
    if (popularMeals.isNotEmpty) return;
    isPopularLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get(Endpoints.searchMeal('c'));
      if (response.isSuccess) {
        final data = MealResponse.fromJson(response.data);
        popularMeals = data.meals;
      }
    } catch (_) {}

    isPopularLoading = false;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      searchHistory = prefs.getStringList(_historyKey) ?? [];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> searchMeal(String mealName) async {
    final query = mealName.trim();
    currentQuery = query;

    if (query.isEmpty) {
      searchMeals.clear();
      errorMessage = "";
      notifyListeners();
      return;
    }

    // Save to search history (deduplicate and keep newest at index 0)
    await _saveHistory(query);

    isLoading = true;
    errorMessage = "";
    notifyListeners();

    final response = await _apiService.get(
      Endpoints.searchMeal(query),
    );

    if (response.isSuccess) {
      final data = MealResponse.fromJson(response.data);
      searchMeals = data.meals;
      if (searchMeals.isEmpty) {
        errorMessage = "No meals found for '$query'";
      }
    } else {
      searchMeals = [];
      errorMessage = response.errorMessage ?? "No meals found for '$query'";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _saveHistory(String query) async {
    searchHistory.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    searchHistory.insert(0, query);
    if (searchHistory.length > 10) {
      searchHistory = searchHistory.sublist(0, 10);
    }
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_historyKey, searchHistory);
    } catch (_) {}
  }

  Future<void> removeHistoryItem(String query) async {
    searchHistory.remove(query);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_historyKey, searchHistory);
    } catch (_) {}
  }

  Future<void> clearHistory() async {
    searchHistory.clear();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (_) {}
  }

  void clearSearch() {
    currentQuery = "";
    searchMeals.clear();
    errorMessage = "";
    notifyListeners();
  }
}