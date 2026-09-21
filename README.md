# GourmetGo – Billing System

A Flutter food-ordering and billing application built around a simple restaurant flow:

**Browse food → View details → Add to cart → Checkout → Save order → View order history**

The current `prasanna-dev` branch combines TheMealDB for food discovery, Provider for application state, SQLite for local cart/order persistence, Firebase Authentication for accounts, SharedPreferences for theme settings, and Razorpay test checkout.

---

## Features

### Authentication

- Firebase Email/Password sign in
- Firebase account creation
- Password reset email
- Auth gate that switches between Login and the main app
- Firebase user display name shown on the profile screen
- Sign out confirmation

### Food discovery

- TheMealDB category loading
- Meals by category
- Meal search
- Random meal used as the home-page featured meal
- Meal detail screen
- Network images with some fallback handling

### Cart and billing

- Add food to cart
- Increment/decrement quantity
- Remove cart item
- SQLite persistence for cart data
- Subtotal calculation
- Delivery fee
- Tax calculation
- Total amount calculation

### Payments and orders

- Razorpay test checkout integration
- Successful payment creates an order locally
- Cart is cleared after successful payment
- Order history stored in SQLite

### UI

- Home, Search, Cart, Orders and Profile tabs
- Light/dark/system theme selection
- Theme preference persisted with SharedPreferences
- Shared Material 3 theme/colors

---

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Application UI and platform support |
| Dart | Application language |
| Provider | State management |
| Dio | HTTP/API client |
| TheMealDB | Food/category/search data |
| sqflite | SQLite persistence on supported native platforms |
| sqflite_common_ffi | SQLite support for Windows/Linux/macOS |
| Firebase Core | Firebase initialization |
| Firebase Auth | User authentication |
| Cloud Firestore | User profile document storage |
| SharedPreferences | Theme preference persistence |
| razorpay_flutter | Razorpay checkout on Android/iOS |

The repository currently uses these package constraints in `pubspec.yaml`, including Dart SDK `^3.12.0`, Provider `^6.1.5+1`, Dio `^5.10.0`, SQLite packages, Firebase packages, and `razorpay_flutter ^1.4.0`.

---

## Application Architecture

The current code is organized into API, models, ViewModels/Providers, services and UI views.

```text
                 ┌─────────────────┐
                 │   TheMealDB API │
                 └────────┬────────┘
                          │
                        Dio
                          │
                 ┌────────▼────────┐
                 │   ApiService    │
                 └────────┬────────┘
                          │
              ┌───────────┴───────────┐
              │                       │
       HomeViewmodel           SearchViewModel
              │                       │
              └───────────┬───────────┘
                          │
                         UI
                          │
                  FoodDetailsPage
                          │
                          ▼
                   CartProvider
                          │
                          ▼
                    CartDatabase
                          │
                       SQLite
                          │
                          ▼
                   PaymentsPage
                          │
                    Razorpay test
                          │
                          ▼
                   OrderProvider
                          │
                          ▼
                   OrderDatabase
                          │
                       SQLite
```

Authentication is a parallel application-level flow:

```text
Firebase Auth
     │
     ▼
AuthService
     │
     ▼
AuthProvider
     │
     ▼
AuthGate
  ┌──┴─────────────┐
  │                │
Signed out      Signed in
  │                │
LoginPage       AppShell
```

---

## Project Structure

