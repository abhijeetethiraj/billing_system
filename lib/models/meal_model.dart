class MealResponse {
  final List<Meal> meals;

  MealResponse({required this.meals});

  factory MealResponse.fromJson(Map<String, dynamic> json) {
    return MealResponse(
      meals: (json['meals'] as List)
          .map((e) => Meal.fromJson(e))
          .toList(),
    );
  }
}

class Meal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
    );
  }
}