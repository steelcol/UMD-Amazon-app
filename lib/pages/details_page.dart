import 'package:beta_books/args/book_args.dart';
import 'package:beta_books/controllers/shopping_controller.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:beta_books/models/shopping_book_model.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:beta_books/models/review_model.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, 
    required this.book
  }) : super(key: key);

  final Book book;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final databaseReference = FirebaseFirestore.instance.collection('Reviews');
  final String createText = "Enter";
  final String showText = "Review";
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  static const List<String> list = <String>['1', '2', '3', '4', '5'];
  String dropdownValue = list.first;

  late List<Review> reviews = [];

  Future<void> getReview() async {
    bool bookExists = await _checkExist('${widget.book.title}');
    if (bookExists) {
      try {
        reviews = [];

        await databaseReference
            .doc('q2D7TPbPNtUZ3GU0gj2M')
            .get()
            .then((value) {
          List.from(value.data()!['${widget.book.title}']).forEach((element) {
            Review review = Review(
                review: element['review'],
                score: element['score']
            );
            reviews.add(review);
          });
        });
      } catch (e) {
        throw Future.error('ERROR: $e');
      }
    } else {
      reviews = [];
    }
  }

  Future<bool> _checkExist(String book) async {
    DocumentSnapshot<Map<String, dynamic>> document = await databaseReference
        .doc('q2D7TPbPNtUZ3GU0gj2M')
        .get();
    return document.exists ? true : false;
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void createReview() {
    databaseReference.doc('q2D7TPbPNtUZ3GU0gj2M').update({
      "${widget.book.title}": FieldValue.arrayUnion([
        {
          "review": myController.text,
          "score": dropdownValue,
        }
      ])
    });

    setState(() {});
  }
  ShoppingController _controller = ShoppingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaBooks"),
      ),
      body: FutureBuilder<void>(
          future: getReview(),
          builder: (context, snapshot) {
            return Padding(
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
            TextField(
              controller: myController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Review',
              ),
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextButton(onPressed: createReview, child: Text(createText)),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return _buildEventCard(index);
                },
              ),
            ),
          ],
        ),
            );
          }
      ),
    );
  }

  Widget _buildEventCard(int index) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Review: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text('${reviews[index].score} / 5',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ),
              Text('${reviews[index].review}',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}
