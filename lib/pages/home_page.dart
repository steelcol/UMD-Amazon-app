import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:beta_books/inherited/books_inherited.dart';
import 'package:beta_books/args/book_args.dart';
import 'package:beta_books/utilities/book_sort.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

const List<String> sortList = <String>[
  '', 'Alphabetical', 'Price', 'Rating', 'Review Count'
];

class _HomePageState extends State<HomePage> {

  List<Book> books = [];

  String dropdownValue = sortList.first;
  final _searchController = TextEditingController();
  //late List<Book> sortedList;
  List<Book> _searchResults = [];

  @override
  void initState() {
    super.initState();
  }

  void _performSearch() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _searchResults =
          List.from(books); // CASE: display workouts if search is empty
    } else {
      _searchResults = books
          .where((book) {
            bool val = false;
            if (book.title != null) {
              val = book.title!.toLowerCase().contains(query);
            }
            return val;
      }).toList();
    }
    _sort(_searchResults, dropdownValue);
    setState(() {});
  }

  void _sort(List<Book> bookList, String value) {
    if (bookList.isNotEmpty) {
      final sort = BookSort();
      sort.quickSort(bookList, 0, bookList.length - 1, value);
      setState(() {});
      debugPrint(
          "${bookList[0].title}, ${bookList[1].title}, ${bookList[2].title}");
    }
  }
 
  @override
  Widget build(BuildContext context) {
    books = BooksData.of(context).books;
    if (_searchResults.isEmpty) {
      _performSearch();
    }
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

      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row (
            children: [
              Expanded(
                child:TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search books',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _performSearch,
                    ),
                  ),
                  onChanged: (value) => _performSearch(), // Search on text change
                ),
              ),
              DropdownButton<String>(
                icon: const Icon(Icons.filter_alt_sharp),
                value: dropdownValue,
                items: sortList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                    _sort(_searchResults, value);
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) => _buildBookCard(index),
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(int index) {  
    return SizedBox(
      height: _searchResults[index].title != null && _searchResults[index].title!.length > 50
      ? MediaQuery.of(context).size.height/6
      : MediaQuery.of(context).size.height/8,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          details,
          arguments: BookArgs(book: _searchResults[index])
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                child: Text(
                  _searchResults[index].title ?? 'Not provided',
                  style: const TextStyle(
                    fontSize: 13
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                child: Text(
                  _searchResults[index].author ?? 'Not provided',
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                child: Text(
                  _searchResults[index].price ?? 'Not provided',
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
