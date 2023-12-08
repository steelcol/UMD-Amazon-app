class Book {
  final String? title;
  final String? description;
  final String? author;
  final String? isbn10;
  final String? isbn13;
  final DateTime? publishDate;
  final int? edition;
  final String? bestSeller;
  final String? topRated;
  final double? rating;
  final int? reviewCount;
  final double? price;

  Book({
    required this.title,
    required this.description,
    required this.author,
    required this.isbn10,
    required this.isbn13,
    required this.publishDate,
    required this.edition,
    required this.bestSeller,
    required this.topRated,
    required this.rating,
    required this.reviewCount,
    required this.price
  });
}

