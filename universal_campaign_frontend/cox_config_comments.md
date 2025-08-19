```json
{
  "campaignId": 2, // Corresponds to the unique identifier for the Cox campaign.
  "default_campaign_id": "cox", // Specifies "cox" as the default campaign ID for the site.
  "defaultCampaign": true, // Indicates that this is the default campaign configuration to be loaded.
  "stripePublicKey": "pk_live_51RprktRfTCt4TPGsqAgRck5QC3G795vtuLhnBmiFUKlO7pUgYbnbLSHk2mb8tUj0aBigtfeUclAmuCePvQLMlxkQ00vMlmX9To", // Stripe public key for the Cox campaign, used for client-side Stripe operations.
  "stripeSecretKeySecretManagerName": "projects/Cerberus-Data-Cloud/secrets/COX_STRIPE_SECRET_KEY", // Name of the secret in Secret Manager for Stripe secret key.
  "stripeWebhookKeySecretManagerName": "projects/Cerberus-Data-Cloud/secrets/COX_STRIPE_WEBHOOK_KEY", // Name of the secret in Secret Manager for Stripe webhook key.
  "apiBaseUrl": "https://cerberus-backend-885603051818.us-south1.run.app/api/v1", // Base URL for the backend API used by the Cox campaign site.
  "theme": { // Defines the visual theme and styling for the Cox campaign site.
    "primaryColor": "#4e008e", // Primary color used across the site (e.g., for headers, main buttons).
    "secondaryColor": "#ba0020", // Secondary color used for accents and highlights.
    "backgroundColor": "#FFFFFF", // Default background color for pages.
    "textColor": "#000000", // Default text color.
    "fontFamily": "Montserrat Bold", // Primary font family for headings and prominent text.
    "secondaryFontFamily": "Playfair Display", // Secondary font family for body text.
    "usePageTransitions": false, // Flag to enable or disable page transition animations.
    "issuesSectionTheme": { // Theme settings specific to the "Issues" section.
      "backgroundColor": "#4e008e", // Background color for the issues section.
      "textColor": "#FFFFFF", // Text color within the issues section.
      "buttonColor": "#FFFFFF", // Button background color in the issues section.
      "buttonTextColor": "#ba0020" // Button text color in the issues section.
    },
    "aboutMeSectionTheme": { // Theme settings specific to the "About Me" section.
      "backgroundColor": "#FFFFFF", // Background color for the about me section.
      "textColor": "#4e008e", // Text color within the about me section.
      "buttonColor": "#4e008e", // Button background color in the about me section.
      "buttonTextColor": "#FFFFFF" // Button text color in the about me section.
    },
    "endorsementsSectionTheme": { // Theme settings specific to the "Endorsements" section.
      "backgroundColor": "#4e008e", // Background color for the endorsements section.
      "textColor": "#FFFFFF", // Text color within the endorsements section.
      "buttonColor": "#FFFFFF", // Button background color in the endorsements section.
      "buttonTextColor": "#ba0020" // Button text color in the endorsements section.
    },
    "donateSectionTheme": { // Theme settings specific to the "Donate" section.
      "backgroundColor": "#FFFFFF", // Background color for the donate section.
      "textColor": "#4e008e", // Text color within the donate section.
      "buttonColor": "#4e008e", // Button background color in the donate section.
      "buttonTextColor": "#FFFFFF" // Button text color in the donate section.
    }
  },
  "content": { // Contains all text content and asset paths for various pages and widgets.
    "siteTitle": "Bea Cox for JP", // The title displayed in the browser tab or app header.
    "faviconImagePath": "assets/favicons/Cox_Favicon.png", // Path to the favicon image for the Cox site.
    "launchStatus": true, // Indicates if the campaign site is officially launched.
    "comingSoonPage": { // Content for the "Coming Soon" page.
      "title": "Our campaign is launching soon!", // Title for the coming soon page.
      "subtitle": "In the meantime, you can support our campaign by donating below."
    },
    "homePage": { // Content for the "Home" page.
      "heroTitle": "Welcome to our campaign!", // Main title in the hero section of the home page.
      "callToActionText": "Join us in making a difference.", // Call to action text on the home page.
      "heroImagePath": "assets/images/Cox_Home_Hero.png", // Path to the hero image on the home page.
      "homeTitleMessage": "Welcome to our campaign2!", // Another welcome message on the home page.
      "issuesImage": "assets/images/Cox_Home_Issues_Preview.png", // Image for the issues preview section on the home page.
      "issuesMessage": "I am running to bring Justice, Transparency, and Efficiency to our JP court. The west side of our county deserves better.", // Description for the issues preview.
      "issuesButton": "View Issues", // Text for the button linking to the issues page.
      "aboutMeImage": "assets/images/Cox_Home_About_Preview.png", // Image for the about me preview section on the home page.
      "aboutMeMessage": "I have served Bell County for many years and will it will always be my home. Read my story here.", // Description for the about me preview.
      "aboutMeButton": "About Me", // Text for the button linking to the about me page.
      "endorsementsImage": "assets/images/Cox_Home_Endorsements_Preview.png", // Image for the endorsements preview section on the home page.
      "endorsementsMessage": "Making a better Bell County requires support from our community. I am humbled by the support I have received.", // Description for the endorsements preview.
      "endorsementsButton": "View Endorsements", // Text for the button linking to the endorsements page.
      "donateImage": "assets/images/Cox_Home_Donate_Preview.png", // Image for the donate preview section on the home page.
      "donateMessage": "I can't do this alone. I need your support to win this election and bring positive change to our community.", // Description for the donate preview.
      "donateButton": "Donate Now"
    },
    "issuesPage": { // Content for the "Issues" page.
      "appBarTitle": "Key Issues", // Title displayed in the app bar for the issues page.
      "heroImagePath": "assets/images/Cox_Issues_Hero.png", // Path to the hero image on the issues page.
      "title": "Issues", // Main title for the issues page.
      "issueSections": [
        {
          "title": "Justice", // Title of the first issue.
          "description": "Justice is swift and justice is fair. I will use my experience working in JP court and as your Truancy Master to balance deterrence and rehabilitation as we make our streets safer.", // Description of the first issue.
          "backgroundColor": "#4e008e", // Background color for this issue section.
          "textColor": "#FFFFFF", // Text color for this issue section.
          "imagePath": "assets/images/Cox_Issues_Issue1.png"
        },
        {
          "title": "Transparency", // Title of the second issue.
          "description": "A JP court should not be an uncertain or random place. Predictability and consistency in rulings allows people to solve problems before they even reach the court. I will always give a thorough reasoning for the decisions I make so we can increase confidence in our court again", // Description of the second issue.
          "backgroundColor": "#FFFFFF", // Background color for this issue section.
          "textColor": "#4e008e", // Text color for this issue section.
          "imagePath": "assets/images/Cox_Issues_Issue2.png"
        },
        {
          "title": "Efficiency", // Title of the third issue.
          "description": "This community deserves a full-time judge for a full-time job. That means being a judge who handles every duty of the office—from signing warrants and conducting magistration to performing inquests at a moment's notice.", // Description of the third issue.
          "backgroundColor": "#ba0020", // Background color for this issue section.
          "textColor": "#FFFFFF", // Text color for this issue section.
          "imagePath": "assets/images/Cox_Issues_Issue3.png"
        }
      ]
    },
    "aboutPage": { // Content for the "About" page.
      "appBarTitle": "About Bea Cox", // Title displayed in the app bar for the about page.
      "heroImagePath": "assets/images/Cox_About_Hero.png", // Path to the hero image on the about page.
      "bioTitle": "About Me", // Title for the biography section.
      "bioParagraph1": "Bea Cox is a lifelong resident of Killeen with deep ties to both her community and her faith. Her father, a proud U.S. Army veteran, retired from Fort Hood in 1977 as a Sergeant First Class, settling their family in Killeen to stay close to their Texas roots. She and her husband Garry have been married for 21 years and share four sons. Together, they are active members of Maxdale Cowboy Church, where she also serves on the Praise & Worship Team.", // First paragraph of the biography.
      "bioParagraph2": "For more than three decades, Bea has dedicated her life to public service. She began her career working in the Killeen Police Department’s records division while still in high school, later serving in the vehicle registration office before embarking on a 25-year career with Bell County. For 23 of those years, she served under the Justice of the Peace, and now Sheriff, Bill Cooke as his Deputy Clerk and eventually Chief Clerk, before becoming the first appointed Bell County Truancy Master. She credits her faith, integrity, and strong work ethic for guiding her through these years of service.", // Second paragraph of the biography.
      "bioParagraph3": "Beyond her professional commitments, Bea is an active member of numerous community organizations, including the Central Texas Republican Women-PAC and LULAC Herencia Chapter #4297. These roles have allowed her to build strong relationships with citizens across Bell County, giving her valuable perspective on the needs and aspirations of the community she proudly calls home. With 35 years of service behind her, she continues to carry forward the same commitment to people and principles that has defined her life’s work.", // Third paragraph of the biography.
      "bioImage1Path": "assets/images/Cox_About_Bio1.png", // Path to the first biography image.
      "bioImage2Path": "assets/images/Cox_About_Bio2.png", // Path to the second biography image.
      "bioImage3Path": "assets/images/Cox_About_Bio3.png"
    },
    "endorsementsPage": { // Content for the "Endorsements" page.
      "appBarTitle": "Endorsements", // Title displayed in the app bar for the endorsements page.
      "heroImagePath": "assets/images/Cox_Endorsements_Hero.png", // Path to the hero image on the endorsements page.
      "title": "Endorsed by Leaders and the Community", // Main title for the endorsements page.
      "endorsements": [
        {
          "name": "Mack Latimer", // Name of the endorser.
          "quote": "Bea Cox is the Person we need in JP 4. She has the temperment, experience, and work ethic to turn that office around.", // Quote from the endorser.
          "imagePath": "assets/images/Cox_Endorsements_1.png", // Image of the endorser.
          "imageLeft": true, // Boolean to control image position (left/right).
          "backgroundColor": "#FFFFFF", // Background color for this endorsement card.
          "textColor": "#4e008e" // Text color for this endorsement card.
        }
      ],
      "communityTitle": "Community Endorsements", // Title for the community endorsements section.
      "communityEndorsements": [
        "Laura Latimer",
        "Michael Smith",
        "Alyssa Hill"
      ],
      "endorsementCallToAction": "Join the list of supporters!", // Call to action for endorsements.
      "endorsementCallToActionText": "Fill out the form below to endorse Bea Cox and allow her to publish your endorsement on this page."
    },
    "donatePage": { // Content for the "Donate" page.
      "heroImagePath": "assets/images/Cox_Donate_Hero.png", // Path to the hero image on the donate page.
      "title": "Support Our Campaign", // Main title for the donate page.
      "subtitle": "Your contribution helps us make a difference in our community.", // Subtitle for the donate page.
      "mailDonationText": "If you prefer to donate by mail, please send a check payable to \"Bea Cox Campaign\" to: 127 Lake Road, Belton, TX 76513"
    },
    "commonAppBar": { // Content for the common app bar across the site.
      "logoPath": "assets/logos/Cox_Logo.png", // Path to the campaign logo in the app bar.
      "logoWidth": 400.0, // Width of the logo.
      "logoHeight": 100.0, // Height of the logo.
      "navItems": [
        {"label": "Home", "path": "/home"},
        {"label": "About", "path": "/about"},
        {"label": "Issues", "path": "/issues"},
        {"label": "Donate", "path": "/donate"},
        {"label": "Endorsements", "path": "/endorsements"}
      ]
    },
    "widgets": { // Configuration for various reusable widgets.
      "signupForm": {
        "title": "Sign Up for Updates", // Title for the signup form.
        "endorseText": "I endorse Bea Cox and allow her to publish my endorsement", // Text for the endorsement checkbox.
        "getInvolvedText": "I want to get involved with the campaign", // Text for the get involved checkbox.
        "automatedMessagingText": "I agree to receive automated messaging from the Bea Cox Campaign", // Text for automated messaging consent.
        "emailOptInText": "I agree to receive emails from the Bea Cox Campaign", // Text for email opt-in consent.
        "buttonText": "Submit", // Text for the submit button.
        "privacyButtonText": "Privacy Policy", // Text for the privacy policy button.
        "legalText": "By submitting this form, you agree to receive communications from the campaign."
      },
      "donateWidget": {
        "amounts": [25, 50, 100, 250, 500, 1000],
        "customAmountLabel": "Custom Amount",
        "continueButtonText": "Continue",
        "selectAmountValidation": "Please select or enter an amount",
        "firstNameLabel": "First Name",
        "lastNameLabel": "Last Name",
        "addressLine1Label": "Address Line 1",
        "addressLine2Label": "Address Line 2 (Optional)",
        "cityLabel": "City",
        "stateLabel": "State",
        "zipCodeLabel": "Zip Code",
        "employerLabel": "Employer",
        "occupationLabel": "Occupation",
        "firstNameValidation": "Please enter your first name",
        "lastNameValidation": "Please enter your last name",
        "addressValidation": "Please enter your address",
        "cityValidation": "Please enter your city",
        "stateValidation": "Please enter your state",
        "zipCodeValidation": "Please enter your zip code",
        "employerValidation": "Please enter your employer",
        "occupationValidation": "Please enter your occupation",
        "proceedToPaymentButtonText": "Proceed to Payment",
        "coverFeesText": "Cover transaction fees",
        "recurringDonationText": "Make this a recurring monthly donation",
        "emailLabel": "Email",
        "phoneNumberLabel": "Phone Number",
        "emailValidation": "Please enter your email",
        "invalidEmailValidation": "Please enter a valid email address",
        "contactEmailText": "Contact me via Email",
        "contactPhoneText": "Contact me via Phone Call",
        "contactMailText": "Contact me via Mail",
        "contactSmsText": "Contact me via SMS",
        "submitButtonText": "Submit"
      }
    },
    "donateSection": {
      "callToActionText": "Make a Difference!",
      "buttonText": "Donate Now!"
    },
    "footer": {
      "paidForText": "Paid for by the Bea Cox Campaign",
      "facebookLink": "https://www.facebook.com/beaforjp",
      "instagramLink": "https://www.instagram.com/beaforjp",
      "xLink": "https://x.com/beaforjp",
      "linkedinLink": "https://www.linkedin.com/company/beaforjp",
      "youtubeLink": "https://www.youtube.com/beaforjp"
    }
  }
}
```