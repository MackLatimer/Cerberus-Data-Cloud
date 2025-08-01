import 'dart:html';
import 'dart:js' as js;
import 'dart:js_util' as js_util;
import 'dart:async';

class StripeService {
  final String publishableKey;
  js.JsObject? _stripe;
  js.JsObject? _elements;

  StripeService(this.publishableKey);

  Future<void> init() async {
    final completer = Completer<void>();
    const maxRetries = 50; // 5 seconds timeout (50 * 100ms)
    int retries = 0;

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (js_util.hasProperty(js.context, 'Stripe')) {
        timer.cancel();
        final stripeJs = js_util.getProperty(js.context, 'Stripe');
        if (stripeJs != null) {
          print("Stripe.js loaded successfully.");
          _stripe = js.JsObject(stripeJs, [publishableKey]);
          _elements = _stripe?.callMethod('elements');
          completer.complete();
        } else {
          print("Stripe.js object is null.");
          completer.completeError('Stripe.js object is null');
        }
      } else {
        retries++;
        if (retries > maxRetries) {
          timer.cancel();
          print("Timed out waiting for Stripe.js to load.");
          completer.completeError('Timed out waiting for Stripe.js to load.');
        }
      }
    });

    return completer.future;
  }

  js.JsObject? get elements => _elements;

  Future<js.JsObject> createPaymentMethod(js.JsObject card) async {
    final paymentMethodPromise = _stripe!.callMethod('createPaymentMethod', [
      js.JsObject.jsify({'type': 'card', 'card': card})
    ]);
    return js_util.promiseToFuture<js.JsObject>(paymentMethodPromise);
  }

  Future<js.JsObject> confirmPayment(String clientSecret, js.JsObject card, Map<String, dynamic> billingDetails) async {
    final paymentResultPromise = _stripe!.callMethod('confirmCardPayment', [
      clientSecret,
      js.JsObject.jsify({
        'payment_method': {
          'card': card,
          'billing_details': billingDetails,
        }
      })
    ]);
    return js_util.promiseToFuture<js.JsObject>(paymentResultPromise);
  }
}