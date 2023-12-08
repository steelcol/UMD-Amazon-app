import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beta_books/routing/routes.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({Key? key}) : super(key: key);

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
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
                  const ListTile(
                    title: Text('Videos'),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: const Text('Settings'),
                  onTap: () => Navigator.of(context).pushReplacementNamed(userSettings),
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
