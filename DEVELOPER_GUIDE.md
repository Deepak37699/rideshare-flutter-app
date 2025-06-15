# Developer Setup Guide - RideShare App

## 🚀 Quick Start Guide

### Prerequisites
- **Flutter SDK:** 3.8.0 or higher
- **Dart SDK:** 3.0 or higher
- **IDE:** VS Code or Android Studio with Flutter plugins
- **Git:** For version control

### Installation Steps

#### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd rideshear
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Verify Flutter Installation
```bash
flutter doctor
```

#### 4. Run the App
```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d chrome  # Web
flutter run -d <device-id>  # Specific device
```

---

## 🔧 Development Environment Setup

### VS Code Extensions (Recommended)
- **Flutter:** Essential Flutter support
- **Dart:** Dart language support
- **Error Lens:** Inline error display
- **Flutter Tree:** Widget tree visualization
- **GitLens:** Enhanced Git capabilities

### Android Studio Setup
1. Install Flutter and Dart plugins
2. Configure Android SDK
3. Set up Android emulator
4. Configure code style settings

---

## 🔥 Firebase Setup (Required for Authentication)

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `rideshare-app`
4. Enable Google Analytics (optional)

### 2. Add Android App
1. Click "Add app" → Android
2. Package name: `com.rideshare.app`
3. Download `google-services.json`
4. Place in `android/app/` directory

### 3. Add iOS App (Optional)
1. Click "Add app" → iOS
2. Bundle ID: `com.rideshare.app`
3. Download `GoogleService-Info.plist`
4. Place in `ios/Runner/` directory

### 4. Enable Authentication
1. Go to Authentication → Sign-in method
2. Enable "Email/Password"
3. Configure settings as needed

### 5. Enable Firestore Database
1. Go to Firestore Database
2. Click "Create database"
3. Start in test mode
4. Choose location closest to your users

### 6. Update Firebase Configuration
Edit `lib/services/firebase_config.dart` with your project details:
```dart
options: const FirebaseOptions(
  apiKey: "your-api-key",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef123456",
),
```

---

## 📱 Testing Setup

### Run Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/widget_test.dart

# With coverage
flutter test --coverage
```

### Device Testing
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run on all connected devices
flutter run -d all
```

---

## 🛠️ Development Commands

### Useful Flutter Commands
```bash
# Clean build files
flutter clean

# Update dependencies
flutter pub get
flutter pub upgrade

# Analyze code
flutter analyze

# Format code
flutter format .

# Generate code (if using build_runner)
flutter packages pub run build_runner build
```

### Git Commands for Development
```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Stage and commit changes
git add .
git commit -m "feat: your feature description"

# Push to remote
git push origin feature/your-feature-name

# Update from main branch
git checkout main
git pull origin main
git checkout feature/your-feature-name
git merge main
```

---

## 🐛 Troubleshooting

### Common Issues & Solutions

#### 1. Flutter Doctor Issues
```bash
# Android license issues
flutter doctor --android-licenses

# iOS setup issues (macOS only)
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

#### 2. Dependency Issues
```bash
# Clear pub cache
flutter pub cache repair

# Remove pubspec.lock and reinstall
rm pubspec.lock
flutter pub get
```

#### 3. Firebase Issues
- Ensure `google-services.json` is in `android/app/`
- Check Firebase project configuration
- Verify internet connection for Firebase services

#### 4. Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

## 📊 Code Quality Tools

### Static Analysis
```bash
# Run analysis
flutter analyze

# Custom analysis options in analysis_options.yaml
include: package:flutter_lints/flutter.yaml
```

### Code Formatting
```bash
# Format all files
flutter format .

# Format specific file
flutter format lib/main.dart
```

### Import Organization
Use VS Code extension or manually organize:
1. Dart SDK imports
2. Package imports
3. Relative imports

---

## 🚀 Build & Release

### Debug Build
```bash
flutter run --debug
```

### Release Build
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release

# Web
flutter build web --release
```

### App Signing (Android)
1. Generate keystore
2. Configure `android/key.properties`
3. Update `android/app/build.gradle`

---

## 📝 Development Workflow

### Recommended Development Process
1. **Feature Planning:** Review requirements and design
2. **Branch Creation:** Create feature branch from main
3. **Development:** Implement feature with tests
4. **Code Review:** Self-review and team review
5. **Testing:** Manual and automated testing
6. **Merge:** Merge to main after approval

### Commit Message Convention
```
feat: add new feature
fix: bug fix
docs: documentation update
style: formatting changes
refactor: code refactoring
test: add tests
chore: maintenance tasks
```

---

## 🔍 Debugging Tips

### Flutter Inspector
- Use Flutter Inspector in VS Code/Android Studio
- Analyze widget tree and properties
- Debug layout issues

### Debug Console
```dart
// Print debugging
print('Debug message: $variable');

// Debugger breakpoint
debugger();

// Assert statements
assert(condition, 'Error message');
```

### Performance Profiling
```bash
# Run with performance overlay
flutter run --profile

# Performance tracing
flutter run --trace-startup
```

---

## 📚 Additional Resources

### Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Material Design 3](https://m3.material.io/)

### Learning Resources
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter YouTube Channel](https://www.youtube.com/flutterdev)

### Community
- [Flutter Discord](https://discord.gg/flutter)
- [Flutter Reddit](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

---

## 🤝 Contributing

### Before Contributing
1. Read the technical documentation
2. Set up development environment
3. Run tests to ensure everything works
4. Create feature branch for your changes

### Code Standards
- Follow Dart style guide
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed

---

**Happy Coding! 🎉**

*Need help? Check the troubleshooting section or reach out to the development team.*
