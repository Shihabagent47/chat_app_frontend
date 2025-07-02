enum Flavor { development, staging, production }

class FlavorConfig {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static bool get isDevelopment => appFlavor == Flavor.development;
  static bool get isStaging => appFlavor == Flavor.staging;
  static bool get isProduction => appFlavor == Flavor.production;
}
