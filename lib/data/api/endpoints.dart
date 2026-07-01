class Endpoints {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  static const String categories = "$baseUrl/list.php?c=list";

  static String mealsByCategory(String category) => "$baseUrl/filter.php?c=$category";
}
