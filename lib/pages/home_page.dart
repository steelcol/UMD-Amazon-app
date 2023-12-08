import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:beta_books/routing/routes.dart'; import 'package:beta_books/inherited/books_inherited.dart';
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

  List<Book> searchedBooks = [];
  final TextEditingController SearchController = TextEditingController();
  String dropdownValue = sortList.first;

  @override
  void initState() {
    super.initState();
    SearchController.addListener(_onSearchFieldChange);

    // This is required for searching, otherwise app will brick because inherited widget
    // is being called before init.state() completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        searchedBooks = BooksData.of(context).books;
      });
    });
  }

  void _sort(List<Book> bookList, String value) {
    if (bookList.isNotEmpty) {
      final sort = BookSort();
      sort.quickSort(bookList, 0, bookList.length - 1, value);
      setState(() {});
    }
  }

  void _onSearchFieldChange()
  {
    filterBooks(SearchController.text);
    _sort(searchedBooks, dropdownValue);
  }

  void filterBooks(String search) {
    List<Book> books = BooksData.of(context).books;
    if (search.isNotEmpty) {
      setState(() {
        searchedBooks = books.where((book) {
          // Have to check if each searchable book data member is null
          // This sucks, but NULL is best way to describe missing data w/ books
          // and all future features will have to account for it
          var title = book.title?.toLowerCase() ?? '';
          var author = book.author?.toLowerCase() ?? '';
          var isbn13 = book.isbn13 ?? '';


          // TODO: Handle duplicate books (exist in dataset!!)
          return title.contains(search.toLowerCase()) ||
              author.contains(search.toLowerCase()) ||
              isbn13.contains(search.toLowerCase());}).toList();
      });
    } else {
      setState(() {
        searchedBooks = books;
      });
    }
    // print("Filtered books: ${searchedBooks.map((book) => book.title).toList()}");
  }

  @override
  void dispose() {
    SearchController.removeListener(_onSearchFieldChange);
    SearchController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
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
        children: [
          _buildSearchBar(),
          Row(
            children: [
              _buildSortDropdownButton(),
              const Spacer(),
            ]
          ),
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: searchedBooks.length,
              itemBuilder: (context, index) => _buildBookCard(index),),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: TextField(
        controller: SearchController,
        decoration: const InputDecoration(
          hintText: 'Enter title, author, or ISBN',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.zero,),
        ),
      ),
    );
  }

  Widget _buildSortDropdownButton() {
    return DropdownButton<String>(
      padding: const EdgeInsets.all(12),
      icon: const Icon(Icons.sort),
      value: dropdownValue,
      style: const TextStyle(
        fontSize: 12,
      ),
      items: sortList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
              value,
              style: const TextStyle(
                fontSize: 10,
              ),
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
          _sort(searchedBooks, value);
        });
      },
    );
  }

  Widget _buildBookCard(int index) {

    Book book = searchedBooks[index];

    return SizedBox(
      height: book.title != null && book.title!.length > 50
      ? MediaQuery.of(context).size.height/6
      : MediaQuery.of(context).size.height/8,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          details,
          arguments: BookArgs(book: book)
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
                  book.title ?? 'Not provided',
                  style: const TextStyle(
                    fontSize: 13
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                child: Text(
                  book.author ?? 'Not provided',
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                child: Text(
                  book.price != null
                  ? '\$${book.price}'
                  : 'Not provided',
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
