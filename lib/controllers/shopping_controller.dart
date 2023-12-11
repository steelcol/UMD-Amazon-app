import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beta_books/models/shopping_book_model.dart';

class ShoppingController {
  List<ShoppingBook> shoppingList = [];
  var user = FirebaseAuth.instance.currentUser;
  var dbRef = FirebaseFirestore.instance.collection('Users');

  Future<List<ShoppingBook>> getShoppingCart() async {
    List<ShoppingBook> shoppingList = [];
    var document = await dbRef.doc(user!.uid).get();
    try {
      if (document.get('ShoppingList') != null) {
        for(var value in document.get('ShoppingList')) {
          ShoppingBook book = ShoppingBook(
            isbn13: value['isbn13'],
            price: value['price'],
            title: value['title'],
            rating: value['rating'],
            reviewCount: value['reviewCount']
          );
          shoppingList.add(book); 
        }
      }
    }
    catch (error) {
     print(error); 
    }
    return shoppingList;
  }

  Future<void> addBookToShoppingCart(ShoppingBook book) async {
    var document = await dbRef.doc(user!.uid).get();
    try {
      if (document.data()!.containsKey('ShoppingList')) {
        await dbRef.doc(user!.uid)
          .update({'ShoppingList': FieldValue.arrayUnion([{
            'isbn13': book.isbn13,
            'price': book.price,
            'title': book.title,
            'rating': book.rating,
            'reviewCount': book.reviewCount
          }])}); 
      }
      else {
        await dbRef.doc(user!.uid)
          .set({'ShoppingList': FieldValue.arrayUnion([{
            'isbn13': book.isbn13,
            'price': book.price,
            'title': book.title,
            'rating': book.rating,
            'reviewCount': book.reviewCount
          }])},SetOptions(merge: true)); 
      }
    }
    catch (error) {
     print(error);
    }
  }

  Future<void> removeBookFromShoppingCart(int index) async {
    ShoppingBook book = shoppingList[index];
    shoppingList.removeAt(index);
    try {
      await dbRef.doc(user!.uid)
        .update({'ShoppingList': FieldValue.arrayRemove([{
          'isbn13': book.isbn13,
          'price': book.price,
          'title': book.title,
          'rating': book.rating,
          'reviewCount': book.reviewCount
        }])});
    }
    catch (error) {
      throw Error();
    }
  }

  Future<void> buyBooks() async {
    var document = await dbRef.doc(user!.uid).get();
    try {
      if (document.data()!.containsKey('BooksBeingShipped')) {
        shoppingList.forEach((book) async { 
          await dbRef.doc(user!.uid)
            .update({'BooksBeingShipped': FieldValue.arrayUnion([{
              'ArrivalDate': DateTime.now().millisecondsSinceEpoch,
              'Title': book.title
            }])});
        });
      }
      else {
        shoppingList.forEach((book) async { 
          await dbRef.doc(user!.uid)
            .set({'BooksBeingShipped': FieldValue.arrayUnion([{
              'ArrivalDate': DateTime.now().millisecondsSinceEpoch,
              'Title': book.title
            }])},SetOptions(merge: true));
        });
      }
    }
    catch (error) {
     print(error);
    }
    int length = shoppingList.length;
    for (int i = 0; i < length; i++) {
      removeBookFromShoppingCart(i);
    }
    shoppingList = [];
  }
}
