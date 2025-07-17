import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_section.dart';
import 'package:candidate_website/src/widgets/footer.dart'; // Import the Footer widget

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: 'About Me', // Changed title
        scrollController: _scrollController,
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height, // Height of the hero image
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Hero_Picture_About.png'),
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'About Me', // Changed text here
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/About_Picture_Business.png', width: 200, height: 200),
                            Image.asset('assets/About_Picture_Self.png', width: 200, height: 200),
                            Image.asset('assets/Summary_Picture_About.png', width: 200, height: 200),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
