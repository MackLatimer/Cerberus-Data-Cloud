import 'package:flutter/material.dart';
import 'package:universal_campaign_frontend/config/campaign_config.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  final CampaignConfig config;

  const ErrorPage({super.key, required this.errorMessage, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(config.content.errorPage.appBarTitle),
        ),
        body: Center(
          child: Text('${config.content.errorPage.errorMessagePrefix}$errorMessage'),
        ),
      ),
    );
  }
}