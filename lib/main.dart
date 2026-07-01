// import 'package:flutter/material.dart';
// import 'data/api/api_service.dart';
// import 'data/api/endpoints.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final apiService = ApiService();

//   final response = await apiService.get(Endpoints.categories);

//   if (response.isSuccess) {
//     final List list = response.data['meals'];
//     final categories = list.where((item) => item['strCategory'] != 'Beef');

//     for (var cat in categories) {
//       debugPrint("Category: ${cat['strCategory']}");
//     }
//   } else {
//     debugPrint("Error: ${response.errorMessage}");
//   }
// }
// above is for food categories and meals, below is for products and categories from themealdb api

import 'package:flutter/material.dart';
import 'data/api/api_service.dart';
import 'data/api/endpoints.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();

  final catResponse = await apiService.get(Endpoints.categories);

  if (catResponse.isSuccess) {
    final List list = catResponse.data['meals'];
    final categories = list.where((item) => item['strCategory'] != 'Beef');

    for (var cat in categories) {
      String name = cat['strCategory'];
      debugPrint("Category: $name");

      final mealResponse = await apiService.get(Endpoints.mealsByCategory(name));

      if (mealResponse.isSuccess) {
        final List meals = mealResponse.data['meals'];
        for (var meal in meals) {
          debugPrint(" - ${meal['strMeal']}");
        }
      }
    }
  } else {
    debugPrint("Error: ${catResponse.errorMessage}");
  }
}
