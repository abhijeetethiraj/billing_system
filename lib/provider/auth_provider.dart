import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_services.dart';

/// Holds the signed-in user and exposes sign in / sign up / sign out to the UI.
class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  late final StreamSubscription<User?> _subscription;

  User? _user;
  bool _initializing = true;
  bool _busy = false;
  String? _error;

  User? get user => _user;

  /// True until Firebase has told us whether someone is already signed in.
  bool get initializing => _initializing;

  /// True while a sign in / sign up request is running.
  bool get isBusy => _busy;

  String? get error => _error;

  AuthProvider() {
    _subscription = _service.userChanges.listen((user) {
      _user = user;
      _initializing = false;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) {
    return _run(() => _service.signIn(email: email, password: password));
  }

  Future<bool> signUp(String name, String email, String password) {
    return _run(
      () => _service.signUp(name: name, email: email, password: password),
    );
  }

  Future<bool> sendPasswordReset(String email) {
    return _run(() => _service.sendPasswordReset(email));
  }

  Future<void> signOut() => _service.signOut();

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  Future<bool> _run(Future<void> Function() action) async {
    _busy = true;
    _error = null;
    notifyListeners();

    try {
      await action();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = AuthService.messageFor(e);
      return false;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}