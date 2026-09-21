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

