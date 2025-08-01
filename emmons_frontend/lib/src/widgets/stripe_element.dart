import 'dart:js' as js;

class StripeElement {
  final js.JsObject element;

  StripeElement(this.element);

  void mount(String selector) {
    element.callMethod('mount', [selector]);
  }

  Future<js.JsObject> createPaymentMethod() async {
    final result = await js.context.callMethod('stripe.createPaymentMethod', [
      js.JsObject.jsify({'type': 'card', 'card': element})
    ]);
    return result;
  }
}