```text
lib/
├── main.dart
├── firebase_options.dart
│
├── data/
│   └── api/
│       ├── api_service.dart
│       ├── api_response.dart
│       └── endpoints.dart
│
├── models/
│   ├── category_model.dart
│   ├── meal_model.dart
│   ├── food_model.dart
│   ├── cart_model.dart
│   ├── order_model.dart
│   └── order_item_model.dart
│
├── provider/
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   ├── food_provider.dart
│   ├── order_provider.dart
│   └── theme_provider.dart
│
├── services/
│   ├── auth_services.dart
│   ├── cart_database.dart
│   └── order_database.dart
│
├── utils/
│   ├── apptheme.dart
│   ├── colors.dart
│   ├── constants.dart
│   └── routes.dart
│
├── viewmodels/
│   ├── home_viewmodel.dart
│   └── search_viewmodel.dart
│
├── views/
│   ├── auth/
│   │   ├── auth_gate.dart
│   │   └── login_page.dart
│   ├── category/
│   │   └── category_meals_page.dart
│   ├── cart/
│   │   └── cart_page.dart
│   ├── details/
│   │   └── food_details_page.dart
│   ├── home/
│   │   ├── home.dart
│   │   ├── featured_carousel.dart
│   │   └── popular_hero_card.dart
│   ├── navigation/
│   │   └── app_shell.dart
│   ├── orders/
│   │   ├── order_history_page.dart
│   │   └── order_detail_page.dart
│   ├── payment/
│   │   └── payments_page.dart
│   ├── profiles/
│   │   └── profile_page.dart
│   └── widgets/
│       ├── bottom_nav_bar.dart
│       ├── cart_item.dart
│       ├── food_cart.dart
│       └── theme_toggle_button.dart
│
└── widgets/
    └── food_card.dart
```

Some files are still placeholders or are not part of the active flow, especially `utils/constants.dart`, `utils/routes.dart`, `views/orders/order_detail_page.dart`, and the experimental `FoodProvider` path.

---

## API Endpoints

The app currently uses TheMealDB v1 API:

```text
Base URL:
https://www.themealdb.com/api/json/v1/1
```

Current endpoints:

```text
GET /list.php?c=list
GET /filter.php?c={category}
GET /search.php?s={meal}
GET /lookup.php?i={id}
GET /random.php
```

The app mainly consumes `idMeal`, `strMeal` and `strMealThumb` for the current meal model.

---

## Local Database

The application uses one SQLite database named:

```text
billing_system.db
```

### Tables

```text
cart_items
├── id
├── name
├── restaurant
├── price
├── quantity
└── image

orders
├── id
├── payment_id
├── amount
└── created_at

order_items
├── id
├── order_id
├── name
├── restaurant
├── price
├── quantity
└── image
```

The cart database replaces the current cart contents inside a transaction. Order creation also uses a transaction for the order and its items.

---

## Firebase

`main.dart` initializes Firebase with the generated `firebase_options.dart` configuration before starting the application.

Authentication currently uses Firebase Email/Password methods.

During sign-up, the app also attempts to store a profile in Firestore at:

```text
users/{uid}
```

with fields including `uid`, `name`, `email` and `createdAt`.

The Firestore write is intentionally caught so that a profile-write failure does not block Firebase account creation.

### Firebase setup

1. Create/configure the Firebase project.
2. Enable Email/Password authentication.
3. Run FlutterFire configuration when setting up a different Firebase project.
4. Confirm Firestore rules allow only the intended authenticated access.
5. Run:

```bash
flutter pub get
flutter run
```

---

## Platform Notes

### Android / iOS

These are the intended platforms for the current Razorpay integration. The official `razorpay_flutter` package currently supports Android and iOS only.

### Windows / Linux / macOS

The code initializes `sqflite_common_ffi` for desktop, so the SQLite portion is designed to work on desktop.

However, the current `razorpay_flutter` dependency is an Android/iOS plugin. Do not treat the existing checkout flow as desktop-compatible.

### Web

Firebase configuration exists for web, but the cart/order database code uses `sqflite` directly. Web SQLite support requires a web-compatible database implementation; the current code does not configure one in `main.dart`.

Therefore, the project should currently be treated as a native/desktop-oriented Flutter project rather than a fully supported web application.

---

# Known Bugs / Risks / Technical Debt

These are the main issues found while reviewing the current source.

## 1. Search can crash when TheMealDB returns `meals: null` — HIGH

`MealResponse.fromJson()` assumes:

```dart
(json['meals'] as List)
```

TheMealDB search response can contain a null `meals` value when nothing matches. That makes the cast/parsing path unsafe.

### Fix

Make the parser null-safe:

