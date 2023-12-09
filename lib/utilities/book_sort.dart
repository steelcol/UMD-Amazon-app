import 'package:beta_books/models/book_model.dart';

class BookSort {
  void _swap(List<Book> list, int idx1, int idx2) {
    Book temp = list[idx1];
    list[idx1] = list[idx2];
    list[idx2] = temp;
  }

  int _partition(List<Book> list, int low, int high, String value) {
    Book pivot = list[high];
    // index of the smaller element and indicate the right position
    // of the pivot found so far
    int i = low - 1;

    if (value == 'Alphabetical') {
      for (int j = low; j <= high; j++) {
        // if current element is smaller than the pivot
        if (list[j].title != null) {
          if (pivot.title == null) {
            i++;
            _swap(list, i, j);
          }
          else if (list[j].title!.toLowerCase().compareTo(
              pivot.title!.toLowerCase()) == -1) {
            i++;
            _swap(list, i, j);
          }
        }
      }
      _swap(list, i + 1, high);
      return (i + 1);
    }
    else if (value == 'Price') {
      for (int j = low; j <= high; j++) {
        // if current element is smaller than the pivot
        if (list[j].price != null) {
          if (pivot.price == null) {
            i++;
            _swap(list, i, j);
          }
          else if (list[j].price! < pivot.price!) {
            i++;
            _swap(list, i, j);
          }
        }
      }
      _swap(list, i + 1, high);
      return (i + 1);
    }
    else if (value == 'Rating') {
      for (int j = low; j <= high; j++) {
        // if current element is smaller than the pivot
        if (list[j].rating != null) {
          if (pivot.rating == null) {
            i++;
            _swap(list, i, j);
          }
          else if (list[j].rating! < pivot.rating!) {
            i++;
            _swap(list, i, j);
          }
        }
      }
      _swap(list, i + 1, high);
      return (i + 1);
    }
    else if (value == 'Review Count') {
      for (int j = low; j <= high; j++) {
        // if current element is smaller than the pivot
        if (list[j].reviewCount != null) {
          if (pivot.reviewCount == null) {
            i++;
            _swap(list, i, j);
          }
          else if (list[j].reviewCount! > pivot.reviewCount!) {
            i++;
            _swap(list, i, j);
          }
        }
      }
      _swap(list, i + 1, high);
      return (i + 1);
    } else {
      return (i + 1);
    }
  }

  void quickSort(List<Book> list, int low, int high, String value) {
    if (low < high) {
      int pi = _partition(list, low, high, value);
      quickSort(list, low, pi - 1, value);
      quickSort(list, pi + 1, high, value);
    }
  }
}