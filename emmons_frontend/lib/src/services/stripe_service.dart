import 'dart:async';
import 'dart:js_interop';

@JS('Stripe')
@staticInterop
class StripeJS {
  external factory StripeJS(String publishableKey);
}

extension StripeJSExtension on StripeJS {
  external ElementsJSObject elements();
  external JSPromise createPaymentMethod(JSObject options);
  external JSPromise confirmCardPayment(String clientSecret, JSObject options);
}

@JS()
@staticInterop
class ElementsJSObject {
  external JSObject create(String type, [JSObject? options]);
}

class StripeService {
  final String publishableKey;
  StripeJS? _stripe;
  ElementsJSObject? _elements;

  StripeService(this.publishableKey);

  Future<void> init() async {
    final completer = Completer<void>();
    final self = globalContext.getProperty<JSFunction>('onStripeLoaded'.toJS);
    self.callAsFunction(null, () {
      if (globalContext.has('Stripe'.toJS)) {
        _stripe = StripeJS(publishableKey);
        _elements = _stripe?.elements();
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
      {'type': 'card', 'card': card}.jsify() as JSObject,
    );
    return await paymentMethodPromise.toDart as JSObject;
  }

  Future<JSObject> confirmPayment(
      String clientSecret, JSObject card, Map<String, dynamic> billingDetails) async {
    final paymentResultPromise = _stripe!.confirmCardPayment(
      clientSecret,
      {
        'payment_method': {
          'card': card,
          'billing_details': billingDetails,
        },
      }.jsify() as JSObject,
    );
    return await paymentResultPromise.toDart as JSObject;
  }
}