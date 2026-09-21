import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:billing_system/firebase_options.dart';
import 'package:billing_system/provider/auth_provider.dart';
import 'package:billing_system/provider/cart_provider.dart';
import 'package:billing_system/provider/order_provider.dart';
import 'package:billing_system/provider/theme_provider.dart';
import 'package:billing_system/utils/apptheme.dart';
import 'package:billing_system/viewmodels/home_viewmodel.dart';
import 'package:billing_system/viewmodels/search_viewmodel.dart';
import 'package:billing_system/views/auth/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Load the saved theme choice before the first frame so the app doesn't
  // flash the wrong theme on launch.
  final themeProvider = ThemeProvider();
  await themeProvider.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeViewmodel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // ThemeMode.system follows the device and updates live when the
      // user switches their phone between light and dark.
      themeMode: themeMode,
      // Keep the status bar icons readable on both light and dark backgrounds.
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
              .copyWith(statusBarColor: Colors.transparent),
          child: child!,
        );
      },
      // Shows the login page when signed out, the app shell when signed in.
      home: const AuthGate(),
    );
  }
}
