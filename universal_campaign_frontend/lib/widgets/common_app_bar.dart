import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_campaign_frontend/src/models/campaign_config.dart';

import 'package:universal_campaign_frontend/src/utils/breakpoint.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final CampaignConfig config;
  final List<Widget>? actions;
  final ScrollController? scrollController;

  const CommonAppBar({
    super.key,
    required this.config,
    this.actions,
    this.scrollController,
  });

  @override
  CommonAppBarState createState() => CommonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
    final isMedium = windowSize == WindowSize.medium;

    final navItems = widget.config.content.commonAppBar.navItems;

    double scrollThreshold = 200.0;
    double opacity = (_scrollOffset / scrollThreshold).clamp(0.0, 1.0);

    final navigation = Container(
      width: isMedium ? 584 : null,
      padding: windowSize == WindowSize.expanded
          ? const EdgeInsets.symmetric(horizontal: 24.0)
          : const EdgeInsets.symmetric(horizontal: 8.0),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((255 * (1.0 - opacity)).toInt()),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.5 * (1.0 - opacity)).toInt()),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 3),
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
              onPressed: () => context.go(item.path),
              child: Text(
                item.label,
                style: textTheme.labelMedium?.copyWith(
                  color: Color(int.parse(widget.config.theme.primaryColor.substring(1, 7), radix: 16) + 0xFF000000),
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
        color: Colors.white.withAlpha((255 * (1.0 - opacity)).toInt()),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.5 * (1.0 - opacity)).toInt()),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 3),
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
                  onPressed: () => context.go(item.path),
                  child: Text(
                    item.label,
                    style: textTheme.labelMedium?.copyWith(
                      color: Color(int.parse(widget.config.theme.primaryColor.substring(1, 7), radix: 16) + 0xFF000000),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Row(
            mainAxisSize: MainAxisSize.AxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: navItemsRow2.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () => context.go(item.path),
                  child: Text(
                    item.label,
                    style: textTheme.labelMedium?.copyWith(
                      color: Color(int.parse(widget.config.theme.primaryColor.substring(1, 7), radix: 16) + 0xFF000000),
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
        final isMedium = constraints.maxWidth < 1000;

        return AppBar(
          elevation: opacity,
          backgroundColor: Colors.white.withAlpha((255 * opacity).toInt()),
          title: null,
          automaticallyImplyLeading: false,
          flexibleSpace: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: isCompact || isMedium
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          widget.config.assets.logoPath,
                          width: widget.config.assets.commonAppBar.logoWidth,
                          height: widget.config.assets.commonAppBar.logoHeight,
                        ),
                        const SizedBox(height: 16.0),
                        if (isCompact)
                          compactNavigation
                        else
                          navigation,
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image.asset(
                          widget.config.assets.homePage.logoPath,
                          width: widget.config.assets.commonAppBar.logoWidth,
                          height: widget.config.assets.commonAppBar.logoHeight,
                        ),
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
