const firebase = require("@firebase/rules-unit-testing");
const fs = require("fs");

const PROJECT_ID = "rideshear-test";
const RULES_FILE = "./firestore.rules";

// Test data
const mockUser = {
  uid: "user1",
  email: "test@example.com",
};

const mockDriver = {
  uid: "driver1",
  email: "driver@example.com",
};

const mockUserData = {
  name: "John Doe",
  email: "test@example.com",
  userType: "rider",
  createdAt: firebase.firestore.FieldValue.serverTimestamp(),
};

const mockRideData = {
  riderId: "user1",
  pickupAddress: "123 Main St",
  destinationAddress: "456 Oak Ave",
  status: "requested",
  rideType: "standard",
  estimatedFare: 15.5,
  requestTime: firebase.firestore.FieldValue.serverTimestamp(),
};

describe("Firestore Security Rules Tests", () => {
  let testEnv;

  beforeAll(async () => {
    testEnv = await firebase.initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        rules: fs.readFileSync(RULES_FILE, "utf8"),
      },
    });
  });

  afterAll(async () => {
    await testEnv.cleanup();
  });

  beforeEach(async () => {
    await testEnv.clearFirestore();
  });

  describe("User Collection Tests", () => {
    test("Users can create their own profile", async () => {
      const db = testEnv.authenticatedContext(mockUser.uid).firestore();
      const userRef = db.collection("users").doc(mockUser.uid);

      await firebase.assertSucceeds(userRef.set(mockUserData));
    });

    test("Users cannot create profiles for other users", async () => {
      const db = testEnv.authenticatedContext(mockUser.uid).firestore();
      const userRef = db.collection("users").doc("other-user");

      await firebase.assertFails(userRef.set(mockUserData));
    });

    test("Users can read their own profile", async () => {
      const adminDb = testEnv
        .authenticatedContext(mockUser.uid, { admin: true })
        .firestore();
      await adminDb.collection("users").doc(mockUser.uid).set(mockUserData);

      const db = testEnv.authenticatedContext(mockUser.uid).firestore();
      const userRef = db.collection("users").doc(mockUser.uid);

      await firebase.assertSucceeds(userRef.get());
    });

    test("Unauthenticated users cannot access user data", async () => {
      const db = testEnv.unauthenticatedContext().firestore();
      const userRef = db.collection("users").doc(mockUser.uid);

      await firebase.assertFails(userRef.get());
    });

    test("Users cannot change userType after creation", async () => {
      const adminDb = testEnv
        .authenticatedContext(mockUser.uid, { admin: true })
        .firestore();
      await adminDb.collection("users").doc(mockUser.uid).set(mockUserData);

      const db = testEnv.authenticatedContext(mockUser.uid).firestore();
      const userRef = db.collection("users").doc(mockUser.uid);

      await firebase.assertFails(userRef.update({ userType: "driver" }));
    });
  });

  describe("Ride Collection Tests", () => {
    test("Users can create their own rides", async () => {
      const db = testEnv.authenticatedContext(mockUser.uid).firestore();
      const rideRef = db.collection("rides").doc();

      await firebase.assertSucceeds(rideRef.set(mockRideData));
    });

    test("Users cannot create rides for other users", async () => {
      const db = testEnv.authenticatedContext(mockUser.uid).firestore();
      const rideRef = db.collection("rides").doc();
      const invalidRideData = { ...mockRideData, riderId: "other-user" };

      await firebase.assertFails(rideRef.set(invalidRideData));
    });

    test("Drivers can read available rides", async () => {
      // Setup: Admin creates a ride
      const adminDb = testEnv
        .authenticatedContext(mockUser.uid, { admin: true })
        .firestore();
      const rideId = "test-ride";
      await adminDb.collection("rides").doc(rideId).set(mockRideData);

      // Test: Driver can read available ride
      const driverDb = testEnv.authenticatedContext(mockDriver.uid).firestore();
      const rideRef = driverDb.collection("rides").doc(rideId);

      await firebase.assertSucceeds(rideRef.get());
    });

    test("Drivers can accept rides", async () => {
      // Setup: Create available ride
      const adminDb = testEnv
        .authenticatedContext(mockUser.uid, { admin: true })
        .firestore();
      const rideId = "test-ride";
      await adminDb.collection("rides").doc(rideId).set(mockRideData);

      // Test: Driver accepts ride
      const driverDb = testEnv.authenticatedContext(mockDriver.uid).firestore();
      const rideRef = driverDb.collection("rides").doc(rideId);

      await firebase.assertSucceeds(
        rideRef.update({
          driverId: mockDriver.uid,
          status: "accepted",
          acceptTime: firebase.firestore.FieldValue.serverTimestamp(),
        })
      );
    });

    test("Users cannot modify core ride details", async () => {
      // Setup: Create ride
      const adminDb = testEnv
        .authenticatedContext(mockUser.uid, { admin: true })
        .firestore();
      const rideId = "test-ride";
      await adminDb.collection("rides").doc(rideId).set(mockRideData);

      // Test: User tries to change pickup address
      const userDb = testEnv.authenticatedContext(mockUser.uid).firestore();
      const rideRef = userDb.collection("rides").doc(rideId);

      await firebase.assertFails(
        rideRef.update({
          pickupAddress: "Different Address",
        })
      );
    });

    test("Invalid ride data is rejected", async () => {
      const db = testEnv.authenticatedContext(mockUser.uid).firestore();
      const rideRef = db.collection("rides").doc();
      const invalidRideData = {
        riderId: mockUser.uid,
        // Missing required fields
        status: "invalid-status",
      };

      await firebase.assertFails(rideRef.set(invalidRideData));
    });
  });

  describe("Messages Collection Tests", () => {
    test("Ride participants can send messages", async () => {
      // Setup: Create ride with driver
      const adminDb = testEnv
        .authenticatedContext(mockUser.uid, { admin: true })
        .firestore();
      const rideId = "test-ride";
      const rideWithDriver = {
        ...mockRideData,
        driverId: mockDriver.uid,
        status: "accepted",
      };
      await adminDb.collection("rides").doc(rideId).set(rideWithDriver);

      // Test: Rider sends message
      const userDb = testEnv.authenticatedContext(mockUser.uid).firestore();
      const messageRef = userDb
        .collection("rides")
        .doc(rideId)
        .collection("messages")
        .doc();

      const messageData = {
        senderId: mockUser.uid,
        message: "Hello driver!",
        timestamp: firebase.firestore.FieldValue.serverTimestamp(),
      };

      await firebase.assertSucceeds(messageRef.set(messageData));
    });

    test("Non-participants cannot access messages", async () => {
      const userDb = testEnv.authenticatedContext("random-user").firestore();
      const messageRef = userDb
        .collection("rides")
        .doc("test-ride")
        .collection("messages")
        .doc("test-message");

      await firebase.assertFails(messageRef.get());
    });
  });

  describe("Reports Collection Tests", () => {
    test("Users can create reports", async () => {
      const db = testEnv.authenticatedContext(mockUser.uid).firestore();
      const reportRef = db.collection("reports").doc();

      const reportData = {
        reporterId: mockUser.uid,
        reportedUserId: mockDriver.uid,
        reason: "inappropriate_behavior",
        description: "Driver was rude",
        timestamp: firebase.firestore.FieldValue.serverTimestamp(),
      };

      await firebase.assertSucceeds(reportRef.set(reportData));
    });

    test("Users cannot create reports for others", async () => {
      const db = testEnv.authenticatedContext(mockUser.uid).firestore();
      const reportRef = db.collection("reports").doc();

      const reportData = {
        reporterId: "other-user", // Invalid: different from authenticated user
        reportedUserId: mockDriver.uid,
        reason: "inappropriate_behavior",
        description: "Test",
        timestamp: firebase.firestore.FieldValue.serverTimestamp(),
      };

      await firebase.assertFails(reportRef.set(reportData));
    });

    test("Reports cannot be modified after creation", async () => {
      // Setup: Create report
      const adminDb = testEnv
        .authenticatedContext(mockUser.uid, { admin: true })
        .firestore();
      const reportId = "test-report";
      const reportData = {
        reporterId: mockUser.uid,
        reportedUserId: mockDriver.uid,
        reason: "inappropriate_behavior",
        description: "Test report",
        timestamp: firebase.firestore.FieldValue.serverTimestamp(),
      };
      await adminDb.collection("reports").doc(reportId).set(reportData);

      // Test: Try to modify report
      const userDb = testEnv.authenticatedContext(mockUser.uid).firestore();
      const reportRef = userDb.collection("reports").doc(reportId);

      await firebase.assertFails(reportRef.update({ description: "Modified" }));
    });
  });
});

module.exports = {
  PROJECT_ID,
  mockUser,
  mockDriver,
  mockUserData,
  mockRideData,
};
