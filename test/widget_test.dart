// Basic widget test for RideShare app

import 'package:flutter_test/flutter_test.dart';
import 'package:rideshear/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RideShareApp());

    // Verify that the app loads and shows sign in screen
    expect(find.text('RideShare'), findsOneWidget);
  });
}
