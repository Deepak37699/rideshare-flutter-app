# Security Rules Documentation

## Overview

This document explains the comprehensive security rules implemented for the RideShare application. The security rules are designed to protect user data, ensure proper access control, and maintain data integrity.

## Security Principles

### 1. Authentication Required

- All operations require valid Firebase authentication
- No anonymous access to sensitive data
- Token-based authentication with proper validation

### 2. Data Ownership

- Users can only access and modify their own data
- Strict ownership validation for all user-specific collections
- Cross-user data access is limited to necessary ride-sharing functionality

### 3. Input Validation

- All data inputs are validated against strict schemas
- Type checking for all fields
- Length and format validation for strings
- Range validation for numbers

### 4. Role-Based Access Control

- Different permissions for riders and drivers
- Context-aware access based on user type
- Specific permissions for ride-related operations

## Collection Security Rules

### Users Collection (`/users/{userId}`)

**Permissions:**

- ✅ **Create**: Users can create their own profile with valid data
- ✅ **Read**: Users can read their own profile + limited public data of others
- ✅ **Update**: Users can update their own profile (except userType)
- ❌ **Delete**: Not allowed (data retention for safety)

**Validation Rules:**

```javascript
// Required fields
['name', 'email', 'userType', 'createdAt']

// Field validation
name: string, length > 0
email: valid email format
userType: 'rider' or 'driver'
createdAt: timestamp
```

**Security Features:**

- Users cannot change their userType after creation
- Email format validation
- Ownership validation for all operations

### Rides Collection (`/rides/{rideId}`)

**Permissions:**

- ✅ **Create**: Riders can create rides for themselves
- ✅ **Read**: Riders see own rides, drivers see available rides
- ✅ **Update**: Complex state-based permissions
- ❌ **Delete**: Not allowed (audit trail)

**State Management:**

```
requested → accepted → started → completed
    ↓
  cancelled
```

**Update Permissions:**

- **Riders**: Can cancel their own rides
- **Drivers**: Can accept available rides and update status
- **Both**: Can add rating/feedback after completion

**Validation Rules:**

```javascript
// Required fields
['riderId', 'pickupAddress', 'destinationAddress', 'status', 'rideType', 'estimatedFare', 'requestTime']

// Field validation
riderId: string (must match authenticated user)
addresses: non-empty strings
status: valid status value
rideType: 'standard', 'premium', or 'shared'
estimatedFare: number >= 0
requestTime: timestamp
```

**Security Features:**

- Core ride details cannot be modified after creation
- Only valid status transitions allowed
- Ownership validation for all operations
- Drivers can only accept, not create rides

### Driver Profiles Collection (`/drivers/{driverId}`)

**Permissions:**

- ✅ **Create/Update**: Drivers can manage their own profile
- ✅ **Read**: All authenticated users (for ride matching)
- ❌ **Delete**: Not allowed

**Validation Rules:**

```javascript
// Required fields
["vehicleInfo", "licenseNumber", "isAvailable"];

// Field validation
vehicleInfo: map / object;
licenseNumber: string;
isAvailable: boolean;
```

### Messages Collection (`/rides/{rideId}/messages/{messageId}`)

**Permissions:**

- ✅ **Create**: Only ride participants (rider + driver)
- ✅ **Read**: Only ride participants
- ❌ **Update/Delete**: Not allowed (message integrity)

**Validation Rules:**

```javascript
// Required fields
['senderId', 'message', 'timestamp']

// Field validation
senderId: string (must match authenticated user)
message: non-empty string
timestamp: timestamp
```

**Security Features:**

- Only ride participants can communicate
- Messages are immutable after creation
- Sender verification

### Reports Collection (`/reports/{reportId}`)

**Permissions:**

- ✅ **Create**: Users can report other users
- ✅ **Read**: Users can read their own reports
- ❌ **Update/Delete**: Not allowed (integrity)

**Validation Rules:**

