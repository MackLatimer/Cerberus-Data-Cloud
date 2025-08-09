import 'package:flutter/material.dart';
import 'package:emmons_frontend/src/widgets/common_app_bar.dart';

class DynamicSizeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CommonAppBar child;
  final double height;

  const DynamicSizeAppBar({super.key, required this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: child,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
