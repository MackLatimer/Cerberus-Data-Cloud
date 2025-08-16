import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_campaign_frontend/utils/breakpoint.dart';

class HomePageSection extends StatelessWidget {
  final String title;
  final String summary;
  final String imagePath;
  final String routePath;
  final Color imageBackgroundColor;
  final bool imageLeft;
  final Color? textColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final Color? backgroundColor;

  const HomePageSection({
    super.key,
    required this.title,
    required this.summary,
    required this.imagePath,
    required this.routePath,
    this.imageBackgroundColor = Colors.grey,
    this.imageLeft = true,
    this.textColor,
    this.buttonColor,
    this.buttonTextColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final imageWidget = Container(
      height: isCompact ? 200 : 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath.isNotEmpty ? imagePath : 'assets/images/error_placeholder.png'),
          fit: BoxFit.cover,
        ),
      ),
    );

    final textWidget = Container(
      height: isCompact ? null : 400,
      color: backgroundColor,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            summary,
            style: textTheme.bodyMedium?.copyWith(color: textColor ?? Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor ?? colorScheme.secondary,
              foregroundColor: buttonTextColor ?? colorScheme.onSecondary,
            ),
            onPressed: () {
              context.go(routePath);
            },
            child: Text('Learn More about $title'),
          ),
        ],
      ),
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [imageWidget, textWidget],
      );
    }

    final imageExpanded = Expanded(child: imageWidget);
    final textExpanded = Expanded(child: textWidget);

    return SizedBox(
      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: imageLeft ? [imageExpanded, textExpanded] : [textExpanded, imageExpanded],
      ),
    );
  }
}
