import 'dart:js_interop';


class StripeElement {
  final JSObject element;

  StripeElement(this.element);

  void mount(String selector) {
    element.callMethod('mount'.toJS, selector.toJS);
  }

  void unmount() {
    element.callMethod('unmount'.toJS);
  }

  void clear() {
    element.callMethod('clear'.toJS);
  }

  void destroy() {
    element.callMethod('destroy'.toJS);
  }
}
