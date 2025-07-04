import 'package:chat_app_user/config/environments/staging.dart';
import 'package:chat_app_user/core/app/app_runner.dart';
import 'package:chat_app_user/config/flavor_config.dart';

void main() async {
  await AppRunner.run(StagingEnvironment(), Flavor.staging);
}
