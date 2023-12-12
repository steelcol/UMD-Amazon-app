import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:beta_books/routing/routes.dart'; import 'package:beta_books/inherited/books_inherited.dart';
import 'package:beta_books/args/book_args.dart';
import 'package:beta_books/utilities/book_sort.dart';
import 'package:url_launcher/url_launcher.dart';


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
  final TextEditingController searchController = TextEditingController();
  String dropdownValue = sortList.first;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchFieldChange);

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
    filterBooks(searchController.text);
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
    searchController.removeListener(_onSearchFieldChange);
    searchController.dispose();

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
          if (searchedBooks.isEmpty) ... [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'No results found',
                style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColorLight),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _buildDataSetAuthorCard(),
            ),
          ] else Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: searchedBooks.length + 1,
              itemBuilder: (context, index) {
                // If not last item continue to build book cards
                if (index < searchedBooks.length) {
                  return _buildBookCard(index);
                } else {
                  // Build the author footnote if it's the last card
                  return _buildDataSetAuthorCard();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          /// TEXT FIELD
          TextField(
            controller: searchController,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            decoration: const InputDecoration(
              hintText: 'Enter title, author, or ISBN',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.zero,),
            ),
          ),
          Positioned(
            right: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                /// VERTICAL LINE
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).primaryColorLight,
                    width: .75,
                  ),
                ),
              ),

              /// DROP DOWN MENU
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  style: TextStyle(fontSize: 13, color: Theme.of(context).primaryColorLight, fontWeight: FontWeight.w300),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      _sort(searchedBooks, value);
                    });
                  },

                  /// INTERNAL MENU
                  items: sortList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 13, color: Theme.of(context).primaryColorLight),
                      ),
                    );
                  }).toList(),

                ),
              ),

            ),
          ),
        ],
      ),
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

  Future<void> openURL() async {
    const url = 'https://www.kaggle.com/uzair01';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open $uri';
    }
  }

  Widget _buildDataSetAuthorCard() {
    return InkWell(
      onTap: openURL,
      child: Card(
        color: Theme.of(context).primaryColorLight.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Dataset created by Muhammad Uzair Khan',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColorLight.withOpacity(0.25)),
                ),
              ),
              Icon(Icons.arrow_forward_outlined, color: Theme.of(context).primaryColorLight.withOpacity(0.25),
              )
            ],
          ),
        ),
      ),
    );
  }
}
