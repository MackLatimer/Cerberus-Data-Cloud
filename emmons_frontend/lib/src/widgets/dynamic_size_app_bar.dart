import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';

class DynamicSizeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CommonAppBar child;

  const DynamicSizeAppBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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

    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: child,
    );
  }
}
