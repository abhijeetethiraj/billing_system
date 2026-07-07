# Billing System

A Flutter food-ordering app built with Provider, SQLite, API integration, and Razorpay checkout.

This repository is currently organized around a simple flow:

1. Load food categories and meals from TheMealDB API.
2. Open meal detail pages from Home, Category, or Search.
3. Add items to a persistent cart stored in SQLite.
4. Pay using Razorpay test checkout.
5. Save successful payments into order history.

## Tech Stack

- Flutter
- Provider for state management
- Dio for HTTP requests
- sqflite for local persistence
- sqflite_common_ffi for desktop/database startup support
- razorpay_flutter for checkout

## How The App Flows

```text
TheMealDB API
   ↓
ApiService
   ↓
HomeViewmodel / SearchViewModel
   ↓
Views
   ↓
CartProvider / OrderProvider
   ↓
SQLite
```

## Project Structure

### `lib/main.dart`

App entry point.

- Registers `HomeViewmodel`, `SearchViewModel`, `CartProvider`, and `OrderProvider`.
- Initializes SQLite FFI on desktop platforms.
- Opens the shared app shell.

### `lib/data/api/`

- `api_service.dart` - Dio wrapper with basic error handling.
- `endpoints.dart` - TheMealDB URLs for categories, meals by category, search, lookup, and random meal.
- `api_response.dart` - Simple success/error response wrapper.

### `lib/models/`

- `category_model.dart` - Category JSON model.
- `meal_model.dart` - Meal and meal response models.
- `food_model.dart` - UI/cart-friendly food model.
- `cart_model.dart` - Cart item model with SQLite serialization.
- `order_model.dart` - Stored order summary model.
- `order_item_model.dart` - Stored order item model.

### `lib/viewmodels/`

- `home_viewmodel.dart` - Loads categories, category meals, and featured meal data.
- `search_viewmodel.dart` - Searches meals by name.

### `lib/provider/`

- `cart_provider.dart` - Manages cart state and keeps it synced to SQLite.
- `order_provider.dart` - Loads and stores completed orders.
- `food_provider.dart` - Experimental/provider-based seafood list loader.

### `lib/services/`

- `cart_database.dart` - SQLite helper for cart persistence.
- `order_database.dart` - SQLite helper for saved orders.

### `lib/views/`

- `navigation/app_shell.dart` - Shared bottom navigation shell.
- `home/home.dart` - Home screen with categories, featured meals, and popular meal cards.
- `search/search_page.dart` - Search results page with add-to-cart support.
- `category/category_meals_page.dart` - Full list of meals for one selected category.
- `details/food_details_page.dart` - Meal detail page with add-to-cart action.
- `cart/cart_page.dart` - Cart screen with summary and checkout button.
- `payment/payments_page.dart` - Razorpay checkout popup launcher.
- `orders/order_history_page.dart` - Saved order history list.

### `lib/views/widgets/`

- `bottom_nav_bar.dart` - Shared bottom navigation bar.
- `cart_item.dart` - Cart row widget.
- `food_cart.dart` - Food card widget used in some screens.
- `search_bar.dart` - Search UI widget.

### `lib/widgets/`

- `food_card.dart` - Meal card widget used by the search screen.

### `lib/utils/`

- `constants.dart` - Currently empty.
- `colors.dart` - Currently empty.
- `routes.dart` - Currently empty.

## Current Behavior

- Home shows categories and meals from TheMealDB.
- Tapping a category opens a category meals page.
- Tapping a meal opens the detail page.
- Add to Cart saves to SQLite.
- Checkout opens Razorpay test payment.
- Successful payment saves an order into order history and clears the cart.

## Files That Are Still Placeholders

These files exist but are currently empty or not used yet:

- `lib/views/js.dart`
- `lib/views/orders/order_detail_page.dart`
- `lib/utils/constants.dart`
- `lib/utils/colors.dart`
- `lib/utils/routes.dart`

## How To Rebuild This App Cleanly

If you want to rewrite this project as human-written code, start in this order:

1. Build the API layer first.
   - Create `ApiService`.
   - Add endpoint constants.
   - Confirm category and meal JSON parsing.

2. Build the models.
   - `Meal`
   - `Category`
   - `FoodModel`
   - `CartModel`
   - `OrderModel`
   - `OrderItemModel`

