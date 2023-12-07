import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:beta_books/controllers/csv_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Allows the passing down of data throught the widget tree
// Use like this
// BooksData.of(innerContext).message, 
class BooksData extends InheritedWidget {
  const BooksData({
    Key? key,
    required this.childWidget,
    required this.books
  }) : super(key:key, child: childWidget);

  final Widget childWidget;

  // Book data
  final List<Book> books;

  static BooksData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BooksData>()!;
  }

  @override
  bool updateShouldNotify(BooksData oldWidget) {
    return oldWidget.books != books;
  }
}

class _HomePageState extends State<HomePage> {

  List<Book> books = [];
  CSVController controller = CSVController();


  @override
  void initState() {
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {

        // Error 
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
              ),
            );
          }
          
          // Have data
          else if (snapshot.hasData) {
            books = snapshot.data as List<Book>;

            return BooksData(
              books: books,
              childWidget: Builder(
              builder: (BuildContext innerContext) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("BetaBooks"),
                    actions: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pushNamed(shopping),
                        icon: const Icon(Icons.shopping_cart),
                      ),
                    ],
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
                            ],
                          ),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ListTile(
                              title: const Text('Settings'),
                              onTap: () => Navigator.of(context).pushNamed(userSettings),
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  body: Center(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),  
                      itemCount: books.length,
                      itemBuilder: (context, index) => _buildBookCard(index),
                    )
                  ),  
                );
              }),
            );
          }
        }
        
        // Loading
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      future: controller.loadCSV(),
    );  
  }

  Widget _buildBookCard(int index) {  
    return SizedBox(
      height: books[index].title != null && books[index].title!.length > 50
      ? MediaQuery.of(context).size.height/6
      : MediaQuery.of(context).size.height/8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: Text(
                books[index].title ?? 'Not provided',
                style: const TextStyle(
                  fontSize: 13
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: Text(
                books[index].author ?? 'Not provided',
                style: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: Text(
                books[index].price ?? 'Not provided',
                style: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

