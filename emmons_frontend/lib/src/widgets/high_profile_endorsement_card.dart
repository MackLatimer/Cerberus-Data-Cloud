import 'package:flutter/material.dart';

class HighProfileEndorsementCard extends StatelessWidget {
  final String name;
  final String quote;
  final String imagePath;
  final Color imageBackgroundColor;
  final bool imageLeft;

  const HighProfileEndorsementCard({
    super.key,
    required this.name,
    required this.quote,
    required this.imagePath,
    this.imageBackgroundColor = Colors.grey,
    this.imageLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final imageWidget = Expanded(
      child: Container(
        height: 300,
        color: imageBackgroundColor,
        child: Center(
          child: Icon(Icons.person, size: 60, color: Colors.white.withOpacity(0.8)),
        ),
      ),
    );

    final textWidget = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              name,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '"${quote}"',
              style: textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: imageLeft ? [imageWidget, textWidget] : [textWidget, imageWidget],
      ),
    );
  }
}
