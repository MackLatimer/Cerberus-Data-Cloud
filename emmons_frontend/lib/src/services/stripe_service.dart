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

    js_util.setProperty(js.context, 'onStripeLoaded', js.allowInterop(() {
      final stripeJs = js_util.getProperty(js.context, 'Stripe');
      if (stripeJs != null) {
        _stripe = js.JsObject(stripeJs, [publishableKey]);
        _elements = _stripe?.callMethod('elements');
        completer.complete();
        print('Stripe.js loaded and initialized.');
      } else {
        completer.completeError('Stripe.js not loaded');
        print('Error: Stripe.js not loaded.');
      }
    }));

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