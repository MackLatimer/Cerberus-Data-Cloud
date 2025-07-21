import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';

class DynamicSizeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CommonAppBar child;

  const DynamicSizeAppBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        double height;

        // extended
        if (width > 1000) {
          height = 206;
        // medium
        } else if (width > 600) {
          height = 266;
        // compact
        } else {
          height = 306;
        }

        return SizedBox(
          height: height,
          child: child,
        );
      },
    );
  }

  @override
  Size get preferredSize {
    // This is a bit of a hack. We need to get the width of the screen to determine the height of the app bar.
    // We can't use MediaQuery here because this is not a widget.
    // So we just return a size with a placeholder height and let the build method figure out the real height.
    // The build method will then use a PreferredSize widget to set the correct height.
    // This is not ideal, but it works.
    // The alternative is to use a LayoutBuilder in the parent widget, but that would require a lot of refactoring.
    // TODO: Find a better way to do this.
    return const Size.fromHeight(1000);
  }
}
