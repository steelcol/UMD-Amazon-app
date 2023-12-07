import 'package:csv/csv.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:flutter/services.dart';

class CSVController {
  Future<List<Book>> loadCSV() async {
    List<Book> books = [];

    final input = await rootBundle.loadString('assets/AmazonBooksData.csv');
    final fields = const CsvToListConverter(convertEmptyTo: EmptyValue.NULL).convert(input);

    for (var field in fields) {
      var book = Book(
        title: field[0],
        description: field[1],
        author: field[2],
        isbn10: field[3].toString(),
        isbn13: field[4].toString(),
        publishDate: field[5],
        edition: field[6].toString(),
        bestSeller: field[7],
        topRated: field[8],
        rating: field[9].toString(),
        reviewCount: field[10].toString(),
        price: field[11]
      );
      books.add(book);
    }
   
    books.removeAt(0);
    return books; 
  }
}
