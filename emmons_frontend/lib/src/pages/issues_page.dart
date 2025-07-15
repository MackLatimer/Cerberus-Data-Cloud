import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_section.dart';
import 'package:candidate_website/src/widgets/footer.dart';

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
    Color imagePlaceholderColor = Colors.blueGrey,
    bool imageLeft = true,
  }) {
    final textTheme = Theme.of(context).textTheme;

    final imageWidget = Expanded(
      child: Container(
        height: 300,
        color: imagePlaceholderColor,
        child: Center(
          child: Icon(Icons.image, size: 60, color: Colors.white.withOpacity(0.7)),
        ),
      ),
    );

    final textWidget = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: imageLeft ? [imageWidget, textWidget] : [textWidget, imageWidget],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: 'Issues',
        scrollController: _scrollController,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'Hero Image: Issues',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    Text(
                      'Issues',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _buildIssueSection(
                      context,
                      'Economic Growth & Job Creation',
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Curtis believes in fostering a business-friendly environment that attracts new opportunities and supports local entrepreneurs.',
                      imagePlaceholderColor: Colors.teal,
                      imageLeft: true,
                    ),
                    _buildIssueSection(
                      context,
                      'Community Safety & Emergency Services',
                      'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ensuring our neighborhoods are safe and our first responders are well-equipped is a top priority.',
                      imagePlaceholderColor: Colors.orange,
                      imageLeft: false,
                    ),
                    _buildIssueSection(
                      context,
                      'Infrastructure Development & Maintenance',
                      'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. We must invest in maintaining and improving our roads, bridges, and public utilities to support our growing community.',
                      imagePlaceholderColor: Colors.indigo,
                      imageLeft: true,
                    ),
                    _buildIssueSection(
                      context,
                      'Fiscal Responsibility & Transparent Governance',
                      'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Curtis is committed to responsible spending of taxpayer dollars and ensuring all county operations are transparent and accountable to the public.',
                      imagePlaceholderColor: Colors.brown,
                      imageLeft: false,
                    ),
                    const SizedBox(height: 40),
                    const DonateSection(),
                    const SizedBox(height: 40),
                    const SignupFormWidget(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}
