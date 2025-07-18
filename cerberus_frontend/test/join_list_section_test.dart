import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cerberus_frontend/widgets/join_list_section.dart';

void main() {
  testWidgets('JoinListSection renders correctly and shows validation messages', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: JoinListSection(),
      ),
    ));

    // Verify that the widget renders correctly.
    expect(find.text('JOIN OUR EMAIL AND TEXT LIST'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Tap the submit button without entering any data.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that the validation messages are displayed.
    expect(find.text('Please enter your first name'), findsOneWidget);
    expect(find.text('Please enter your last name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
  });
}
