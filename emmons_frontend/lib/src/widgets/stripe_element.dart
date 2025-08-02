import 'dart:js_interop';

class StripeElement {
  final JSObject element;

  StripeElement(this.element);

  void mount(String selector) {
    element.callMethod('mount'.toJS, selector.toJS);
  }

  Future<JSObject> createPaymentMethod() async {
    final result = await (globalContext.getProperty('stripe'.toJS) as JSObject)
        .callMethod('createPaymentMethod'.toJS, jsify({'type': 'card', 'card': element}) as JSAny)
        .toFuture;
    return result as JSObject;
  }
}