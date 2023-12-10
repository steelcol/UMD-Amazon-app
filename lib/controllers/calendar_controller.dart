import 'package:beta_books/models/calendar_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarController {
  final user = FirebaseAuth.instance.currentUser;
  final dbRef = FirebaseFirestore.instance.collection('Users');

  Future<List<CalendarModel>> getShoppingCart() async {
    List<CalendarModel> calendarList = [];
    var document = await dbRef.doc(user!.uid).get();
    try {
      if (document.get('BooksBeingShipped') != null) {
        for(var value in document.get('BooksBeingShipped')) {
          CalendarModel book = CalendarModel(
            title: value['Title'],
            date: DateTime.fromMillisecondsSinceEpoch(value['ArrivalDate'])
          );
          calendarList.add(book); 
        }
      }
    }
    catch (error) {
     print(error); 
    }
    return calendarList;
  }
}
