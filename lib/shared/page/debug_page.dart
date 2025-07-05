import 'package:chat_app_user/config/app_config.dart';
import 'package:chat_app_user/config/flavor_config.dart';
import 'package:flutter/material.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    final environment = AppConfig.environment;

    return Scaffold(
      appBar: AppBar(title: const Text('Debug Tools')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard('Environment', FlavorConfig.name.toUpperCase()),
          _buildInfoCard('App Name', environment.appName),
          _buildInfoCard('Base URL', environment.baseUrl),
          _buildInfoCard('Socket URL', environment.socketUrl),
          _buildInfoCard('Bundle ID', environment.bundleId),
          _buildInfoCard('Logging', environment.enableLogging.toString()),
          _buildInfoCard('Log Level', environment.logLevel.toString()),
          _buildInfoCard(
            'Crashlytics',
            environment.enableCrashlytics.toString(),
          ),
          _buildInfoCard('Analytics', environment.enableAnalytics.toString()),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add debug actions here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Debug action executed')),
              );
            },
            child: const Text('Test Debug Action'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(child: ListTile(title: Text(title), subtitle: Text(value)));
  }
}
