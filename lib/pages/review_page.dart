import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  final databaseReference = FirebaseFirestore.instance.collection('Events');
  final String createText = "Enter";
  final String showText = "Review";
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void createEvent(){
    databaseReference.doc('ik6WOyW2vjga9AsfyGUc9D4jm5u2').update({"Events_Array": FieldValue.arrayUnion([myController.text])});
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
              TextButton(onPressed: createEvent, child: Text(createText)),
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
