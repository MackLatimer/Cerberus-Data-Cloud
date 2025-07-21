import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';

class DynamicSizeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CommonAppBar child;

  const DynamicSizeAppBar({super.key, required this.child});

  @override
  Size get preferredSize => const Size.fromHeight(306); // Max height as a fallback.

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double height;

    if (width < 600) {
      height = 306;
    } else if (width < 1000) {
      height = 266;
    } else {
      height = 206;
    }

    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: child,
    );
  }
}
