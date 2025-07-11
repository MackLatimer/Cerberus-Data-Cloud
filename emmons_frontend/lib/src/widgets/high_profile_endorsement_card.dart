import 'package:flutter/material.dart';

class HighProfileEndorsementCard extends StatelessWidget {
  final String name;
  final String quote;
  final String imagePath; // Placeholder for now
  final Color imageBackgroundColor;

  const HighProfileEndorsementCard({
    super.key,
    required this.name,
    required this.quote,
    required this.imagePath,
    this.imageBackgroundColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: imageBackgroundColor,
                shape: BoxShape.circle,
                // image: DecorationImage(
                //   image: AssetImage(imagePath), // Or NetworkImage
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Icon(Icons.person, size: 60, color: Colors.white.withOpacity(0.8)), // Placeholder
            ),
            const SizedBox(height: 16),
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
  }
}
