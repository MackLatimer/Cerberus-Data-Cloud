import 'dart:async';
import 'dart:js_interop';




import 'package:web/web.dart' as html;

// Define an extension type for html.Window to expose JS properties
@JS()
@anonymous
extension type WindowExtension._(JSObject _) implements JSObject {
  external JSObject? get stripe; // Assuming Stripe is a global JS object
  external set onStripeLoaded(JSFunction value);
}

@JS('Stripe')
@staticInterop
class StripeJs {
  external factory StripeJs(String publishableKey);
}

extension StripeJsExtension on StripeJs {
  external ElementsJsObject elements();
  external JSPromise createPaymentMethod(JSObject options);
  external JSPromise confirmCardPayment(String clientSecret, JSObject options);
}

@JS()
@staticInterop
class ElementsJsObject {}

extension ElementsJsObjectExtension on ElementsJsObject {
  external StripeElementJs create(String type, [JSObject? options]);
}

@JS()
@staticInterop
class StripeElementJs {}

extension StripeElementJsExtension on StripeElementJs {
  external void mount(String selector);
  external void unmount();
  external void clear();
  external void destroy();
}

class StripeService {
  final String publishableKey;
  StripeJs? _stripe;
  ElementsJsObject? _elements;

  StripeService(this.publishableKey);

  Future<void> init() async {
    final completer = Completer<void>();
    // Use the extension type for property access
    (html.window as WindowExtension).onStripeLoaded = (() {
      if ((html.window as WindowExtension).stripe != null) {
        _stripe = StripeJs(publishableKey);
        _elements = _stripe?.elements();
        completer.complete();
      } else {
        completer.completeError('Stripe.js not loaded');
      }
    }).toJS);
    return completer.future;
  }

  ElementsJsObject? get elements => _elements;

  Future<JSObject> createPaymentMethod(StripeElementJs card) async {
    final paymentMethodPromise = _stripe!.createPaymentMethod(
      {'type': 'card', 'card': card}.jsify() as JSObject,
    );
    return await paymentMethodPromise.toDart as JSObject;
  }

  Future<JSObject> confirmPayment(
      String clientSecret, StripeElementJs card, Map<String, dynamic> billingDetails) async {
    final paymentResultPromise = _stripe!.confirmCardPayment(
      clientSecret,
      {'payment_method': {'card': card, 'billing_details': billingDetails}}.jsify() as JSObject,
    );
    return await paymentResultPromise.toDart as JSObject;
  }
}

class StripeElement {
  final StripeElementJs element;

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
