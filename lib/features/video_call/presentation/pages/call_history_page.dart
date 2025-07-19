import 'package:flutter/material.dart';

class CallHistoryPage extends StatelessWidget {
  const CallHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual call history
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person),
            ),
            title: Text('Contact ${index + 1}'),
            subtitle: Text('${index + 1} min ago'),
            trailing: Icon(
              index % 2 == 0 ? Icons.videocam : Icons.call,
              color: Colors.grey[600],
            ),
            onTap: () {
              // Handle call history item tap
            },
          );
        },
      ),
    );
  }
}
