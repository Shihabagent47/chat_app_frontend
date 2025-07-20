import 'package:chat_app_user/features/user/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class UserDetailsContent extends StatelessWidget {
  final UserEntity user;

  const UserDetailsContent({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Text(
                    user.firstName.isNotEmpty
                        ? user.firstName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.firstName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '@${user.firstName}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Contact Information
          _buildSectionTitle(context, 'Contact Information'),
          _buildInfoCard(context, [
            _buildInfoRow(Icons.email, 'Email', user.email),
            _buildInfoRow(Icons.phone, 'Phone', user.phone),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
