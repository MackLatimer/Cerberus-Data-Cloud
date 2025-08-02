import 'dart:js_interop' as js_interop;

class StripeElement {
  final js_interop.JSObject element;

  StripeElement(this.element);

  void mount(String selector) {
    js_interop.callMethod(element, 'mount'.toJS, [selector.toJS]);
  }

  Future<js_interop.JSObject> createPaymentMethod() async {
    final result = await js_interop.promiseToFuture(js_interop.callMethod(js_interop.getProperty(js_interop.globalThis, 'stripe'.toJS), 'createPaymentMethod'.toJS, [
      js_interop.jsify(<String, js_interop.JSAny?>{'type'.toJS: 'card'.toJS, 'card'.toJS: element}),
    ]));
    return result;
  }
}