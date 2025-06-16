# Firebase Setup Instructions for Windows

## Prerequisites Installation

### 1. Install Node.js (Required for Firebase CLI)

1. Go to [nodejs.org](https://nodejs.org/)
2. Download the LTS version for Windows
3. Run the installer and follow the setup wizard
4. Restart your terminal/VS Code after installation

### 2. Install Firebase CLI

After Node.js is installed, run in terminal:

```bash
npm install -g firebase-tools
```

### 3. Verify Installation

```bash
node --version
npm --version
firebase --version
```

## Flutter Dependencies (✅ Already Installed)

Your Flutter dependencies are already installed via `flutter pub get`. The key Firebase packages in your `pubspec.yaml` are:

- `firebase_core: ^3.8.1`
- `firebase_auth: ^5.3.4`
- `firebase_messaging: ^15.1.6`
- `cloud_firestore: ^5.5.0`

## Firebase Project Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `rideshear-app`
4. Enable Google Analytics (recommended)
5. Create the project

### 2. Add Flutter App to Firebase

#### For Android:

1. In Firebase Console → Project Settings → Add app → Android
2. Package name: `com.example.rideshear`
3. Download `google-services.json`
4. Replace `android/app/google-services.json` with downloaded file

#### For iOS (if building for iOS):

1. In Firebase Console → Project Settings → Add app → iOS
2. Bundle ID: `com.example.rideshear`
3. Download `GoogleService-Info.plist`
4. Add to `ios/Runner/` directory

### 3. Enable Firebase Services

#### Authentication:

1. Firebase Console → Authentication → Sign-in method
2. Enable "Email/Password"
3. Enable "Google" (optional)

#### Firestore Database:

1. Firebase Console → Firestore Database → Create database
2. Start in "test mode" for development
3. Choose database location

### 4. Update Configuration

Replace template values in `lib/firebase_options.dart` with real values from:
Firebase Console → Project Settings → General → Your apps

## Security Rules Deployment

### Option 1: Firebase Console (Easiest)

1. Go to Firebase Console → Firestore Database → Rules
2. Copy content from `firestore.rules` file
3. Paste into the rules editor
4. Click "Publish"

### Option 2: Firebase CLI (After installing Node.js)

```bash
# Login to Firebase
firebase login

# Initialize project
firebase init firestore

# Deploy rules
firebase deploy --only firestore:rules
```

## Testing Your Setup

```bash
# Clean and rebuild
flutter clean
flutter pub get

# Run the app
flutter run

# Check for "Firebase initialized successfully" in console
```

## Quick Start Without Firebase CLI

If you want to start developing immediately without installing Node.js:

1. ✅ Flutter dependencies are already installed
2. ✅ Security rules are created in `firestore.rules`
3. 🔄 Create Firebase project in console
4. 🔄 Add your app and download config files
5. 🔄 Copy security rules manually to Firebase console
6. 🔄 Update `firebase_options.dart` with real values

Your Flutter app is ready to run once you complete the Firebase console setup!

## What's Next

1. **Create Firebase project** in console
2. **Download config files** and replace templates
3. **Copy security rules** to Firebase console
4. **Test the app** with `flutter run`

The security rules are production-ready and will protect your user data according to the comprehensive rules defined in `firestore.rules`.
