import 'dart:js_interop';

@JS()
@staticInterop
extension type StripeElementJS(JSObject _ref) implements JSObject {
  external void mount(String selector);
  external void unmount();
  external void clear();
  external void destroy();
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
