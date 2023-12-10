import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final databaseReference = FirebaseFirestore.instance.collection('Reviews');
  final String createText = "Enter";
  final String showText = "Review";
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void createReview(){
    databaseReference.doc('q2D7TPbPNtUZ3GU0gj2M').update({"Title": FieldValue.arrayUnion([myController.text])});
    databaseReference.doc('q2D7TPbPNtUZ3GU0gj2M').update({"Review": FieldValue.arrayUnion([myController.text])});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaBooks"),
      ),
      body: Center(
        child: Column(
          // Build events page here
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: myController,
                decoration: const InputDecoration(border: OutlineInputBorder(),
                  hintText: 'Enter Review',
                ),
              ),
              TextButton(onPressed: createReview, child: Text(createText)),
              TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: Text(myController.text)
                        );
                      },
                    );
                  },
                  child: Text(showText)),
            ]
        ),
      ),
    );
  }
}
