class Endpoints {
  static const String baseUrl =  "https://www.themealdb.com/api/json/v1/1";

  //get all categories
  static const String categories = "$baseUrl/list.php?c=list";

  // Get meals by category
  static String mealsByCategory(String category) =>
      "$baseUrl/filter.php?c=$category";

  // Search meal by name
  static String searchMeal(String meal) => "$baseUrl/search.php?s=$meal";

  // Get meal details
  static String mealDetails(String id) => "$baseUrl/lookup.php?i=$id";

  // Random meal
  static const String randomMeal = "$baseUrl/random.php";
}
