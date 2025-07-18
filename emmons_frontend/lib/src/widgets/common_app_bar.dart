import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:candidate_website/src/utils/breakpoint.dart';

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
  CommonAppBarState createState() => CommonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(150);
}

class CommonAppBarState extends State<CommonAppBar> {
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (widget.scrollController != null) {
      setState(() {
        _scrollOffset = widget.scrollController!.offset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;
    final isMedium = windowSize == WindowSize.medium;

    // Navigation items
    final navItems = [
      {'label': 'Home', 'path': '/'},
      {'label': 'Issues', 'path': '/issues'},
      {'label': 'About', 'path': '/about'},
      {'label': 'Endorsements', 'path': '/endorsements'},
      {'label': 'Donate', 'path': '/donate'},
    ];

    double scrollThreshold = 200.0;
    double opacity = (_scrollOffset / scrollThreshold).clamp(0.0, 1.0);

    final navigation = Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((255.0 * (1.0 - opacity)).toInt()),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withAlpha((255.0 * (0.5 * (1.0 - opacity))).toInt()),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: navItems.map((item) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: isCompact ? 4.0 : 8.0),
            child: TextButton(
              onPressed: () => context.go(item['path']!),
              child: Text(
                item['label']!,
                style: textTheme.labelMedium?.copyWith(
                  color: const Color(0xff002663),
                  fontWeight: FontWeight.bold,
                  fontSize: isCompact ? 18 : 24,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );

    return AppBar(
      elevation: opacity,
      backgroundColor: Colors.white.withAlpha((255.0 * opacity).toInt()),
      title: null, // Set to null because we are using a custom layout
      automaticallyImplyLeading: false,
      flexibleSpace: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: isCompact || isMedium
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/Emmons_Logo_4_TP_Shadow.svg',
                      width: 200,
                      height: 100,
                    ),
                    const SizedBox(height: 16.0),
                    navigation,
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Logo on the left
                    SvgPicture.asset(
                      'assets/Emmons_Logo_4_TP_Shadow.svg',
                      width: 400,
                      height: 100,
                    ),
                    // Navigation items on the right
                    navigation,
                  ],
                ),
        ),
      ),
      actions: widget.actions,
    );
  }
}
