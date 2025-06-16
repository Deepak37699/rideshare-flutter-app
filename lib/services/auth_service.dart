import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';

/// Service class for handling authentication with Firebase.
///
/// This class provides methods for:
/// - Email/password sign-up and sign-in.
/// - Google Sign-In.
/// - Signing out.
/// - Resetting passwords.
/// - Fetching the current user and user profiles.
///
/// It also includes a demo mode for when Firebase is not configured,
/// allowing basic functionality without a live backend.
class AuthService {
  firebase_auth.FirebaseAuth? _firebaseAuth;
  FirebaseFirestore? _firestore;
  GoogleSignIn? _googleSignIn;
  bool _isFirebaseAvailable = false;
  bool _hasCheckedFirebase = false;

  // Mock user for demonstration when Firebase is not configured
  User? _mockUser;

  AuthService() {
    // Firebase initialization is deferred to _initializeFirebaseIfNeeded
    // to handle cases where Firebase might not be configured.
  }

  /// Initializes Firebase services if they haven't been already.
  ///
  /// This method attempts to initialize FirebaseAuth, FirebaseFirestore, and GoogleSignIn.
  /// If initialization fails (e.g., Firebase not configured), it sets [_isFirebaseAvailable]
  /// to false and the app operates in a demo mode.
  Future<void> _initializeFirebaseIfNeeded() async {
    if (_hasCheckedFirebase) return;

    try {
      _firebaseAuth = firebase_auth.FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _googleSignIn = GoogleSignIn(); // Added
      _isFirebaseAvailable = true;
      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase not configured, running in demo mode: $e');
      _firebaseAuth = null;
      _firestore = null;
      _isFirebaseAvailable = false;
    }
    _hasCheckedFirebase = true;
  }

  /// Retrieves the current authenticated user.
  ///
  /// If Firebase is available, it fetches the user from Firebase Auth and
  /// then their profile from Firestore.
  /// In demo mode, it returns a mock user if available.
  Future<User?> getCurrentUser() async {
    await _initializeFirebaseIfNeeded();

    if (!_isFirebaseAvailable) {
      // Return mock user for demo purposes
      return _mockUser;
    }

    final firebaseUser = _firebaseAuth!.currentUser;
    if (firebaseUser == null) return null;

    try {
      final userDoc = await _firestore!
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        return User.fromJson({'id': firebaseUser.uid, ...userDoc.data()!});
      }
    } catch (e) {
      print('Error getting current user: $e');
    }

