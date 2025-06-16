import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';
import '../services/auth_service.dart';

/// Manages the application's authentication state.
///
/// This provider interfaces with [AuthService] to handle user authentication
/// operations such as sign-in (email/password and Google), sign-up, and sign-out.
/// It exposes the current user, loading states, and error messages to the UI.
///
/// It listens to authentication state changes from [AuthService] and updates
/// the [_currentUser] accordingly.
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  /// The currently authenticated user. Null if no user is signed in.
  User? get currentUser => _currentUser;

  /// Whether an authentication operation is currently in progress.
  bool get isLoading => _isLoading;

  /// The last error message from an authentication operation, if any.
  String? get error => _error;

  /// Whether a user is currently authenticated.
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initializeAuth();
  }

  /// Initializes the provider by listening to auth state changes.
  Future<void> _initializeAuth() async {
    _authService.authStateChanges.listen((User? user) {
      _currentUser = user;
      // The user object from authStateChanges (originating from AuthService)
      // is expected to be a complete User model instance, including data from Firestore.
      // Thus, an explicit call to _loadUserFromFirebase might be redundant here
      // if AuthService.authStateChanges correctly populates the User object.
      notifyListeners();
    });
  }

  /// Signs in the user with the given email and password.
  ///
  /// Returns true on success, false on failure. Updates [error] on failure.
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      final user = await _authService.signInWithEmail(email, password);
      _currentUser = user;
      // The null check `if (user == null) return false;` was removed because
      // `signInWithEmail` in `AuthService` is declared to return `Future<User>`, not `Future<User?>`.
      // If it can indeed return null, its signature should be `Future<User?>`.
      // Assuming for now it throws an exception on failure or returns a valid User.
      notifyListeners();
      return true; // Assumes success if no exception was thrown
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Signs in the user using Google Sign-In.
  ///
  /// Returns true on success, false on failure. Updates [error] on failure.
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Signs up a new user with the given details.
  ///
  /// Returns true on success, false on failure. Updates [error] on failure.
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required UserType userType,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final user = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        userType: userType,
      );
      _currentUser = user; // Update current user
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    _setLoading(true);
    try {
      // await _firebaseService.signOut();
      await _authService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  /// Sends a password reset email to the specified email address.
  ///
  /// Returns true on success, false on failure. Updates [error] on failure.
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      // await _firebaseService.sendPasswordResetEmail(email);
      await _authService.resetPassword(email); // Changed to use AuthService
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Converts an error object (potentially a [firebase_auth.FirebaseAuthException])
  /// into a user-friendly error message string.
  String _getErrorMessage(dynamic error) {
    if (error is firebase_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'An account already exists with this email address.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later.';
        default:
          return error.message ?? 'An unknown error occurred.';
      }
    }
    return error.toString();
  }
}
