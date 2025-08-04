import 'dart:js_interop';
import 'dart:html' as html;

@JS('Stripe')
class Stripe {
  external Stripe(String publicKey);

  external Elements elements();
  external JSPromise<PaymentIntentResponse> confirmCardPayment(String clientSecret, [ConfirmCardPaymentData? data]);
}

@JS()
@anonymous
extension type Elements._(JSObject _) implements JSObject {
  external Element create(String type, [ElementOptions? options]);
}

@JS()
@anonymous
extension type Element._(JSObject _) implements JSObject {
  external void mount(String selector);
  external void destroy();
  external void on(String event, JSFunction callback);
}

@JS()
@anonymous
extension type ElementOptions._(JSObject _) implements JSObject {
  external set style(ElementStyle style);
}

@JS()
@anonymous
extension type ElementStyle._(JSObject _) implements JSObject {
  external set base(ElementStyleBase base);
}

@JS()
@anonymous
extension type ElementStyleBase._(JSObject _) implements JSObject {
  external set color(String color);
  external set fontFamily(String fontFamily);
  external set fontSize(String fontSize);
  external set fontSmoothing(String fontSmoothing);
  external set placeholder(String placeholder);
}

@JS()
@anonymous
extension type ConfirmCardPaymentData._(JSObject _) implements JSObject {
  external set payment_method(PaymentMethod paymentMethod);
}

@JS()
@anonymous
extension type PaymentMethod._(JSObject _) implements JSObject {
  external set card(Element card);
  external set billing_details(BillingDetails billingDetails);
}

@JS()
@anonymous
extension type BillingDetails._(JSObject _) implements JSObject {
  external set name(String name);
  external set email(String email);
  external set phone(String phone);
  external set address(Address address);
}

@JS()
@anonymous
extension type Address._(JSObject _) implements JSObject {
  external set line1(String line1);
  external set line2(String line2);
  external set city(String city);
  external set state(String state);
  external set postal_code(String postalCode);
  external set country(String country);
}

@JS()
@anonymous
extension type PaymentIntentResponse._(JSObject _) implements JSObject {
  external PaymentIntent? get paymentIntent;
  external StripeError? get error;
}

@JS()
@anonymous
extension type PaymentIntent._(JSObject _) implements JSObject {
  external String get id;
  external String get status;
}

@JS()
@anonymous
extension type StripeError._(JSObject _) implements JSObject {
  external String get message;
}

class StripeService {
  late final Stripe _stripe;

  StripeService(String publicKey) {
    _stripe = Stripe(publicKey);
  }

  Elements get elements => _stripe.elements();

  Future<PaymentIntentResponse> confirmCardPayment(String clientSecret, Element cardElement, BillingDetails billingDetails) {
    return _stripe.confirmCardPayment(clientSecret, ConfirmCardPaymentData()
      ..payment_method = (PaymentMethod()
        ..card = cardElement
        ..billing_details = billingDetails
      )
    ).toDart;
  }
}
