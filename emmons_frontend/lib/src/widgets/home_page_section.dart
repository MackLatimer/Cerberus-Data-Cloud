import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageSection extends StatelessWidget {
  final String title;
  final String summary;
  final String imagePath; // Placeholder for now, could be network or asset
  final String routePath;
  final Color imageBackgroundColor;

  const HomePageSection({
    super.key,
    required this.title,
    required this.summary,
    required this.imagePath, // In future, might be an ImageProvider
    required this.routePath,
    this.imageBackgroundColor = Colors.grey, // Default placeholder color
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Placeholder for an image
            Container(
              height: 150,
              color: imageBackgroundColor,
              child: Center(
                child: Icon(Icons.image, size: 50, color: Colors.white70), // Placeholder icon
                // child: Image.asset(imagePath, fit: BoxFit.cover), // If using local assets
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              summary,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
              ),
              onPressed: () {
                context.go(routePath);
              },
              child: Text('Learn More about $title'),
            ),
          ],
        ),
      ),
    );
  }
}
