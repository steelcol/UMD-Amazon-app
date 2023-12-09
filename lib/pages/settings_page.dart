import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beta_books/routing/routes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaBooks"),
      ),
      drawer: Drawer(
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: <Widget> [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DrawerHeader(
                    child: Column(
                      children: [
                      /*
                        Image(
                          image: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!) ??,
                        ),
                        */
                        FirebaseAuth.instance.currentUser!.displayName != null
                        ? Text(FirebaseAuth.instance.currentUser!.displayName!) 
                        : const Text('User'),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('Account'),
                    onTap: () => Navigator.of(context).pushReplacementNamed(profile),
                  ),
                  ListTile(
                    title: const Text('Calendar'),
                    onTap: () => Navigator.of(context).pushReplacementNamed(calendar),
                  ),
                  ListTile(
                    title: const Text('Videos'),
                    onTap: () => Navigator.of(context).pushReplacementNamed(videos),
                  ),
                ],
              ),
            ),
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text('Settings'),
                ),
              ),
            ),
          ]
        ),
      ),
      body: Center(),
    );
  }
}
