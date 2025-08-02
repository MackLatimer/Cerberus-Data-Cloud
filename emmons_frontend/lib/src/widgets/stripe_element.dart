import 'dart:js_interop';

class StripeElement {
  final JSObject element;

  StripeElement(this.element);

  void mount(String selector) {
    element.callMethod('mount'.toJS, [selector.toJS]);
  }

  Future<JSObject> createPaymentMethod() async {
    final result = await (globalThis as JSObject).getProperty('stripe'.toJS).callMethod('createPaymentMethod'.toJS, [
      <String, JSAny?>{'type': 'card'.toJS, 'card': element}.toJS,
    ]).toPromise.toFuture;
    return result;
  }
}