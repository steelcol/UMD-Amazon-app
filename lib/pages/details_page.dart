import 'package:beta_books/models/book_model.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}
