import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart'; // Import the camera package

import 'package:testapp/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Mock CameraDescription object
    final CameraDescription mockCamera = CameraDescription(
      name: 'mock_camera',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 0, // Provide a value for sensorOrientation
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(camera: mockCamera));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
