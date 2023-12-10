import 'package:beta_books/args/book_args.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  final databaseReference = FirebaseFirestore.instance.collection('Reviews');
  final String createText = "Enter";
  final String showText = "Review";
  final myController = TextEditingController();

  late List<String> rev;
  late int len;
  late final DocumentSnapshot doc;

  /*void getLen() async {
    await databaseReference.doc('q2D7TPbPNtUZ3GU0gj2M').get().then((value) {
      try {
        final val = value.data();
        if(value.data() != null) {
          debugPrint('$len');
          len = int.parse(val!['${widget.book.title}'].length.toString());
          debugPrint('$len');
        } else {
          len = 0;
        }
      } catch (e) {
        throw Future.error('ERROR: $e');
      }
    });
  }*/

  void getReview() async {
      debugPrint('function called');
      try {
        rev = [];
        await databaseReference.doc('q2D7TPbPNtUZ3GU0gj2M').get().then((value) {
        for (var element in List.from(value.data()!['${widget.book.title}'])) {
          rev.add(element.toString());
        }
      });
      } catch (e) {
        throw Future.error('ERROR: $e');
      }

  }

  @override
  void initState() {
    super.initState();

    getReview();

    len = rev.length;

    setState(() {
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void createReview(){
    databaseReference.doc('q2D7TPbPNtUZ3GU0gj2M').update({'${widget.book.title}': FieldValue.arrayUnion([myController.text])});
    setState(() {

    });
  }

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
            Text(
              widget.book.title ?? 'N/A',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Price: \$${widget.book.price ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 12),
            Text(
              'Rating: ${widget.book.rating ?? 'N/A'}/5',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Edition: ${widget.book.edition ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Publication Date: ${widget.book.publishDate != null ? _formatDate(widget.book.publishDate!) : 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            Spacer(), // Added Spacer to push button to the bottom
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  compare,
                  arguments: BookArgs(book: widget.book),
                ),
                child: const Text('Compare Editions'),
              ),
            ),
            Spacer(), // Added Spacer to push button to the top
            TextField(
              controller: myController,
              decoration: const InputDecoration(border: OutlineInputBorder(),
                hintText: 'Enter Review',
              ),
            ),
            TextButton(onPressed: createReview, child: Text(createText)),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: len,
                itemBuilder: (context, index) {
                  print(len);
                  return _buildEventCard(
                      index
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(int index) {
    return InkWell(
      child: Text(
        "Review: ${rev[index]}",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
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
