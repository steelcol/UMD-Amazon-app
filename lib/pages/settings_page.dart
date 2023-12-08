import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beta_books/routing/routes.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Text(
                  FirebaseAuth.instance.currentUser!.displayName ?? 'User',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 24.0, thickness: 2.0),
                ListTile(
                  title: const Text('Profile'),
                  onTap: () => Navigator.of(context).pushNamed(profile),
                ),
                ListTile(
                  title: const Text('Calendar'),
                  onTap: () => Navigator.of(context).pushNamed(calendar),
                ),
                ListTile(
                  title: const Text('Videos'),
                  onTap: () => Navigator.of(context).pushNamed(videos),
                ),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed(login);
                  },
                ),
                ListTile(
                  title: const Text('Light/Dark'),
                  onTap: () {
                    // Implement your theme toggle logic here
                    // Example using provider: context.read<ThemeProvider>().toggleTheme();
                  },
                ),
                ListTile(
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
        ],
      ),
    );
  }
}
