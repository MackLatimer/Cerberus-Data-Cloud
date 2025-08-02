import 'dart:async';
import 'dart:js_interop';

@JS()
external JSObject get stripe;

extension type StripeJSObject(JSObject _ref) implements JSObject {
  external JSObject callMethod(String methodName, [JSAny? arg1, JSAny? arg2]);
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

    setProperty(globalThis, 'onStripeLoaded'.toJS, (() {
      final stripeJs = getProperty(globalThis, 'Stripe'.toJS);
      if (stripeJs.isDefinedAndNotNull) {
        _stripe = (stripeJs as JSFunction).callAsConstructor<StripeJSObject>([publishableKey.toJS]);
        _elements = _stripe?.elements() as ElementsJSObject?;
        completer.complete();
      } else {
        completer.completeError('Stripe.js not loaded');
      }
    }).toJS);

    return completer.future;
  }

  ElementsJSObject? get elements => _elements;

  Future<JSObject> createPaymentMethod(JSObject card) async {
    final paymentMethodPromise = _stripe!.createPaymentMethod(
      <String, JSAny?>{'type'.toJS: 'card'.toJS, 'card'.toJS: card}.toJS,
    );
    return await promiseToFuture(paymentMethodPromise);
  }

  Future<JSObject> confirmPayment(String clientSecret, JSObject card, Map<String, dynamic> billingDetails) async {
    final paymentResultPromise = _stripe!.confirmCardPayment(
      clientSecret.toJS,
      <String, JSAny?>{
        'payment_method'.toJS: <String, JSAny?>{
          'card'.toJS: card,
          'billing_details'.toJS: billingDetails.toJSBox,
        }.toJS,
      }.toJS,
    );
    return await promiseToFuture(paymentResultPromise);
  }
}