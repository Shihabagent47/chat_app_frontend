import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});
  @override
  Widget build(BuildContext context) {
    return Text(
      'ChatApp',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }
}
