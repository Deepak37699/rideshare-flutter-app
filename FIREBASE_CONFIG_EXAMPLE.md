# Firebase Configuration Example

## This file shows you what values to replace in your firebase_options.dart file

## Get these values from Firebase Console > Project Settings > Your apps

### Android Configuration

```
apiKey: "AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz1234567"
appId: "1:123456789012:android:abcdef1234567890abcdef"
messagingSenderId: "123456789012"
projectId: "your-project-id"
storageBucket: "your-project-id.appspot.com"
```

### iOS Configuration

```
apiKey: "AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz7654321"
appId: "1:123456789012:ios:abcdef1234567890fedcba"
messagingSenderId: "123456789012"
projectId: "your-project-id"
storageBucket: "your-project-id.appspot.com"
iosBundleId: "com.example.rideshear"
```

### Web Configuration

```
apiKey: "AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz9876543"
appId: "1:123456789012:web:abcdef1234567890123456"
messagingSenderId: "123456789012"
projectId: "your-project-id"
authDomain: "your-project-id.firebaseapp.com"
storageBucket: "your-project-id.appspot.com"
measurementId: "G-ABCDEFGHIJ"
```

## How to get these values:

1. Go to Firebase Console (https://console.firebase.google.com)
2. Select your project (or create one)
3. Click on Project Settings (gear icon)
4. Scroll down to "Your apps" section
5. For each platform (Android/iOS/Web), click on the app
6. Copy the configuration values and replace the placeholder values in firebase_options.dart

## google-services.json for Android:

- Download from Firebase Console > Project Settings > Your apps > Android app
- Replace the template file at android/app/google-services.json

## GoogleService-Info.plist for iOS:

- Download from Firebase Console > Project Settings > Your apps > iOS app
- Add to ios/Runner/ directory in Xcode
