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
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 4.95);
}

class _CommonAppBarState extends State<CommonAppBar> {
  double _appBarOpacity = 1.0; // Default to opaque

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      // If there's a scroll controller, start transparent for overlap effect
      _appBarOpacity = 0.0;
      widget.scrollController!.addListener(_updateAppBarOpacity);
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateAppBarOpacity());
    }
    // If no scrollController is provided, _appBarOpacity remains 1.0 (opaque)
  }

  @override
  void dispose() {
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_updateAppBarOpacity);
    }
    super.dispose();
  }

  void _updateAppBarOpacity() {
    if (widget.scrollController != null && widget.scrollController!.hasClients) {
      final offset = widget.scrollController!.offset;
      // AppBar starts fully transparent.
      // Start fading in after scrolling past a small threshold (e.g., 10 pixels).
      // Becomes fully opaque after scrolling a certain distance (e.g., 200 pixels).
      const startFadeOffset = 10.0;
      const endFadeOffset = 200.0;

      double opacity;
      if (offset <= startFadeOffset) {
        opacity = 0.0; // Stay transparent if below or at startFadeOffset
      } else if (offset >= endFadeOffset) {
        opacity = 1.0; // Fully opaque if at or past endFadeOffset
      } else {
        // Calculate opacity during the transition
        opacity = (offset - startFadeOffset) / (endFadeOffset - startFadeOffset);
      }

      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          _appBarOpacity = opacity.clamp(0.0, 1.0);
        });
      }
    } else if (widget.scrollController == null) {
      // If no scroll controller, keep it transparent.
      // This could be adjusted if a different default is needed for non-scrolling pages.
      if (mounted && _appBarOpacity != 0.0) {
         // setState(() { _appBarOpacity = 0.0; }); // Or 1.0 if opaque is default
      }
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
        padding: const EdgeInsets.all(4.0), // Reduced padding to allow more space for the logo
        child: Builder(
          builder: (context) {
            return SizedBox(
              height: 100,
              width: 400,
              child: SvgPicture.asset(
                'assets/Emmons_Logo_4_TP.svg',
                semanticsLabel: 'Curtis Emmons for Bell County Commissioner Precinct 4 Logo',
                fit: BoxFit.contain,
              ),
            );
          }
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
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 4.95);
}
