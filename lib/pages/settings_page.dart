import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:provider/provider.dart';
import 'package:beta_books/providers/theme_provider.dart'; // Add this line

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
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () async {
                  bool shouldLogout = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    try {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacementNamed(login);
                    } catch (error) {
                      print('Error signing out: $error');
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('An error occurred while signing out.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Account'),
                onTap: () async {
                  bool shouldDelete = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Account Deletion'),
                      content: const Text('Are you sure you want to delete your account?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (shouldDelete == true) {
                    try {
                      await FirebaseAuth.instance.currentUser!.delete();
                      Navigator.of(context).pushReplacementNamed(login);
                    } catch (error) {
                      print('Error deleting account: $error');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
