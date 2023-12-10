import 'package:beta_books/models/book_model.dart';
import 'package:flutter/material.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaBooks"),
      ),      
    );
  }
}