3. Build the state layer.
   - `HomeViewmodel` for categories and featured meals.
   - `SearchViewModel` for search results.
   - `CartProvider` for cart state.
   - `OrderProvider` for order history.

4. Build persistence.
   - SQLite helper for cart.
   - SQLite helper for orders.
   - Load data on app start.

5. Build the UI.
   - Shared shell with bottom navigation.
   - Home screen.
   - Category meals page.
   - Search page.
   - Detail page.
   - Cart page.
   - Payment page.
   - Order history page.

6. Connect checkout.
   - Open Razorpay popup from the cart checkout button.
   - On success, save the order and clear the cart.

## Roadmap

### Phase 1: Foundation

- Create the Flutter project structure in `lib/main.dart` and the folder layout under `lib/`.
- Add packages in `pubspec.yaml`: `provider`, `dio`, `sqflite`, `sqflite_common_ffi`, `path`, and `razorpay_flutter`.
- Create the base folder structure under `lib/data/`, `lib/models/`, `lib/provider/`, `lib/services/`, `lib/views/`, and `lib/utils/`.

### Phase 2: Data Layer

- Build `lib/data/api/api_service.dart`, `lib/data/api/endpoints.dart`, and `lib/data/api/api_response.dart`.
- Confirm TheMealDB category, search, random-meal, and lookup calls inside `lib/data/api/endpoints.dart`.
- Create the model classes in `lib/models/meal_model.dart`, `lib/models/category_model.dart`, `lib/models/food_model.dart`, `lib/models/cart_model.dart`, `lib/models/order_model.dart`, and `lib/models/order_item_model.dart`.

### Phase 3: State Layer

- Implement `lib/viewmodels/home_viewmodel.dart` for category and featured data.
- Implement `lib/viewmodels/search_viewmodel.dart` for meal search.
- Implement `lib/provider/cart_provider.dart` for cart state and SQLite sync.
- Implement `lib/provider/order_provider.dart` for saved orders.
- Keep `lib/provider/food_provider.dart` only if you still want the experimental seafood loader.

### Phase 4: Local Storage

- Finish `lib/services/cart_database.dart` for cart SQLite.
- Finish `lib/services/order_database.dart` for order SQLite.
- Load both cart and order data on app start from `lib/views/navigation/app_shell.dart`.

### Phase 5: UI Screens

- Build the shared app shell in `lib/views/navigation/app_shell.dart` and `lib/views/widgets/bottom_nav_bar.dart`.
- Build Home in `lib/views/home/home.dart`.
- Build Search in `lib/views/search/search_page.dart` and `lib/widgets/food_card.dart`.
- Build Category Meals in `lib/views/category/category_meals_page.dart`.
- Build Food Details in `lib/views/details/food_details_page.dart`.
- Build Cart in `lib/views/cart/cart_page.dart` and `lib/views/widgets/cart_item.dart`.
- Build Payment in `lib/views/payment/payments_page.dart`.
- Build Order History in `lib/views/orders/order_history_page.dart`.
- Connect meal taps from Home, Search, and Category to the detail page files above.
- Connect checkout from `lib/views/cart/cart_page.dart` to `lib/views/payment/payments_page.dart`.

### Phase 6: Payment and History

- Open Razorpay popup from `lib/views/payment/payments_page.dart`.
- On payment success, save the order using `lib/provider/order_provider.dart` and `lib/services/order_database.dart`.
- Clear the cart using `lib/provider/cart_provider.dart` and `lib/services/cart_database.dart`.
- Show the order in `lib/views/orders/order_history_page.dart`.

### Phase 7: Polish

- Clean unused files and placeholder code such as `lib/views/js.dart`, `lib/utils/constants.dart`, `lib/utils/colors.dart`, and `lib/utils/routes.dart`.
- Remove duplicate widgets or repeated UI logic across `lib/widgets/` and `lib/views/widgets/`.
- Add proper error handling and loading states in `lib/viewmodels/`, `lib/provider/`, and `lib/views/`.
- Apply final UI styling and naming cleanup across all view files.

### Final End State

The app should end with this flow:

```text
Home / Category / Search
    → Food Details
    → Add to Cart
    → Cart
    → Razorpay Payment
    → Save Order
    → Order History
```

## Setup And Run

```bash
flutter pub get
flutter run
```

If you are testing on desktop, SQLite FFI is initialized in `main.dart`.



## Team

- Abhijeet
- Prasanna
- Manasvi
- Shreya