```dart
final mealsJson = json['meals'] as List? ?? [];
return MealResponse(
  meals: mealsJson
      .map((e) => Meal.fromJson(e as Map<String, dynamic>))
      .toList(),
);
```

---

## 2. Cart and order data are not scoped to the signed-in Firebase user — HIGH

The SQLite schema contains no `user_id`/`uid` field.

`CartProvider` and `OrderProvider` are also created above `AuthGate` and remain alive when the signed-in Firebase account changes.

This means multiple accounts using the same local installation can share the same local cart and order history.

### Fix

Add a user identifier to persisted data, for example:

```text
cart_items.user_id
orders.user_id
```

and always query/delete using the current Firebase UID.

Also reset or reload providers whenever authentication changes.

---

## 3. Product prices are mock values and are inconsistent — HIGH

Prices are generated from `String.hashCode` in several screens, but the formulas are not the same.

Examples in the current code include:

```dart
120 + meal.idMeal.hashCode % 250
```

and elsewhere:

```dart
120 + featured.idMeal.hashCode % 300
```

The carousel also uses:

```dart
(index + 1) * 120
```

This means the same meal can display different prices depending on where it is shown.

`hashCode` should not be used as a persistent business price.

### Fix

Create one pricing source, such as:

```dart
FoodPriceService
```

or store an explicit product price in the database/backend.

For a college/demo project, a simple hard-coded map keyed by `idMeal` is enough.

---

## 4. Payment success is trusted entirely from the client — HIGH for production

The payment page creates and saves the order immediately when the Razorpay success callback fires.

For a production payment system, payment verification should be performed using the Razorpay server-side verification flow and a server-controlled order amount.

### Fix

Use a backend/serverless function to:

1. Create the Razorpay order.
2. Keep the secret key on the server.
3. Receive payment identifiers/signature.
4. Verify the payment signature server-side.
5. Save the confirmed order.

The current implementation is appropriate only as a test/demo checkout flow.

---

## 5. Payment page uses hard-coded customer data — MEDIUM

The checkout configuration currently contains fixed test contact/email values.

### Fix

Use the authenticated user's email and, once a profile/contact field exists, the user's actual contact number.

---

## 6. Home page performs many sequential API requests — MEDIUM

To obtain category thumbnails, `HomeViewmodel.getCategories()` calls the meals-by-category endpoint once per category, sequentially.

So one home load becomes roughly:

```text
1 random-meal request
+ 1 category request
+ N category-meal requests
+ 1 first-category request
```

This increases launch time and API dependency.

### Fix

Use `Future.wait()` to parallelize the thumbnail requests, or add a cached/static category-image source.

---

## 7. Search UI does not expose loading/error states — MEDIUM

`SearchViewModel` tracks `isLoading` and `errorMessage`, but `SearchPage` does not render those states.

The screen can therefore look empty while a request is running or when an error occurs.

### Fix

Add:

```text
Loading → CircularProgressIndicator
Error → Retry message/button
No results → No meals found
Results → Meal list
```

---

## 8. Search TextEditingController is not disposed — LOW

`SearchPage` creates a `TextEditingController` but has no `dispose()` override.

### Fix

Dispose it in `_SearchPageState.dispose()`.

---

## 9. Category page recreates the network Future during rebuilds — MEDIUM

`CategoryMealsPage` passes `_loadMeals()` directly to `FutureBuilder` from `build()`.

A rebuild can create a new future and repeat the API request.

### Fix

Convert the page to `StatefulWidget` and store the future in state, or move category loading into a ViewModel/Provider.

---

## 10. Category API failures are converted into an empty list — MEDIUM

`CategoryMealsPage._loadMeals()` returns `[]` when the API response is unsuccessful.

The UI then shows:

```text
No meals found for this category
```

even when the actual problem was a network/server error.

### Fix

Return a typed error/result and distinguish:

```text
No results
from
Network/API failure
```

---

## 11. Order items have no primary/unique key — MEDIUM

`order_items` does not define a primary key or composite unique constraint.

