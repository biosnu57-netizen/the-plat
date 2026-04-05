import 'package:flutter/material.dart';

class ExternalLinksScreen extends StatelessWidget {
  const ExternalLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final platforms = [
      {
        'name': 'PlayStation Network',
        'icon': '🎮',
        'color': Colors.blue,
        'username': 'Not linked',
      },
      {
        'name': 'Xbox',
        'icon': '🎯',
        'color': Colors.green,
        'username': 'Not linked',
      },
      {
        'name': 'Steam',
        'icon': '💨',
        'color': Colors.grey,
        'username': 'Not linked',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('External Links', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.link, size: 48, color: Colors.purple),
                SizedBox(height: 10),
                Text(
                  'Link Your Gaming Accounts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 5),
                Text(
                  'Connect your external gaming profiles to challenge friends across platforms',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: platforms.length,
              itemBuilder: (context, index) {
                final platform = platforms[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: (platform['color'] as Color).withOpacity(0.5)),
                  ),
                  child: ListTile(
                    leading: Text(
                      platform['icon'] as String,
                      style: const TextStyle(fontSize: 32),
                    ),
                    title: Text(
                      platform['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      platform['username'] as String,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: platform['color'] as Color,
                      ),
                      onPressed: () {
                        _showLinkDialog(context, platform['name'] as String);
                      },
                      child: const Text('Link'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLinkDialog(BuildContext context, String platform) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Link $platform', style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$platform linked successfully!')),
              );
            },
            child: const Text('Link'),
          ),
        ],
      ),
    );
  }
}