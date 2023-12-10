import 'package:beta_books/args/book_args.dart';
import 'package:beta_books/controllers/shopping_controller.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:beta_books/models/shopping_book_model.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, 
    required this.book
  }) : super(key: key);

  final Book book;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  ShoppingController _controller = ShoppingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaBooks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                widget.book.title ?? 'N/A',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Price: \$${widget.book.price ?? 'N/A'}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Rating: ${widget.book.rating ?? 'N/A'}/5',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Edition: ${widget.book.edition ?? 'N/A'}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Publication Date: ${widget.book.publishDate != null ? _formatDate(widget.book.publishDate!) : 'N/A'}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      const snackBar = SnackBar(
                        content: Text('Added to shopping cart'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      _controller.addBookToShoppingCart(
                        ShoppingBook(
                          isbn13: widget.book.isbn13,
                          price: widget.book.price, 
                          title: widget.book.title
                        )
                      );
                    }, 
                    child: const Text('Add to cart'),
                  ),
                ),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  compare,
                  arguments: BookArgs(book: widget.book),
                ),
                child: const Text('Compare Editions'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}
