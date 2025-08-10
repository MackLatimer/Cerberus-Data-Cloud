// A mock implementation of dart:html for non-web platforms.
// This allows the config_loader to compile and run in a mobile or desktop environment.

class MockWindow {
  final MockLocation location = MockLocation();
}

class MockLocation {
  String? get hostname => null;
}

final MockWindow window = MockWindow();
