import 'package:beta_books/inherited/books_inherited.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
class ComparePage extends StatefulWidget {
  const ComparePage({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  List<Book> relatedBooks = [];
  Book? selectedBook;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // No reason to check edition because they are all the same
    relatedBooks = BooksData.of(context).books.where((book)
      => book.title == widget.book.title
      && book != widget.book).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaBooks"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20
                  ),
                  child: SizedBox(
                    height: widget.book.title != null && widget.book.title!.length > 50
                    ? MediaQuery.of(context).size.height / 6
                    : MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(
                      widget.book.title ?? 'Not provided',
                      textAlign: TextAlign.center,
                      )
                    ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Icon(Icons.compare_arrows),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 3,
                    child: selectedBook == null || selectedBook!.title == null
                      ? const Text('No book selected')
                      : Text(
                          selectedBook!.title!,
                          textAlign: TextAlign.center,
                        )
                    ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(widget.book.isbn13 ?? '')
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 3,
                    child: selectedBook == null || selectedBook!.isbn13 == null
                      ? const Text('')
                      : Text(
                          selectedBook!.isbn13!,
                          textAlign: TextAlign.end,
                        )
                    ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 3,
                    child: widget.book.price == null
                      ? const Text('')
                      : Text(
                          '\$${widget.book.price}',
                        )
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 3,
                    child: selectedBook == null || selectedBook!.price == null
                      ? const Text('')
                      : Text(
                          '\$${selectedBook!.price!}',
                          textAlign: TextAlign.end,
                        )
                    ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 3,
                    child: RatingBarIndicator(
                      rating: widget.book.rating ?? 0.0,
                      itemBuilder: (context, index) => const Icon(
                           Icons.star,
                           color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 15,
                      direction: Axis.horizontal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RatingBarIndicator(
                          rating: selectedBook == null || selectedBook!.rating == null
                          ? 0.0
                          : selectedBook!.rating!,
                          itemBuilder: (context, index) => const Icon(
                               Icons.star,
                               color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 15.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: ListView.builder(
                itemCount: relatedBooks.length,
                itemBuilder: (context, index) {
                  return bookCard(index);
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget bookCard(index) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width / 4,
      child: InkWell(
        onTap: () => setState(() {selectedBook = relatedBooks[index];}),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.book_outlined,
                size: 50,
              ),
              relatedBooks[index].edition == null
              ? const Text('Not provided')
              : Text(
                  '${relatedBooks[index].title}',
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
