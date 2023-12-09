import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:beta_books/inherited/books_inherited.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Book> books = BooksData.of(context).books;
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
                  const ListTile(
                    title: Text('Calendar'),
                  ),
                  ListTile(
                    title: const Text('Videos'),
                    onTap: () => Navigator.of(context).pushReplacementNamed(videos),
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
    );
  }
}
