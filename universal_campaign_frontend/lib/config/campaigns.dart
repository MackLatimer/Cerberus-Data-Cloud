import 'package:flutter/material.dart';
import 'campaign_config.dart';

final Map<String, CampaignConfig> campaigns = {
  'emmons': const CampaignConfig(
    campaignId: 'emmons-2024',
    domain: 'electemmons.com',
    siteTitle: 'Emmons for Congress | A New Voice',
    apiBaseUrl: 'https://api.electemmons.com/v1',
    theme: ThemeConfig(
      primaryColor: Color(0xFF0057),
      secondaryColor: Color(0xFF002147),
      fontFamily: 'Roboto',
      logoUrl: 'https://storage.googleapis.com/campaign-assets/emmons/logo.png',
    ),
    stripe: StripeConfig(
      publicKey: 'pk_test_emmons123',
      connectedAccountId: 'acct_emmons456',
    ),
    content: ContentConfig(
      heroTitle: 'Fighting for Our Future',
      heroSubtitle: 'Join the movement for change.',
      callToActionLabel: 'Donate Now',
    ),
    issues: [
      Issue(
        title: 'Affordable Healthcare',
        description: 'Healthcare is a right, not a privilege...',
        imageUrl: 'https://storage.googleapis.com/campaign-assets/emmons/healthcare.jpg',
      ),
      Issue(
        title: 'Education Reform',
        description: 'Investing in our schools is investing in our future...',
        imageUrl: 'https://storage.googleapis.com/campaign-assets/emmons/education.jpg',
      ),
    ],
    endorsements: [
      Endorsement(
        endorserName: 'The Daily Newspaper',
        quote: "'Emmons represents a fresh perspective we desperately need.'",
        logoUrl: 'https://storage.googleapis.com/campaign-assets/emmons/daily-logo.png',
      ),
    ],
  ),
  'blair': CampaignConfig(
    campaignId: 'blair-2024',
    domain: 'blairforbell.com',
    siteTitle: 'Blair for Bell County',
    apiBaseUrl: 'https://api.blairforbell.com/v1',
    theme: const ThemeConfig(
      primaryColor: Colors.blue,
      secondaryColor: Colors.grey,
      fontFamily: 'Lato',
      logoUrl: 'https://storage.googleapis.com/campaign-assets/blair/logo.png',
    ),
    stripe: const StripeConfig(
      publicKey: 'pk_test_blair123',
      connectedAccountId: 'acct_blair456',
    ),
    content: const ContentConfig(
      heroTitle: 'A Better Bell County',
      heroSubtitle: 'Proven Leadership. Real Results.',
      callToActionLabel: 'Get Involved',
    ),
    issues: [],
    endorsements: [],
  ),
  'cox': CampaignConfig(
    campaignId: 'cox-2024',
    domain: 'beaforjp.com',
    siteTitle: 'Bea for JP',
    apiBaseUrl: 'https://api.beaforjp.com/v1',
    theme: const ThemeConfig(
      primaryColor: Colors.red,
      secondaryColor: Colors.black,
      fontFamily: 'Montserrat',
      logoUrl: 'https://storage.googleapis.com/campaign-assets/cox/logo.png',
    ),
    stripe: const StripeConfig(
      publicKey: 'pk_test_cox123',
      connectedAccountId: 'acct_cox456',
    ),
    content: const ContentConfig(
      heroTitle: 'Justice and Fairness for All',
      heroSubtitle: 'Experience Matters.',
      callToActionLabel: 'Learn More',
    ),
    issues: [],
    endorsements: [],
  ),
  'tice': CampaignConfig(
    campaignId: 'tice-2024',
    domain: 'ticeforjp.com',
    siteTitle: 'Tice for JP',
    apiBaseUrl: 'https://api.ticeforjp.com/v1',
    theme: const ThemeConfig(
      primaryColor: Colors.green,
      secondaryColor: Colors.white,
      fontFamily: 'Oswald',
      logoUrl: 'https://storage.googleapis.com/campaign-assets/tice/logo.png',
    ),
    stripe: const StripeConfig(
      publicKey: 'pk_test_tice123',
      connectedAccountId: 'acct_tice456',
    ),
    content: const ContentConfig(
      heroTitle: 'A Voice for the People',
      heroSubtitle: 'Committed to Community.',
      callToActionLabel: 'Join Us',
    ),
    issues: [],
    endorsements: [],
  ),
  'tulloch': CampaignConfig(
    campaignId: 'tulloch-2024',
    domain: 'placeholder.com',
    siteTitle: 'Tulloch for Office',
    apiBaseUrl: 'https://api.placeholder.com/v1',
    theme: const ThemeConfig(
      primaryColor: Colors.purple,
      secondaryColor: Colors.yellow,
      fontFamily: 'Raleway',
      logoUrl: 'https://storage.googleapis.com/campaign-assets/tulloch/logo.png',
    ),
    stripe: const StripeConfig(
      publicKey: 'pk_test_tulloch123',
      connectedAccountId: 'acct_tulloch456',
    ),
    content: const ContentConfig(
      heroTitle: 'Placeholder Title',
      heroSubtitle: 'Placeholder Subtitle.',
      callToActionLabel: 'Placeholder',
    ),
    issues: [],
    endorsements: [],
  ),
  'mintz': CampaignConfig(
    campaignId: 'mintz-2024',
    domain: 'mintzforjudge.com',
    siteTitle: 'Mintz for Judge',
    apiBaseUrl: 'https://api.mintzforjudge.com/v1',
    theme: const ThemeConfig(
      primaryColor: Colors.indigo,
      secondaryColor: Colors.orange,
      fontFamily: 'Merriweather',
      logoUrl: 'https://storage.googleapis.com/campaign-assets/mintz/logo.png',
    ),
    stripe: const StripeConfig(
      publicKey: 'pk_test_mintz123',
      connectedAccountId: 'acct_mintz456',
    ),
    content: const ContentConfig(
      heroTitle: 'Integrity on the Bench',
      heroSubtitle: 'Fair, Firm, and Respectful.',
      callToActionLabel: 'Endorse',
    ),
    issues: [],
    endorsements: [],
  ),
  'luedeke': CampaignConfig(
    campaignId: 'luedeke-2024',
    domain: 'placeholder.com',
    siteTitle: 'Luedeke for Office',
    apiBaseUrl: 'https://api.placeholder.com/v1',
    theme: const ThemeConfig(
      primaryColor: Colors.teal,
      secondaryColor: Colors.pink,
      fontFamily: 'Playfair Display',
      logoUrl: 'https://storage.googleapis.com/campaign-assets/luedeke/logo.png',
    ),
    stripe: const StripeConfig(
      publicKey: 'pk_test_luedeke123',
      connectedAccountId: 'acct_luedeke456',
    ),
    content: const ContentConfig(
      heroTitle: 'Placeholder Title',
      heroSubtitle: 'Placeholder Subtitle.',
      callToActionLabel: 'Placeholder',
    ),
    issues: [],
    endorsements: [],
  ),
  'gauntt': CampaignConfig(
    campaignId: 'gauntt-2024',
    domain: 'johngaunttjr.com',
    siteTitle: 'John Gauntt Jr.',
    apiBaseUrl: 'https://api.johngaunttjr.com/v1',
    theme: const ThemeConfig(
      primaryColor: Colors.brown,
      secondaryColor: Colors.lightGreen,
      fontFamily: 'Source Sans Pro',
      logoUrl: 'https://storage.googleapis.com/campaign-assets/gauntt/logo.png',
    ),
    stripe: const StripeConfig(
      publicKey: 'pk_test_gauntt123',
      connectedAccountId: 'acct_gauntt456',
    ),
    content: const ContentConfig(
      heroTitle: 'Leadership You Can Trust',
      heroSubtitle: 'For a Stronger Tomorrow.',
      callToActionLabel: 'Contribute',
    ),
    issues: [],
    endorsements: [],
  ),
  'whitson': CampaignConfig(
    campaignId: 'whitson-2024',
    domain: 'placeholder.com',
    siteTitle: 'Whitson for Office',
    apiBaseUrl: 'https://api.placeholder.com/v1',
    theme: const ThemeConfig(
      primaryColor: Colors.cyan,
      secondaryColor: Colors.amber,
      fontFamily: 'Nunito',
      logoUrl: 'https://storage.googleapis.com/campaign-assets/whitson/logo.png',
    ),
    stripe: const StripeConfig(
      publicKey: 'pk_test_whitson123',
      connectedAccountId: 'acct_whitson456',
    ),
    content: const ContentConfig(
      heroTitle: 'Placeholder Title',
      heroSubtitle: 'Placeholder Subtitle.',
      callToActionLabel: 'Placeholder',
    ),
    issues: [],
    endorsements: [],
  ),
};
