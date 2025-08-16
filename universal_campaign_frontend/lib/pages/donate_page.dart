import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_campaign_frontend/providers/campaign_provider.dart';
import 'package:universal_campaign_frontend/widgets/common_app_bar.dart';
import 'package:universal_campaign_frontend/widgets/footer.dart';
import 'package:universal_campaign_frontend/widgets/donation_widget.dart';


class DonatePage extends StatelessWidget {
  const DonatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<CampaignProvider>(context).campaignConfig!;
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        config: config,
        scrollController: scrollController,
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(config.assets.donatePage.heroImagePath.isNotEmpty ? config.assets.donatePage.heroImagePath : 'assets/images/error_placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
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
                          config.content.donatePage.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        DonationWidget(config: config),
                        const SizedBox(height: 40),
                        Text(
                          config.content.donatePage.mailDonationText,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          config.content.donatePage.thankYouText,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Footer(config: config),
            ]),
          ),
        ],
      ),
    );
  }
}
