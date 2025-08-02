import 'package:flutter/material.dart';
import 'package:emmons_frontend/src/widgets/dynamic_size_app_bar.dart';
import 'package:emmons_frontend/src/widgets/common_app_bar.dart';
import 'package:emmons_frontend/src/widgets/signup_form.dart';
import 'package:emmons_frontend/src/widgets/donate_section.dart';
import 'package:emmons_frontend/src/widgets/high_profile_endorsement_card.dart';
import 'package:emmons_frontend/src/widgets/footer.dart';
import 'package:emmons_frontend/src/utils/breakpoint.dart';

class EndorsementsPage extends StatefulWidget {
  const EndorsementsPage({super.key});

  @override
  EndorsementsPageState createState() => EndorsementsPageState();
}

class EndorsementsPageState extends State<EndorsementsPage> {
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
            title: 'Endorsements',
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
                    image: AssetImage('images/Emmons_Endorsements_Hero.png'),
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
                'Endorsements',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                'Distinguished Supporters',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const HighProfileEndorsementCard(
                name: 'Jane Doe',
                quote:
                    'Curtis has the vision and dedication Bell County needs. He has my full support!',
                imagePath: 'images/Emmons_Endorsements_Issue1.png',
                backgroundColor: Color(0xffa01124),
                textColor: Colors.white,
                imageLeft: true,
              ),
              const HighProfileEndorsementCard(
                name: 'John Smith',
                quote:
                    'I\'ve worked with Curtis for years, and his commitment to our community is unwavering.',
                imagePath: 'images/Emmons_Endorsements_Issue2.png',
                imageLeft: false,
              ),
              const HighProfileEndorsementCard(
                name: 'Bob Johnson',
                quote: 'A true leader for our time.',
                imagePath: 'images/Emmons_Endorsements_Issue3.png',
                backgroundColor: Color(0xff002663),
                textColor: Colors.white,
                imageLeft: true,
              ),
              const HighProfileEndorsementCard(
                name: 'Susan Williams',
                quote: 'The best choice for Bell County.',
                imagePath: 'images/Emmons_Endorsements_Issue4.png',
                imageLeft: false,
              ),
              const HighProfileEndorsementCard(
                name: 'Michael Brown',
                quote: 'He will get the job done.',
                imagePath: 'images/Endorsement_Picture_5.png',
                backgroundColor: Color(0xffa01124),
                textColor: Colors.white,
                imageLeft: true,
              ),
              const SizedBox(height: 40),
              Text(
                'Community Endorsers',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildEndorserList(context, [
                'Michael Brown',
                'Emily Davis',
                'David Wilson',
                'Sarah Miller',
                'Robert Garcia',
                'Linda Rodriguez',
                'James Martinez',
                'Patricia Hernandez',
                'Christopher Lee',
                'Jessica Gonzalez',
                'Daniel Walker',
                'Karen Hall',
              ]),
              const SizedBox(height: 40),
              Text(
                'Add Your Voice!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Show your support for Curtis Emmons by providing your endorsement. Your voice matters!',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const DonateSection(),
              const SizedBox(height: 40),
              const SignupFormWidget(),
              const SizedBox(height: 40),
              const Footer(),
            ],
          ),
        ),
      ),
      );
    });
  }

  Widget _buildEndorserList(BuildContext context, List<String> endorsers) {
    final textTheme = Theme.of(context).textTheme;
    if (endorsers.isEmpty) {
      return Text(
        'More endorsements coming soon!',
        style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
        textAlign: TextAlign.center,
      );
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      alignment: WrapAlignment.center,
      children: endorsers.map((name) {
        return Chip(label: Text(name));
      }).toList(),
    );
  }
}
