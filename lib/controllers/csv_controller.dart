import 'package:csv/csv.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:flutter/services.dart';
import 'dart:core';

class CSVController {
  Future<List<Book>> loadCSV() async {
    List<Book> books = [];

    final input = await rootBundle.loadString('assets/AmazonBooksData.csv');
    final fields = const CsvToListConverter(
      convertEmptyTo: EmptyValue.NULL, 
      shouldParseNumbers:false).convert(input);

    for (var field in fields.sublist(1)) {
      var book = Book(
        title: field[0],
        description: field[1],
        author: field[2],
        isbn10: field[3],
        isbn13: field[4],
        publishDate: field[5] == null
        ? null 
        : DateTime.tryParse(field[5]),
        edition: field[6] == null
        ? null
        : int.tryParse(field[6]),
        bestSeller: field[7],
        topRated: field[8],
        rating: getCorrectDouble(field[9]),
        reviewCount: getCorrectInt(field[10]),
        price: getCorrectDouble(field[11])
      );
      books.add(book);
    }
    return books; 
  }

  int? getCorrectInt(dynamic myInt) {
    if (myInt == null) {
      return null;
    }
    var parts = myInt.toString().split(",");
    var newInt = parts.join();
    return int.parse(newInt);
  }

  double? getCorrectDouble(dynamic myDouble) {
    if (myDouble == null) {
      return null;
    }
    else if (myDouble.toString().split("\$").length > 1) {
      return double.tryParse(myDouble.toString().split("\$")[1]) ?? 0.0;
    }
    return double.tryParse(myDouble.toString().split("\$")[0]) ?? 0.0;
  }
}
