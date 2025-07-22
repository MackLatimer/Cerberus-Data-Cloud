import 'package:flutter/material.dart';
import 'package:shared_ui/src/utils/breakpoint.dart';

class HighProfileEndorsementCard extends StatelessWidget {
  final String name;
  final String quote;
  final String imagePath;
  final bool imageLeft;
  final Color? backgroundColor;
  final Color? textColor;

  const HighProfileEndorsementCard({
    super.key,
    required this.name,
    required this.quote,
    required this.imagePath,
    this.imageLeft = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;

    final imageWidget = Container(
      height: isCompact ? 200 : 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );

    final textWidget = Container(
      height: isCompact ? null : 400,
      padding: const EdgeInsets.all(16.0),
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '"$quote"',
            style: textTheme.titleLarge
                ?.copyWith(fontStyle: FontStyle.italic, color: textColor),
          ),
          const SizedBox(height: 8.0),
          Text(
            '- $name',
            style: textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );

    if (isCompact) {
      return Card(
        margin: EdgeInsets.zero,
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [imageWidget, textWidget],
        ),
      );
    }

    final imageExpanded = Expanded(child: imageWidget);
    final textExpanded = Expanded(child: textWidget);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 4.0,
      child: SizedBox(
        height: 400,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              imageLeft ? [imageExpanded, textExpanded] : [textExpanded, imageExpanded],
        ),
      ),
    );
  }
}
