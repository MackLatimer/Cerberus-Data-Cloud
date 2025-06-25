import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Navigation items
    final navItems = [
      {'label': 'Home', 'path': '/'},
      {'label': 'Issues', 'path': '/issues'},
      {'label': 'About', 'path': '/about'},
      {'label': 'Endorsements', 'path': '/endorsements'},
      {'label': 'Donate', 'path': '/donate'},
    ];

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('CurtisEmmonsRepublicanPrimarySquare.png'), // Logo
      ),
      title: Text(title, style: textTheme.titleLarge?.copyWith(color: Colors.white)),
      automaticallyImplyLeading: false, // No back button for top-level pages
      actions: <Widget>[
        // Spread the navigation items as TextButtons
        ...navItems.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {
                context.go(item['path']!);
              },
              child: Text(
                item['label']!,
                style: textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
        // Allow for additional actions to be passed if needed
        if (actions != null) ...actions!,
        const SizedBox(width: 16), // Add some spacing at the end
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