```javascript
// Required fields
['reporterId', 'reportedUserId', 'reason', 'description', 'timestamp']

// Field validation
reporterId: string (must match authenticated user)
reportedUserId: string
reason: string
description: string
timestamp: timestamp
```

**Security Features:**

- Reports are immutable for integrity
- Only reporters can read their own reports
- Comprehensive audit trail

### Configuration Collection (`/config/{document}`)

**Permissions:**

- ✅ **Read**: All authenticated users
- ❌ **Write**: Server-side only (admin functions)

**Use Cases:**

- App settings
- Pricing configuration
- Feature flags
- Terms and conditions

### User Tokens Collection (`/userTokens/{userId}`)

**Permissions:**

- ✅ **Read/Write**: Users can manage their own tokens
- ❌ **Cross-user access**: Not allowed

**Use Cases:**

- Push notification tokens
- Device registration
- Session management

## Helper Functions

### Authentication Helpers

```javascript
function isAuthenticated() {
  return request.auth != null;
}

function isOwner(userId) {
  return request.auth.uid == userId;
}
```

### Validation Helpers

```javascript
function isValidEmail(email) {
  return email is string && email.matches('.*@.*\\..*');
}

function isValidUserData() {
  // Comprehensive user data validation
}

function isValidRideData() {
  // Comprehensive ride data validation
}
```

## Security Testing

### Test Categories

1. **Authentication Tests**

   - Verify all operations require authentication
   - Test unauthorized access prevention

2. **Ownership Tests**

   - Verify users can only access their own data
   - Test cross-user access prevention

3. **Validation Tests**

   - Test data format validation
   - Test required field enforcement

4. **Role-Based Tests**

   - Test rider-specific permissions
   - Test driver-specific permissions

5. **State Management Tests**
   - Test ride status transitions
   - Test invalid state changes

### Running Tests

```bash
# Install Firebase CLI (if not already installed)
npm install -g firebase-tools

# Start Firebase emulator for local testing
firebase emulators:start --only firestore

# Test your Flutter app against local emulator
flutter run
# or for testing
flutter test

# Deploy rules when ready
firebase deploy --only firestore:rules
```

For Flutter integration testing with Firebase, you can create widget tests that interact with the local Firebase emulator.

## Deployment

### Deploy Security Rules

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize project
firebase init firestore

# Deploy rules
firebase deploy --only firestore:rules
```

### Monitoring

1. **Firebase Console**: Monitor rule usage and errors
2. **Cloud Logging**: Track security rule violations
3. **Analytics**: Monitor access patterns
4. **Alerts**: Set up alerts for suspicious activity

## Best Practices

### Development

1. Test rules thoroughly before deployment
2. Use Firebase emulator for local testing
3. Version control all rule changes
4. Document all rule modifications

### Production

1. Monitor rule performance and errors
2. Regular security audits
3. Keep rules updated with app changes
4. Backup rule configurations

### Security

1. Principle of least privilege
2. Defense in depth
3. Regular penetration testing
4. User education on security practices

## Common Pitfalls

1. **Overly Permissive Rules**: Avoid `allow read, write: if true`
2. **Missing Validation**: Always validate input data
3. **Complex Rules**: Keep rules simple and readable
4. **Performance**: Avoid expensive operations in rules
5. **Testing**: Always test rules before deployment

## Troubleshooting

### Common Errors

1. **Permission Denied**: Check ownership and authentication
2. **Validation Failed**: Verify data format and required fields
3. **Rule Evaluation**: Check rule logic and conditions
4. **Performance**: Optimize expensive rule operations

### Debugging

1. Use Firebase emulator for local testing
2. Check Firebase Console for rule errors
3. Enable debug logging in development
4. Test with different user scenarios

## Updates and Maintenance

### Regular Reviews

- Monthly security rule audits
- Performance monitoring
- User feedback integration
- Compliance verification

### Version Control

- Document all changes
- Test before deployment
- Rollback procedures
- Change approval process

This comprehensive security implementation ensures that your RideShare application maintains the highest standards of data protection and user privacy.
