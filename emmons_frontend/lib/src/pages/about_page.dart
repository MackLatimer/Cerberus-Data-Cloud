import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/dynamic_size_app_bar.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_section.dart';
import 'package:candidate_website/src/widgets/footer.dart'; // Import the Footer widget

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      double appBarHeight;

      // extended
      if (width > 1000) {
        appBarHeight = 156;
        // medium
      } else if (width > 600) {
        appBarHeight = 216;
        // compact
      } else {
        appBarHeight = 256;
      }
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: DynamicSizeAppBar(
          height: appBarHeight,
          child: CommonAppBar(
            title: 'About Curtis Emmons',
            scrollController: _scrollController,
          ),
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
                    image: AssetImage('images/Emmons_About_Hero.png'),
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
                          'Curtis Emmons is a dedicated public servant with a passion for community development and effective governance. With a background in business and a commitment to fiscal responsibility, Curtis brings a wealth of experience to the table. He is a strong advocate for transparency and accountability in government, and he is committed to working collaboratively to find solutions to the challenges facing our county.\n\nThroughout his career, Curtis has been actively involved in numerous local initiatives, from supporting small businesses to improving public infrastructure. He believes in a common-sense approach to problem-solving and is dedicated to ensuring that the voices of all residents are heard. His vision for the county is one of smart growth, economic prosperity, and a high quality of life for all.\n\nAs a husband and father, Curtis understands the importance of building a strong and vibrant community for future generations. He is a firm believer in the power of collaboration and is committed to working with residents, business leaders, and community organizations to create a better future for our county.',
                          style: TextStyle(fontSize: 18, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset('images/Emmons_About_Bio1.png', fit: BoxFit.cover)),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset('images/Emmons_About_Bio2.png', fit: BoxFit.cover)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset('images/Emmons_About_Bio3.png', height: 200, fit: BoxFit.cover)),
                          ),
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
    });
  }
}
