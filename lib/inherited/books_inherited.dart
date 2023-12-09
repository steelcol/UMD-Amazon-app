import 'package:flutter/material.dart';
import 'package:beta_books/models/book_model.dart';

class BooksData extends InheritedWidget {
  const BooksData({
    Key? key,
    required this.childWidget,
    required this.books
  }) : super(key:key, child: childWidget);

  final Widget childWidget;

  // Book data
  final List<Book> books;

  static BooksData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BooksData>()!;
  }

  @override
  bool updateShouldNotify(BooksData oldWidget) {
    return oldWidget.books != books;
  }
}
