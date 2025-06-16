import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Auth service getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseMessaging get messaging => _messaging;

  // Current user
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  // Authentication methods
  Future<UserCredential?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Sign in error: ${e.message}');
      rethrow;
    }
  }

  Future<UserCredential?> createUserWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Sign up error: ${e.message}');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Password reset error: ${e.message}');
      rethrow;
    }
  }

  // Firestore methods
  Future<void> createUserDocument(
    String uid,
    Map<String, dynamic> userData,
  ) async {
    try {
      await _firestore.collection('users').doc(uid).set(userData);
    } catch (e) {
      print('Create user document error: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot> getUserDocument(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      print('Get user document error: $e');
      rethrow;
    }
  }

  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print('Update user document error: $e');
      rethrow;
    }
  }

  // Ride-related methods
  Future<DocumentReference> createRide(Map<String, dynamic> rideData) async {
    try {
      return await _firestore.collection('rides').add(rideData);
    } catch (e) {
      print('Create ride error: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getRidesStream() {
    return _firestore.collection('rides').snapshots();
  }

  Future<QuerySnapshot> getAvailableRides() async {
    try {
      return await _firestore
          .collection('rides')
          .where('status', isEqualTo: 'available')
          .orderBy('createdAt', descending: true)
          .get();
    } catch (e) {
      print('Get available rides error: $e');
      rethrow;
    }
  }

  // Booking-related methods
  Future<DocumentReference> createBooking(
    Map<String, dynamic> bookingData,
  ) async {
    try {
      return await _firestore.collection('bookings').add(bookingData);
    } catch (e) {
      print('Create booking error: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getUserBookingsStream(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Push notification methods
  Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print('Get FCM token error: $e');
      return null;
    }
  }

  Future<void> initializeNotifications() async {
    try {
      // Request permission for iOS
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
            'Message also contained a notification: ${message.notification}',
          );
        }
      });

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    } catch (e) {
      print('Initialize notifications error: $e');
    }
  }

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

// Top-level function for background message handling
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
