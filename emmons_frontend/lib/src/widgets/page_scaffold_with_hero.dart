import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/utils/breakpoint.dart';

class PageScaffoldWithHero extends StatefulWidget {
  final String pageTitle;
  final String heroImagePath;
  final Widget body;

  const PageScaffoldWithHero({
    super.key,
    required this.pageTitle,
    required this.heroImagePath,
    required this.body,
  });

  @override
  State<PageScaffoldWithHero> createState() => _PageScaffoldWithHeroState();
}

class _PageScaffoldWithHeroState extends State<PageScaffoldWithHero> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;
    final heroHeight = isCompact ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: widget.pageTitle,
        scrollController: _scrollController,
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: heroHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.heroImagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: widget.body,
      ),
    );
  }
}