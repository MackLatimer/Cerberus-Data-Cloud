# Stripe Payment Element

Accept payment methods from around the globe with a secure, embeddable UI component.

The Payment Element is a UI component for the web that accepts 40+ payment methods, validates input, and handles errors. Use it alone or with other elements in your web app’s front end.

## Compatible APIs

Stripe offers two core payments APIs compatible with Elements that give you the flexibility to accept various types of payments from your customers. You can integrate these APIs into Stripe’s prebuilt payment interfaces. The APIs serve different use cases depending on how you choose to structure your checkout flow and how much control you require. For most use cases, we recommend using [Checkout Sessions](https://docs.stripe.com/api/checkout/sessions.md).

- Use the [Checkout Sessions API](https://docs.stripe.com/api/checkout/sessions.md) to model your customer’s complete checkout flow, including the line items in their purchase, billing and shipping addresses, applicable tax rates, and coupons or discounts. The Checkout Session allows you to create subscriptions, calculate tax rates with Stripe Tax, and initiate payments using a single integration.

  Build a [checkout page with the Checkout Session API](https://docs.stripe.com/checkout/custom/quickstart.md).

- Use the [Payment Intents API](https://docs.stripe.com/api/payment_intents.md) to model just the payments step with more granular control. Unlike the Checkout Sessions API, which requires line item details, you only pass in the final amount you want to charge. This is suitable for advanced payment flows where you want to manually compute the final amount. When using Payment Intents, you must build separate integrations with the Stripe Tax API if you want to use Stripe to calculate applicable taxes or with the Subscriptions API if you want to use Stripe to create subscriptions.

  Build an [advanced integration with the Payment Intents API](https://docs.stripe.com/payments/advanced.md).
 (See full diagram at https://docs.stripe.com/payments/payment-element)
[Build a checkout page with Payment Element](https://docs.stripe.com/checkout/custom/quickstart.md): Build an integration with the Payment Element using the Checkout Sessions API.

[Build an advanced integration with Payment Element](https://docs.stripe.com/payments/quickstart.md): Build an integration with the Payment Element using the Payment Intents API.

[Clone a sample app on GitHub](https://github.com/stripe-samples/accept-a-payment/tree/main/payment-element)

## Combine elements

The Payment Element interoperates with other elements. For instance, this form uses one additional element to [autofill checkout details](https://docs.stripe.com/payments/link.md), and another to [collect the shipping address](https://docs.stripe.com/elements/address-element.md).

> You can’t remove the Link legal agreement because it’s required to ensure compliance with proper user awareness of terms of services and privacy policies. The [terms](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-terms) object doesn’t apply to the Link legal agreement.

![A form with contact info, shipping address, and payment fields. The contact info is labeled Link Authentication Element, the shipping address is labeled Address Element, and the payment fields are labeled Payment Element.](https://b.stripecdn.com/docs-statics-srv/assets/link-with-elements.f60af275f69b6e6e73c766d1f9928457.png)
Payment form combining multiple elements

For the complete code for this example, see [Add Link to an Elements integration](https://docs.stripe.com/payments/link/add-link-elements-integration.md).

You can also combine the Payment Element with the [Express Checkout Element](https://docs.stripe.com/elements/express-checkout-element.md). In this case, wallet payment methods such as Apple Pay and Google Pay are only displayed in the Express Checkout Element to avoid duplication.

## Payment methods

Stripe enables certain payment methods for you by default. We might also enable additional payment methods after notifying you. Use the [Dashboard](https://dashboard.stripe.com/settings/payment_methods) to enable or disable payment methods at any time. With the Payment Element, you can use [Dynamic payment methods](https://docs.stripe.com/payments/payment-methods/dynamic-payment-methods.md) to:

- Manage payment methods in the [Dashboard](https://dashboard.stripe.com/settings/payment_methods) without coding
- Dynamically display the most relevant payment options based on factors such as location, currency, and transaction amount

For instance, if a customer in Germany is paying in EUR, they see all the active payment methods that accept EUR, starting with ones that are widely used in Germany.
![A variety of payment methods.](https://b.stripecdn.com/docs-statics-srv/assets/payment-element-methods.26cae03aff199d6f02b0d92bd324c219.png)

Show payment methods in order of relevance to your customer

To further customize how payment methods render, see [Customize payment methods](https://docs.stripe.com/payments/customize-payment-methods.md). To add payment methods integrated outside of Stripe, you can use [custom payment methods](https://docs.stripe.com/payments/payment-element/custom-payment-methods.md).

If your integration requires you to list payment methods manually, see [Manually list payment methods](https://docs.stripe.com/payments/payment-methods/integration-options.md#listing-payment-methods-manually).

## Layout

You can customize the Payment Element’s layout to fit your checkout flow. The following image is the same Payment Element rendered using different layout configurations.
![Examples of the three checkout forms. The image shows the tab option, where customers pick from payment methods shown as tabs or the two accordion options, where payment methods are vertically listed. You can choose to either display radio buttons or not in the accordion view. ](https://b.stripecdn.com/docs-statics-srv/assets/pe_layout_example.525f78bcb99b95e49be92e5dd34df439.png)

Payment Element with different layouts.

#### Tabs

The tabs layout displays payment methods horizontally using tabs. To use this layout, set the value for [layout.type](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-layout-type) to `tabs`. You can also specify other properties, such as [layout.defaultCollapsed](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-layout-defaultCollapsed).

```javascript
const stripe = Stripe('<<YOUR_PUBLISHABLE_KEY>>');

const appearance = { /* appearance */ };
const options = {
  layout: {
    type: 'tabs',
    defaultCollapsed: false,
  }
};
const elements = stripe.elements({ clientSecret, appearance }); // In a working integration, this is a value your backend passes with details such as the amount of a payment. See full sample for details.
const paymentElement = elements.create('payment', options);
paymentElement.mount('#payment-element');
```

#### Accordion with radio buttons

The accordion layout displays payment methods vertically using an accordion. To use this layout, set the value for [layout.type](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-layout-type) to `accordion`. You can also specify other properties, such as [layout.radios](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-layout-radios) to display radio buttons.

```javascript
const stripe = Stripe('<<YOUR_PUBLISHABLE_KEY>>');

const appearance = { /* appearance */ };
const options = {
  layout: {
    type: 'accordion',
    defaultCollapsed: false,
    radios: true,
    spacedAccordionItems: false
  }
};
const clientSecret = {{CLIENT_SECRET}}; // In a working integration, this is a value your backend passes with details such as the amount of a payment. See full sample for details.
const elements = stripe.elements({ clientSecret, appearance });
const paymentElement = elements.create('payment', options);
paymentElement.mount('#payment-element');
```

#### Accordion without radio buttons

The accordion layout displays payment methods vertically using an accordion. To use this layout, set the value for [layout.type](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-layout-type) to `accordion`. You can also specify other properties, such as [layout.spacedAccordionItems](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-layout-spacedAccordionItems) to create additional vertical space.

```javascript
const stripe = Stripe('<<YOUR_PUBLISHABLE_KEY>>');

const appearance = { /* appearance */ };
const options = {
  layout: {
    type: 'accordion',
    defaultCollapsed: false,
    radios: false,
    spacedAccordionItems: true
  }
};
const clientSecret = {{CLIENT_SECRET}}; // In a working integration, this is a value your backend passes with details such as the amount of a payment. See full sample for details.
const elements = stripe.elements({ clientSecret, appearance });
const paymentElement = elements.create('payment', options);
paymentElement.mount('#payment-element');
```

## Appearance

Use the Appearance API to control the style of all elements. Choose a theme or update specific details.
![Examples of light and dark modes for the payment element checkout form.](https://b.stripecdn.com/docs-statics-srv/assets/appearance_example.e076cc750983bf552baf26c305e7fc90.png)

For instance, choose the “flat” theme and override the primary text color.

```javascript
const stripe = Stripe('<<YOUR_PUBLISHABLE_KEY>>');

const appearance = {
  theme: 'flat',
  variables: { colorPrimaryText: '#262626' }
};
const options = { /* options */ };
const elements = stripe.elements({ clientSecret, appearance }); // In a working integration, this is a value your backend passes with details such as the amount of a payment. See full sample for details.
const paymentElement = elements.create('payment', options);
paymentElement.mount('#payment-element');
```

See the [Appearance API](https://docs.stripe.com/elements/appearance-api.md) documentation for a full list of themes and variables.

## Options

Stripe elements support more options than these. For instance, display your business name using the [business](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-business) option.

```javascript
const stripe = Stripe('<<YOUR_PUBLISHABLE_KEY>>');

const appearance = { /* appearance */};
const options = {
  business: { name: "RocketRides" }
};
const clientSecret = {{CLIENT_SECRET}}; // In a working integration, this is a value your backend passes with details such as the amount of a payment. See full sample for details.
const elements = stripe.elements(appearance, clientSecret);
const paymentElement = elements.create('payment', options);
paymentElement.mount('#payment-element');
```

The Payment Element supports the following options. See each options’s reference entry for more information.

| [layout](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-layout)               | Layout for the Payment Element.                                                                                                            |
| ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| [defaultValues](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-defaultValues) | Initial customer information to display in the Payment Element.                                                                            |
| [business](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-business)           | Information about your business to display in the Payment Element.                                                                         |
| [paymentMethodOrder](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-business) | Order to list payment methods in.                                                                                                          |
| [fields](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-fields)               | Whether to display certain fields.                                                                                                         |
| [readOnly](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-readOnly)           | Whether payment details can be changed.                                                                                                    |
| [terms](https://docs.stripe.com/js/elements_object/create_payment_element#payment_element_create-options-terms)                 | Whether mandates or other legal agreements are displayed in the Payment Element. The default behavior is to show them only when necessary. |
| [wallets](https://docs.stripe.com/js/elements_object/create_payment_element)                                                    | Whether to show wallets like Apple Pay or Google Pay. The default is to show them when possible.                                           |

## Errors

Payment Element automatically shows localized customer-facing error messages during client confirmation for the following error codes:

- `generic_decline`
- `insufficient_funds`
- `incorrect_zip`
- `incorrect_cvc`
- `invalid_cvc`
- `invalid_expiry_month`
- `invalid_expiry_year`
- `expired_card`
- `fraudulent`
- `lost_card`
- `stolen_card`
- `card_velocity_exceeded`

To display messages for other types of errors, refer to [error codes](https://docs.stripe.com/error-codes.md) and [error handling](https://docs.stripe.com/error-handling.md).