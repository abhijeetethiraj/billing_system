import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../navigation/app_shell.dart';
import 'login_page.dart';

/// Decides what to show: a loading screen while Firebase checks for a saved
/// session, the login page when signed out, or the app when signed in.
/// Signing out from anywhere in the app brings the user back to the login page.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.initializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.user == null) {
      return const LoginPage();
    }

    return const AppShell();
  }
}