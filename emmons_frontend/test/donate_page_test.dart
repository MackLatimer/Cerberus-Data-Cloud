import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:candidate_website/src/pages/donate_page.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class MockStripe extends Mock implements Stripe {
  @override
  Future<PaymentSheetPaymentOption?> initPaymentSheet(
      {required SetupPaymentSheetParameters paymentSheetParameters}) async {
    return null;
  }

  @override
  Future<PaymentSheetPaymentOption?> presentPaymentSheet(
      {PaymentSheetPresentOptions? options}) async {
    return null;
  }
}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  testWidgets('DonatePage has a hero image and a donation grid',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DonatePage()));

    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('Tapping a donation button selects it and shows the form',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DonatePage()));

    final donationButton = find.text('\$10');
    expect(donationButton, findsOneWidget);

    await tester.tap(donationButton);
    await tester.pump();

    final selectedButton = find.byWidgetPredicate(
      (Widget widget) =>
          widget is ElevatedButton &&
          widget.style?.backgroundColor?.resolve({}) ==
              const Color(0xFF002663),
    );
    expect(selectedButton, findsOneWidget);

    expect(find.byType(Form), findsOneWidget);
  });

  testWidgets('Tapping "Proceed to Donation" shows the payment sheet',
      (WidgetTester tester) async {
    final mockStripe = MockStripe();
    final mockHttpClient = MockHttpClient();
    Stripe.publishableKey = 'pk_test_TYooMQauvdEDq54NiTphI7jx';

    // Mock the HTTP request to Stripe
    when(mockHttpClient.post(
      any,
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(
          '{"client_secret": "test_client_secret"}',
          200,
        ));

    await tester.pumpWidget(MaterialApp(
        home: DonatePage(
      httpClient: mockHttpClient,
    )));

    final donationButton = find.text('\$10');
    await tester.tap(donationButton);
    await tester.pump();

    // Fill the form
    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
    await tester.enterText(find.byType(TextFormField).at(2), '123 Main St');
    await tester.enterText(find.byType(TextFormField).at(3), 'Apt 4B');
    await tester.enterText(find.byType(TextFormField).at(4), 'Anytown');
    await tester.enterText(find.byType(TextFormField).at(5), 'CA');
    await tester.enterText(find.byType(TextFormField).at(6), '12345');
    await tester.enterText(
        find.byType(TextFormField).at(7), 'john.doe@example.com');
    await tester.enterText(find.byType(TextFormField).at(8), '555-555-5555');
    await tester.enterText(find.byType(TextFormField).at(9), 'Google');
    await tester.enterText(find.byType(TextFormField).at(10), 'Software Engineer');

    final proceedButton = find.text('Proceed to Donation');
    await tester.tap(proceedButton);
    await tester.pump();

    verify(mockStripe.presentPaymentSheet()).called(1);
  });
}
