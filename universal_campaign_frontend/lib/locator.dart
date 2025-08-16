import 'package:get_it/get_it.dart';
import 'package:universal_campaign_frontend/providers/campaign_provider.dart';
import 'package:universal_campaign_frontend/services/error_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => CampaignProvider());
  locator.registerLazySingleton(() => ErrorService());
}
