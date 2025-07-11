import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final ScrollController? scrollController;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.scrollController,
  });

  @override
  _CommonAppBarState createState() => _CommonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CommonAppBarState extends State<CommonAppBar> {
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_updateAppBarOpacity);
    }
  }

  @override
  void dispose() {
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_updateAppBarOpacity);
    }
    super.dispose();
  }

  void _updateAppBarOpacity() {
    if (widget.scrollController!.hasClients) {
      final offset = widget.scrollController!.offset;
      // Start fading in after scrolling 50 pixels, fully opaque by 200 pixels
      const startFadeOffset = 50.0;
      const endFadeOffset = 200.0;
      double opacity = 0.0;
      if (offset > startFadeOffset) {
        opacity = (offset - startFadeOffset) / (endFadeOffset - startFadeOffset);
      }
      setState(() {
        _appBarOpacity = opacity.clamp(0.0, 1.0);
      });
    }
  }

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
      backgroundColor: colorScheme.primary.withOpacity(_appBarOpacity),
      elevation: _appBarOpacity > 0 ? 4.0 : 0.0, // Add shadow when not transparent
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          'assets/Emmons_Logo_4_TP.svg',
          semanticsLabel: 'Curtis Emmons for Bell County Commissioner Precinct 4 Logo',
          fit: BoxFit.contain,
        ),
      ),
      title: null, // Removed title
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
        if (widget.actions != null) ...widget.actions!, // Changed to widget.actions
        const SizedBox(width: 16), // Add some spacing at the end
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
