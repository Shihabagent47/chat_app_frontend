import 'package:chat_app_user/config/environments/development.dart';
import 'package:chat_app_user/core/app/app_runner.dart';
import 'package:chat_app_user/config/flavor_config.dart';

void main() async {
  await AppRunner.run(DevelopmentEnvironment(), Flavor.development);
}
