import 'dart:async';
import 'dart:js_interop';

@JS()
external JSObject get stripe;

extension type StripeJSObject(JSObject _ref) implements JSObject {
  external JSObject elements();
  external JSPromise createPaymentMethod(JSObject options);
  external JSPromise confirmCardPayment(String clientSecret, JSObject options);
}

extension type ElementsJSObject(JSObject _ref) implements JSObject {
  external JSObject create(String type, [JSObject? options]);
}

class StripeService {
  final String publishableKey;
  StripeJSObject? _stripe;
  ElementsJSObject? _elements;

  StripeService(this.publishableKey);

  Future<void> init() async {
    final completer = Completer<void>();

    globalContext.setProperty('onStripeLoaded'.toJS, () {
      final stripeJs = globalContext.getProperty('Stripe'.toJS);
      if (stripeJs.isDefinedAndNotNull) {
        _stripe = stripeJs.callAsConstructor<StripeJSObject>(publishableKey.toJS);
        _elements = _stripe?.elements() as ElementsJSObject?;
        completer.complete();
      } else {
        completer.completeError('Stripe.js not loaded');
      }
    }.toJS);

    return completer.future;
  }

  ElementsJSObject? get elements => _elements;

  Future<JSObject> createPaymentMethod(JSObject card) async {
    final paymentMethodPromise = _stripe!.createPaymentMethod(
      jsify({'type': 'card', 'card': card}) as JSObject,
    );
    return await paymentMethodPromise.toFuture;
  }

  Future<JSObject> confirmPayment(String clientSecret, JSObject card, Map<String, dynamic> billingDetails) async {
    final paymentResultPromise = _stripe!.confirmCardPayment(
      clientSecret,
      jsify({
        'payment_method': {
          'card': card,
          'billing_details': billingDetails,
        },
      }) as JSObject,
    );
    return await paymentResultPromise.toFuture;
  }
}