The insertion code uses `ConflictAlgorithm.replace`, but without a unique constraint there is no conflict to trigger replacement.

This can produce duplicate child rows if the same order is inserted more than once.

### Fix

Use a composite primary key such as:

```sql
PRIMARY KEY (order_id, id)
```

or add a dedicated `order_item_id`.

---

## 12. SQLite migrations are incomplete — MEDIUM

The database version is `2`, but the cart database has no `onUpgrade` handler, and the order database's `onUpgrade` only recreates missing tables.

That is not enough for future schema changes such as adding `user_id`.

### Fix

Use explicit migration steps:

```text
version 1 → version 2
version 2 → version 3
...
```

with `ALTER TABLE` / migration logic for each version transition.

---

## 13. Web support is incomplete — MEDIUM

Firebase has web configuration, but the SQLite path does not configure a web database implementation.

### Fix

Either explicitly document native-only support or add a web-compatible persistence layer.

---

## 14. `FoodProvider` is experimental/dead code — LOW

`FoodProvider` loads only the Seafood category and generates another set of mock prices, but it is not registered in `main.dart`.

### Fix

Delete it or integrate it into the real data flow.

---

## 15. Some UI controls are placeholders — LOW

Examples include:

- Home `See All` button currently has no action.
- Favorite icon in `FoodCard` has no behavior.
- `order_detail_page.dart` is not part of the active history flow.

These are incomplete features rather than runtime crashes.

---

# Recommended Fix Order

For the current project, fix the foundation before adding more UI features.

```text
1. Fix MealResponse null parsing
        ↓
2. Make cart/orders user-specific
        ↓
3. Replace hashCode pricing with one pricing source
        ↓
4. Add search/category loading + error states
        ↓
5. Add SQLite migration strategy
        ↓
6. Improve payment verification for production
        ↓
7. Optimize category API loading
        ↓
8. Finish placeholder UI / order detail
```

---

# Testing Checklist

Before calling the project complete, test at least:

### Authentication

- [ ] New account creation
- [ ] Existing user sign in
- [ ] Wrong password
- [ ] Invalid email
- [ ] Password reset
- [ ] Sign out
- [ ] Relaunch while already signed in

### Food/API

- [ ] Categories load
- [ ] Category meals load
- [ ] Search with valid result
- [ ] Search with no result
- [ ] Search with spaces/special characters
- [ ] Network offline behavior
- [ ] Meal image failure

### Cart/SQLite

- [ ] Add item
- [ ] Add same item twice
- [ ] Increment quantity
- [ ] Decrement quantity
- [ ] Delete item
- [ ] Close/reopen app and verify persistence
- [ ] Check subtotal/tax/delivery/total
- [ ] Check data isolation between two users on the same device

### Payment/Orders

- [ ] Empty cart cannot checkout
- [ ] Razorpay test payment success
- [ ] Payment failure
- [ ] Back/cancel behavior
- [ ] Successful order appears in history
- [ ] Cart clears after success
- [ ] Order items are not duplicated

### Theme/UI

- [ ] System theme
- [ ] Light theme
- [ ] Dark theme
- [ ] Theme persists after restart
- [ ] Small-screen layout
- [ ] Desktop layout if desktop support is retained

---

# Useful Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

For desktop SQLite initialization, `main.dart` calls `sqfliteFfiInit()` and switches the database factory on Windows/Linux/macOS.

---

# Current Project Status

The application already has a working high-level restaurant flow and a reasonable separation between UI, state, API and database code.

The largest architectural gap is that **Firebase authentication and local SQLite persistence currently operate independently**. Authentication identifies the user, but cart/order storage is still device-wide rather than user-specific.

The other major gap is that **food data comes from TheMealDB while prices and restaurant information are locally fabricated**. That is fine for a prototype, but those values should come from one consistent product/pricing source before treating the checkout total as real business data.

For a student/demo application, the recommended next milestone is to stabilize parsing, user-specific local storage, deterministic pricing, error states and migrations before adding additional features.
