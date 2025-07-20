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
  _CommonAppBarState createState() => _CommonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(206);
}

class _CommonAppBarState extends State<CommonAppBar> {
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
      width: isMedium ? 584 : null,
      padding: windowSize == WindowSize.expanded
          ? const EdgeInsets.symmetric(horizontal: 24.0)
          : const EdgeInsets.symmetric(horizontal: 8.0),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1.0 - opacity),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5 * (1.0 - opacity)),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: navItems.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () => context.go(item['path']!),
              child: Text(
                item['label']!,
                style: textTheme.labelMedium?.copyWith(
                  color: const Color(0xff002663),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );

    final navItemsRow1 = navItems.sublist(0, 3);
    final navItemsRow2 = navItems.sublist(3, 5);

    final compactNavigation = Container(
      height: 100,
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1.0 - opacity),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5 * (1.0 - opacity)),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: navItemsRow1.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () => context.go(item['path']!),
                  child: Text(
                    item['label']!,
                    style: textTheme.labelMedium?.copyWith(
                      color: const Color(0xff002663),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: navItemsRow2.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () => context.go(item['path']!),
                  child: Text(
                    item['label']!,
                    style: textTheme.labelMedium?.copyWith(
                      color: const Color(0xff002663),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;
        final appBarHeight = isCompact ? 366.0 : 206.0;

        return AppBar(
          elevation: opacity,
          backgroundColor: Colors.white.withOpacity(opacity),
          title: null, // Set to null because we are using a custom layout
          automaticallyImplyLeading: false,
          toolbarHeight: appBarHeight,
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
                        if (isCompact)
                          compactNavigation
                        else
                          navigation, // original navigation for medium
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
      },
    );
  }
}
