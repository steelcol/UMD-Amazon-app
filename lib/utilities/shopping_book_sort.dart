import 'package:beta_books/models/shopping_book_model.dart';

class ShoppingBookSort {
  void _swap(List<ShoppingBook> list, int idx1, int idx2) {
    ShoppingBook temp = list[idx1];
    list[idx1] = list[idx2];
    list[idx2] = temp;
  }

  int _partition(List<ShoppingBook> list, int low, int high, String value) {
    ShoppingBook pivot = list[high];
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
    else {
      return (i + 1);
    }
  }

  void quickSort(List<ShoppingBook> list, int low, int high, String value) {
    if (low < high) {
      int pi = _partition(list, low, high, value);
      quickSort(list, low, pi - 1, value);
      quickSort(list, pi + 1, high, value);
    }
  }
}
