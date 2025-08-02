import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as html;

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
  external StripeElementJS create(String type, [JSObject? options]);
}

@JS()
@staticInterop
class StripeElementJS {
  external void mount(String selector);
  external void unmount();
  external void clear();
  external void destroy();
}

class StripeService {
  final String publishableKey;
  StripeJS? _stripe;
  ElementsJSObject? _elements;

  StripeService(this.publishableKey);

  Future<void> init() async {
    final completer = Completer<void>();
    final self = (html.window as JSAny).getProperty<JSFunction>('onStripeLoaded'.toJS);
    self.callAsFunction(null, () {
      if ((html.window as JSAny).hasProperty('Stripe'.toJS)) {
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

  Future<JSObject> createPaymentMethod(StripeElementJS card) async {
    final paymentMethodPromise = _stripe!.createPaymentMethod(
      {'type': 'card', 'card': card}.jsify() as JSObject,
    );
    return await paymentMethodPromise.toDart as JSObject;
  }

  Future<JSObject> confirmPayment(
      String clientSecret, StripeElementJS card, Map<String, dynamic> billingDetails) async {
    final paymentResultPromise = _stripe!.confirmCardPayment(
      clientSecret,
      {'payment_method': {'card': card, 'billing_details': billingDetails}}.jsify() as JSObject,
    );
    return await paymentResultPromise.toDart as JSObject;
  }
}

class StripeElement {
  final StripeElementJS element;

  StripeElement(this.element);

  void mount(String selector) {
    element.mount(selector);
  }

  void unmount() {
    element.unmount();
  }

  void clear() {
    element.clear();
  }

  void destroy() {
    element.destroy();
  }
}