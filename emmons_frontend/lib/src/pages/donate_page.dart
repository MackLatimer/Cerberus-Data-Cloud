import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/dynamic_size_app_bar.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/network/stripe_service.dart';
import 'package:candidate_website/src/widgets/donation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:candidate_website/src/widgets/footer.dart'; // Import the Footer widget
import 'package:candidate_website/src/config.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  DonatePageState createState() => DonatePageState();
}

class DonatePageState extends State<DonatePage> {
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
            title: 'Donate to the Campaign',
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
                    image: AssetImage('assets/Hero_Picture_Donate.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600), // Slightly narrower for focus
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 40),
                        Text(
                          'Support our Mission!',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        const DonationWidget(),
                        const SizedBox(height: 40),
                        Text(
                          'If you prefer to donate by mail, please send a check payable to "Curtis Emmons Campaign" to: [Campaign PO Box or Address Here - Placeholder]',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Thank you for your generosity!',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Footer(),
            ],
          ),
        ),
      ),
      );
    });
  }
}
