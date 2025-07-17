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
  Size get preferredSize => const Size.fromHeight(150);
}

class _CommonAppBarState extends State<CommonAppBar> {

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
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: null, // Set to null because we are using a custom layout
      automaticallyImplyLeading: false,
      flexibleSpace: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Logo on the left
              SvgPicture.asset(
                'assets/Emmons_Logo_4_TP.svg',
                width: 400,
                height: 100,
              ),
              // Navigation items on the right
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
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
              ),
            ],
          ),
        ),
      ),
      actions: widget.actions,
    );
  }
}