    return null;
  }

  /// Fetches a user profile by their UID from Firestore.
  ///
  /// Returns null if the user is not found or if Firebase is not available.
  Future<User?> getUserProfile(String uid) async {
    await _initializeFirebaseIfNeeded();

    if (!_isFirebaseAvailable || _firestore == null) {
      print('Firebase not available to get user profile.');
      // Potentially return a mock user if in demo mode and uid matches mock user's id
      if (!_isFirebaseAvailable && _mockUser?.id == uid) return _mockUser;
      return null;
    }

    try {
      final userDoc = await _firestore!.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return User.fromJson({'id': uid, ...userDoc.data()!});
      } else {
        print('User profile not found in Firestore for UID: $uid');
        return null;
      }
    } catch (e) {
      print('Error getting user profile for UID $uid: $e');
      return null;
    }
  }

  /// Signs in a user with their email and password.
  ///
  /// If Firebase is available, it uses Firebase Auth.
  /// In demo mode, it checks against predefined demo credentials.
  /// Returns the [User] object on success, otherwise throws an exception.
  Future<User> signInWithEmail(String email, String password) async {
    await _initializeFirebaseIfNeeded();

    if (!_isFirebaseAvailable) {
      // Mock sign in for demo purposes
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      if (email == "demo@example.com" && password == "demo123") {
        _mockUser = User(
          id: "demo-user-id",
          name: "Demo User",
          email: email,
          userType: UserType.rider,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return _mockUser!;
      } else {
        throw Exception(
          'Demo mode: Use email "demo@example.com" and password "demo123"',
        );
      }
    }

    try {
      final credential = await _firebaseAuth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Sign in failed');
      }

      final userDoc = await _firestore!
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        return User.fromJson({'id': firebaseUser.uid, ...userDoc.data()!});
      } else {
        throw Exception('User data not found');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /// Signs up a new user with email, password, name, and user type.
  ///
  /// If Firebase is available, it creates a new user in Firebase Auth and
  /// stores their profile in Firestore.
  /// In demo mode, it creates a mock user.
  /// Returns the newly created [User] object.
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required UserType userType,
  }) async {
    await _initializeFirebaseIfNeeded();

    if (!_isFirebaseAvailable) {
      // Mock sign up for demo purposes
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      final now = DateTime.now();
      _mockUser = User(
        id: "demo-user-${now.millisecondsSinceEpoch}",
        name: name,
        email: email,
        userType: userType,
        createdAt: now,
        updatedAt: now,
      );

      return _mockUser!;
    }

    try {
      final credential = await _firebaseAuth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Account creation failed');
      }

      // Update display name
      await firebaseUser.updateDisplayName(name);

      final now = DateTime.now();
      final user = User(
        id: firebaseUser.uid,
        name: name,
        email: email,
        userType: userType,
        createdAt: now,
        updatedAt: now,
      );

      // Save user data to Firestore
      await _firestore!
          .collection('users')
          .doc(firebaseUser.uid)
          .set(user.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Account creation failed: $e');
    }
  }

  /// Signs in a user using their Google account.
  ///
  /// This method handles the Google Sign-In flow and then either signs into
  /// Firebase with the Google credentials or creates a new user account
  /// in Firebase if it's their first time.
  ///
  /// It fetches or creates the user's profile in Firestore.
  /// Returns the [User] object on success, otherwise throws an exception.
  Future<User?> signInWithGoogle() async {
    await _initializeFirebaseIfNeeded();

    if (!_isFirebaseAvailable ||
        _googleSignIn == null ||
        _firebaseAuth == null ||
        _firestore == null) {
      // Mock Google sign-in for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      _mockUser = User(
        id: "demo-google-user-id",
        name: "Demo Google User",
        email: "demo.google@example.com",
        userType: UserType.rider,
        photoUrl: "https://example.com/demopropic.jpg",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return _mockUser;
    }

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

      final firebase_auth.UserCredential userCredential = await _firebaseAuth!
          .signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Google Sign-In failed with Firebase.');
      }

      // Check if user exists in Firestore, if not, create a new entry
      final userDocRef = _firestore!.collection('users').doc(firebaseUser.uid);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // New user, create profile in Firestore
        final newUser = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Google User',
          email: firebaseUser.email ?? '',
          userType: UserType.rider, // Default to rider, can be changed later
          photoUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await userDocRef.set(newUser.toJson());
        return newUser;
      } else {
        // Existing user, update photoUrl and name if changed, then return user data
        Map<String, dynamic> updates = {};
        bool needsUpdate = false;
        if (firebaseUser.photoURL != null &&
            userDoc.data()?['photoUrl'] != firebaseUser.photoURL) {
          updates['photoUrl'] = firebaseUser.photoURL;
          needsUpdate = true;
        }
        if (firebaseUser.displayName != null &&
            userDoc.data()?['name'] != firebaseUser.displayName) {
          updates['name'] = firebaseUser.displayName;
          needsUpdate = true;
        }
        if (needsUpdate) {
          updates['updatedAt'] =
              FieldValue.serverTimestamp(); // Use server timestamp for updates
          await userDocRef.update(updates);
        }
        // Fetch the potentially updated document to ensure `createdAt` is a DateTime
        final updatedDoc = await userDocRef.get();
        return User.fromJson({'id': firebaseUser.uid, ...updatedDoc.data()!});
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      print('Google Sign-In error: $e');
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// Signs out the current user.
  ///
  /// If Firebase is available, it signs out from Firebase Auth and Google Sign-In.
  /// In demo mode, it clears the mock user.
  Future<void> signOut() async {
    await _initializeFirebaseIfNeeded();

    if (!_isFirebaseAvailable) {
      // Mock sign out for demo purposes
      _mockUser = null;
      return;
    }

    try {
      await _googleSignIn?.signOut(); // Added: Sign out from Google
      await _firebaseAuth!.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Sends a password reset email to the given email address.
  ///
  /// Only works if Firebase is available.
  Future<void> resetPassword(String email) async {
    await _initializeFirebaseIfNeeded();

    if (!_isFirebaseAvailable) {
      // Mock password reset for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await _firebaseAuth!.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Provides a stream of authentication state changes.
  ///
  /// Listens to Firebase Auth state changes and maps them to [User] objects.
  /// In demo mode, it emits the mock user state.
  Stream<User?> get authStateChanges {
    return Stream.fromFuture(_initializeFirebaseIfNeeded()).asyncExpand((_) {
      if (!_isFirebaseAvailable) {
        // Mock stream for demo purposes
        return Stream.value(_mockUser);
      }

      return _firebaseAuth!.authStateChanges().asyncMap((firebaseUser) async {
        if (firebaseUser == null) return null;
        return await getCurrentUser();
      });
    });
  }

  /// Converts a [firebase_auth.FirebaseAuthException] into a more user-friendly error message.
  Exception _handleAuthException(firebase_auth.FirebaseAuthException e) {
    String message = e.message ?? 'An error occurred during authentication.';
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email address.';
        break;
      case 'wrong-password':
        message = 'Incorrect password.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists with this email address.';
        break;
      case 'weak-password':
        message = 'Password is too weak.';
        break;
      case 'invalid-email':
        message = 'Invalid email address.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many requests. Please try again later.';
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your connection.';
        break;
      // Add other specific Firebase Auth error codes as needed
    }
    return Exception(message);
  }
}
