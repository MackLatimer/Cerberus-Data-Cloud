import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emmons_frontend/main.dart'; // For campaignProvider
import 'package:emmons_frontend/ui/core_widgets/widgets/dynamic_size_app_bar.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/common_app_bar.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/footer.dart';
import 'package:emmons_frontend/ui/core_widgets/widgets/donation_widget.dart';

class DonatePage extends ConsumerStatefulWidget {
  const DonatePage({super.key});

  @override
  DonatePageState createState() => DonatePageState();
}

class DonatePageState extends ConsumerState<DonatePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaignConfig = ref.watch(campaignProvider);

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      double appBarHeight;

      if (width > 1000) {
        appBarHeight = 156;
      } else if (width > 600) {
        appBarHeight = 216;
      } else {
        appBarHeight = 256;
      }
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: DynamicSizeAppBar(
          height: appBarHeight,
          child: CommonAppBar(
            title: campaignConfig.content.donatePageTitle,
            scrollController: _scrollController,
          ),
        ),
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(campaignConfig.content.donatePageHeroImagePath),
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
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: 40),
                          Text(
                            campaignConfig.content.donatePageSubtitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          const DonationWidget(),
                          const SizedBox(height: 40),
                          Text(
                            campaignConfig.content.donatePageMailInstructions,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            campaignConfig.content.donatePageThankYouText,
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