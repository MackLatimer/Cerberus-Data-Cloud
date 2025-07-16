import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_section.dart';
import 'package:candidate_website/src/widgets/home_page_section.dart';
import 'package:candidate_website/src/widgets/footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: 'Curtis Emmons for Bell County Precinct 4',
        scrollController: _scrollController,
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Hero_Picture_Home.png'),
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
                'Welcome to the Campaign!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Join us in making a difference for Bell County Precinct 4. Curtis Emmons is dedicated to serving our community with integrity, transparency, and a commitment to progress.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              const HomePageSection(
                title: 'Issues',
                summary:
                    'Learn about the key issues Curtis is focused on to improve our precinct.',
                imagePath: 'assets/Summary_Picture_Issues.png',
                routePath: '/issues',
                imageBackgroundColor: Colors.blueGrey,
                imageLeft: true,
                backgroundColor: Color(0xffa01124),
                textColor: Colors.white,
                buttonColor: Colors.white,
                buttonTextColor: Color(0xff002663),
              ),
              const HomePageSection(
                title: 'About Me',
                summary:
                    'Discover more about Curtis Emmons, his background, and his vision for Bell County.',
                imagePath: 'assets/Summary_Picture_About.png',
                routePath: '/about',
                imageBackgroundColor: Colors.teal,
                imageLeft: false,
              ),
              const HomePageSection(
                title: 'Endorsements',
                summary:
                    'See who is endorsing Curtis and learn how you can add your support.',
                imagePath: 'assets/Summary_Picture_Endorsements.png',
                routePath: '/endorsements',
                imageBackgroundColor: Colors.amber,
                imageLeft: true,
                backgroundColor: Color(0xff002663),
                textColor: Colors.white,
                buttonColor: Colors.white,
                buttonTextColor: Color(0xffa01124),
              ),
              const HomePageSection(
                title: 'Donate',
                summary:
                    'Support the campaign financially and help us make a difference.',
                imagePath: 'assets/Summary_Picture_Donate.png',
                routePath: '/donate',
                imageBackgroundColor: Colors.green,
                imageLeft: false,
              ),
              const DonateSection(),
              const SignupFormWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
