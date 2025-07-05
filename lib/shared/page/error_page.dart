import 'package:chat_app_user/config/app_config.dart';
import 'package:chat_app_user/config/flavor_config.dart';
import 'package:chat_app_user/core/routing/navigation_helper.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final Exception? error;
  final bool showDebugInfo;

  const ErrorPage({super.key, this.error, this.showDebugInfo = false});

  @override
  Widget build(BuildContext context) {
    final environment = AppConfig.environment;

    return Scaffold(
      appBar: AppBar(title: Text('Error - ${environment.appName}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Something went wrong!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (showDebugInfo && error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug Info:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Environment: ${FlavorConfig.name}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Error: ${error.toString()}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => NavigationHelper.goToDashboard(context),
              child: const Text('Go to Dashboard'),
            ),
            if (FlavorConfig.isDevelopment) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => NavigationHelper.goToDebug(context),
                child: const Text('Debug Tools'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
