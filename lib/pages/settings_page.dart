import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:provider/provider.dart';
import 'package:beta_books/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaBooks"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, home);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Text(
                FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24.0, thickness: 2.0),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Account'),
                onTap: () => Navigator.of(context).pushNamed(profile),
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb_outline),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Light/Dark'),
                    Switch(
                      value: context.watch<AppThemeProvider>().isDarkMode,
                      onChanged: (value) {
                        context.read<AppThemeProvider>().toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
