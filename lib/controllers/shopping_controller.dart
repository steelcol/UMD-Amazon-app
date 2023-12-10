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
            title: value['title']
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
            'title': book.title
          }])}); 
      }
      else {
        await dbRef.doc(user!.uid)
          .set({'ShoppingList': FieldValue.arrayUnion([{
            'isbn13': book.isbn13,
            'price': book.price,
            'title': book.title
          }])}); 
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
          'title': book.title
        }])});
    }
    catch (error) {
      throw Error();
    }
  }
}