import 'package:flutter/material.dart';

import 'demo_auth.dart';
import 'login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.username});

  final String username;

  void logout(BuildContext context) {
    DemoAuth.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 60)),
          const SizedBox(height: 16),
          Text(
            'Justine Ric Intano',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Logged in as: $username', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.badge_outlined),
                  title: Text('Student ID'),
                  subtitle: Text('2026-554115'),
                ),
                ListTile(
                  leading: Icon(Icons.school_outlined),
                  title: Text('Course and Section'),
                  subtitle: Text('BSIT · CCE106L (2447)'),
                ),
                ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text('Email'),
                  subtitle: Text('j.intano.554115@umindanao.edu.ph'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
