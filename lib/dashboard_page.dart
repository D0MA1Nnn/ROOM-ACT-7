import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.dashboard, size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Welcome, $username!',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'Explore your student application using the navigation bar below.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.calculate_outlined),
                  title: Text('Calculator'),
                  subtitle: Text('Perform basic arithmetic operations.'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.people_outline),
                  title: Text('Social'),
                  subtitle: Text('Create posts, like posts, and add comments.'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Profile'),
                  subtitle: Text('View student information and log out.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
