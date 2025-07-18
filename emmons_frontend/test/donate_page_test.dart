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
    Stripe.instance = mockStripe;

    await tester.pumpWidget(const MaterialApp(home: DonatePage()));

    final donationButton = find.text('\$10');
    await tester.tap(donationButton);
    await tester.pump();

    final proceedButton = find.text('Proceed to Donation');
    await tester.tap(proceedButton);
    await tester.pump();

    verify(mockStripe.presentPaymentSheet()).called(1);
  });
}
