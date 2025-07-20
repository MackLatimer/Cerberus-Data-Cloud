import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/dynamic_size_app_bar.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_section.dart';
import 'package:candidate_website/src/widgets/footer.dart';
import 'package:candidate_website/src/utils/breakpoint.dart';

class IssuesPage extends StatefulWidget {
  const IssuesPage({super.key});

  @override
  _IssuesPageState createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildIssueSection(
    BuildContext context,
    String title,
    String content, {
    required String imagePath,
    Color? backgroundColor,
    Color? textColor,
    bool imageLeft = true,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;

    final imageWidget = Container(
      height: isCompact ? 200 : 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );

    final textWidget = Container(
      height: isCompact ? null : 400,
      color: backgroundColor,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold, color: textColor ?? Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style:
                textTheme.bodyLarge?.copyWith(color: textColor ?? Colors.black),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [imageWidget, textWidget],
      );
    }

    final imageExpanded = Expanded(child: imageWidget);
    final textExpanded = Expanded(child: textWidget);

    return SizedBox(
      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: imageLeft ? [imageExpanded, textExpanded] : [textExpanded, imageExpanded],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = getWindowSize(context);
    final isCompact = windowSize == WindowSize.compact;
    final heroHeight = isCompact ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DynamicSizeAppBar(
        child: CommonAppBar(
          title: 'Key Issues',
          scrollController: _scrollController,
        ),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: heroHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Hero_Picture_Issues.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 40),
              Text(
                'Issues',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildIssueSection(
                context,
                'Economic Growth & Job Creation',
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Curtis believes in fostering a business-friendly environment that attracts new opportunities and supports local entrepreneurs.',
                  imagePath: 'assets/Issues_Picture_1.png',
                backgroundColor: const Color(0xffa01124),
                textColor: Colors.white,
                imageLeft: true,
              ),
              _buildIssueSection(
                context,
                'Community Safety & Emergency Services',
                'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ensuring our neighborhoods are safe and our first responders are well-equipped is a top priority.',
                  imagePath: 'assets/Issues_Picture_2.png',
                imageLeft: false,
              ),
              _buildIssueSection(
                context,
                'Infrastructure Development & Maintenance',
                'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. We must invest in maintaining and improving our roads, bridges, and public utilities to support our growing community.',
                  imagePath: 'assets/Issues_Picture_3.png',
                backgroundColor: const Color(0xff002663),
                textColor: Colors.white,
                imageLeft: true,
              ),
              _buildIssueSection(
                context,
                'Fiscal Responsibility & Transparent Governance',
                'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Curtis is committed to responsible spending of taxpayer dollars and ensuring all county operations are transparent and accountable to the public.',
                  imagePath: 'assets/Issues_Picture_4.png',
                imageLeft: false,
              ),
              const DonateSection(),
              const SignupFormWidget(),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
