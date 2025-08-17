import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/models/campaign_config.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  final CampaignConfig config;
  const Footer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Container(
        color: colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (config.content.footer.facebookLink != null)
                  _SocialMediaIcon(
                    iconPath: 'assets/icons/facebook_white.png',
                    onTap: () => _launchURL(config.content.footer.facebookLink!),
                  ),
                if (config.content.footer.instagramLink != null)
                  _SocialMediaIcon(
                    iconPath: 'assets/icons/instagram_white.png',
                    onTap: () => _launchURL(config.content.footer.instagramLink!),
                  ),
                if (config.content.footer.xLink != null)
                  _SocialMediaIcon(
                    iconPath: 'assets/icons/x_white.png',
                    onTap: () => _launchURL(config.content.footer.xLink!),
                  ),
                if (config.content.footer.linkedinLink != null)
                  _SocialMediaIcon(
                    iconPath: 'assets/icons/linkedin_white.png',
                    onTap: () => _launchURL(config.content.footer.linkedinLink!),
                  ),
                if (config.content.footer.youtubeLink != null)
                  _SocialMediaIcon(
                    iconPath: 'assets/icons/youtube_white.png',
                    onTap: () => _launchURL(config.content.footer.youtubeLink!),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              config.content.footer.paidForText,
              style: textTheme.bodyMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}

class _SocialMediaIcon extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const _SocialMediaIcon({
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Image.asset(
          iconPath,
          width: 30,
          height: 30,
          color: Colors.white, // Ensure icons are white
        ),
      ),
    );
  }
}
