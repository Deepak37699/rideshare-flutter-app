# rideshear

# rideshear

# RideShare - Modern Ride Sharing App

A modern, feature-rich ride-sharing application built with Flutter, following the development plan for a complete ride booking experience.

## Features

### Phase 1 - MVP Features ✅

**Authentication & User Management:**

- User registration and login with email/password
- User type selection (Rider/Driver)
- Profile management
- Firebase Authentication integration

**Modern UI/UX:**

- Material Design 3 implementation
- Custom theme with beautiful color scheme
- Responsive design for all screen sizes
- Modern animations and transitions
- Custom widgets and components

**App Structure:**

- Clean architecture with proper folder structure
- Provider state management
- Modular code organization
- Reusable custom widgets

### Upcoming Features (Next Phases)

**Ride Booking:**

- GPS-based location detection
- Destination input with auto-suggestions
- Real-time driver tracking
- Multiple ride types (Economy, Premium, XL)
- Fare estimation

**Maps Integration:**

- Google Maps integration
- Real-time location tracking
- Route optimization
- Driver location updates

**Payment System:**

- Multiple payment methods
- Secure payment processing
- Fare calculation
- Receipt generation

**Driver Features:**

- Driver verification system
- Online/offline status
- Ride request handling
- Earnings tracking

## Project Structure

```
lib/
├── constants/           # App constants, colors, strings
├── models/             # Data models (User, Ride, Driver)
├── providers/          # State management (Provider pattern)
├── screens/            # UI screens organized by feature
│   ├── auth/          # Authentication screens
│   ├── home/          # Home and dashboard screens
│   ├── ride/          # Ride booking and tracking
│   └── profile/       # User profile screens
├── services/           # Business logic and API calls
├── utils/              # Utility functions and helpers
└── widgets/            # Reusable custom widgets
```

## Technology Stack

- **Framework:** Flutter 3.8+
- **State Management:** Provider
- **Backend:** Firebase (Auth, Firestore, Messaging)
- **Maps:** Google Maps API
- **Payment:** Stripe integration (planned)
- **Architecture:** Clean Architecture with Provider pattern

## Getting Started

### Prerequisites

- Flutter SDK 3.8.0 or higher
- Dart 3.0 or higher
- Android Studio / VS Code with Flutter plugins
- Firebase account (for backend services)

### Installation

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd rideshear
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup:**

   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android/iOS apps to your project
   - Download configuration files:
     - `google-services.json` → `android/app/`
     - `GoogleService-Info.plist` → `ios/Runner/`
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Enable Cloud Messaging

4. **Run the app:**
   ```bash
   flutter run
   ```

### Firebase Configuration

The app requires Firebase for authentication and data storage. See `lib/services/firebase_config.dart` for detailed setup instructions.

## Development Plan Progress

- ✅ **Phase 1:** Planning and Research
- ✅ **Phase 2:** Design System and UI/UX
- 🔄 **Phase 3:** Development (In Progress)
  - ✅ Technology Stack Setup
  - ✅ Project Structure
  - ✅ Authentication Module
  - ✅ Basic UI Implementation
  - ⏳ Ride Booking Module
  - ⏳ Maps Integration
  - ⏳ Payment Module
  - ⏳ Driver Module
- ⏳ **Phase 4:** Testing
- ⏳ **Phase 5:** Deployment
- ⏳ **Phase 6:** Maintenance

## Current Status

The app currently includes:

1. **Authentication System:**

   - Beautiful sign-in and sign-up screens
   - User type selection (Rider/Driver)
   - Form validation and error handling
   - Loading states and user feedback

2. **Home Dashboard:**

   - Welcome screen with user information
   - Quick action cards
   - Modern card-based design
   - Ride booking interface (placeholder)

3. **App Infrastructure:**
   - Custom theme with modern color scheme
   - Reusable widgets (CustomButton, CustomTextField)
   - Provider-based state management
   - Proper navigation setup

## Next Steps

1. **Google Maps Integration:**

   - Add Google Maps API key
   - Implement location services
   - Create map-based ride booking interface

2. **Backend Integration:**

   - Complete Firebase setup
   - Implement real-time data sync
   - Add push notifications

3. **Ride Booking Flow:**

   - Location picker
   - Driver matching algorithm
   - Real-time tracking

4. **Payment Integration:**   - Stripe payment gateway
   - Multiple payment methods
   - Receipt system

## 📚 Documentation

### **Complete Documentation Suite**

This project includes comprehensive documentation to help developers understand, set up, and contribute to the RideShare app:

- **[PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md)** - Executive summary, architecture overview, and project status
- **[TECHNICAL_DOCS.md](./TECHNICAL_DOCS.md)** - Detailed technical implementation, code architecture, and patterns
- **[DEVELOPER_GUIDE.md](./DEVELOPER_GUIDE.md)** - Step-by-step setup guide for developers
- **[CHANGELOG.md](./CHANGELOG.md)** - Version history and release notes
- **[DevelopmentPlan.md](./DevelopmentPlan.md)** - Original development plan and roadmap

### **Quick Navigation**

| Document | Description | Audience |
|----------|-------------|----------|
| README.md | Project overview and quick start | Everyone |
| PROJECT_SUMMARY.md | Executive summary and status | Project managers, stakeholders |
| TECHNICAL_DOCS.md | Code architecture and implementation | Developers, architects |
| DEVELOPER_GUIDE.md | Setup and development workflow | New developers |
| CHANGELOG.md | Version history and changes | All team members |

## 🎯 Current Status

**Version:** 1.0.0 - Phase 1 Complete ✅

The app currently features:
- ✅ Complete authentication system with Firebase
- ✅ Modern Material Design 3 UI
- ✅ User registration and login with user type selection
- ✅ Clean architecture with Provider state management
- ✅ Custom reusable widgets and components
- ✅ Responsive home dashboard
- ✅ Comprehensive documentation suite

**Next Phase:** Google Maps integration and ride booking flow

## Contributing

This project follows the development plan outlined in `DevelopmentPlan.md`. Please refer to the documentation suite above for detailed information:

1. **For setup:** See [DEVELOPER_GUIDE.md](./DEVELOPER_GUIDE.md)
2. **For architecture:** See [TECHNICAL_DOCS.md](./TECHNICAL_DOCS.md)
3. **For project status:** See [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md)

## License

This project is part of a ride-sharing app development tutorial/exercise.

---

## 🚀 Quick Start Summary

1. **Clone & Setup:**
   ```bash
   git clone <repository-url>
   cd rideshear
   flutter pub get
   ```

2. **Configure Firebase:**
   - Follow [DEVELOPER_GUIDE.md](./DEVELOPER_GUIDE.md) for detailed Firebase setup

3. **Run the App:**
   ```bash
   flutter run
   ```

4. **Explore Documentation:**
   - Start with [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md) for an overview
   - Check [TECHNICAL_DOCS.md](./TECHNICAL_DOCS.md) for implementation details

**Need Help?** Check the documentation files above or reach out to the development team!
