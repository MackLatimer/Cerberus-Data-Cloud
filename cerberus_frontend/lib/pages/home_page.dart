import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerberus Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Implement user profile/logout functionality
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Welcome, Campaign Manager!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 2,
            children: [
              _buildDashboardCard(
                context,
                icon: Icons.people,
                title: 'Voters',
                subtitle: 'Manage your voter database',
                onTap: () {
                  // context.go('/voters');
                },
              ),
              _buildDashboardCard(
                context,
                icon: Icons.flag,
                title: 'Campaigns',
                subtitle: 'View and edit campaigns',
                onTap: () {
                  // context.go('/campaigns');
                },
              ),
              _buildDashboardCard(
                context,
                icon: Icons.assessment,
                title: 'Reports',
                subtitle: 'Analyze campaign data',
                onTap: () {
                  // context.go('/reports');
                },
              ),
              _buildDashboardCard(
                context,
                icon: Icons.settings,
                title: 'Settings',
                subtitle: 'Configure your account',
                onTap: () {
                  // context.go('/settings');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // You could add a list of recent activities here
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}