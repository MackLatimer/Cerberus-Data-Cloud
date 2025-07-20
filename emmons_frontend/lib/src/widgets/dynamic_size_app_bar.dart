import 'package:flutter/material.dart';
import 'package:candidate_website/src/utils/breakpoint.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';

class DynamicSizeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CommonAppBar child;

  const DynamicSizeAppBar({super.key, required this.child});

  @override
  Size get preferredSize {
    // This is a bit of a hack, as we can't get the context here.
    // We'll create a temporary context to get the window size.
    final window = WidgetsBinding.instance.window;
    final mediaQueryData = MediaQueryData.fromWindow(window);
    final width = mediaQueryData.size.width;

    if (width < 600) {
      return const Size.fromHeight(306);
    } else if (width < 1000) {
      return const Size.fromHeight(266);
    } else {
      return const Size.fromHeight(206);
    }
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
