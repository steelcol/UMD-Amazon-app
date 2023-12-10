import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:beta_books/inherited/books_inherited.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utilities/utils_for_schedule_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key,
  }) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}




class _CalendarPageState extends State<CalendarPage> {
    CalendarFormat _calendarFormat = CalendarFormat.month;
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;
    final videoURL = "";

    @override
    void initState() {
      super.initState();
    }

    get args =>
    null;

    @override
    Widget build(BuildContext context) {
      List<Book> books = BooksData.of(context).books;
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: const Text('Beta Books'),
        ),
        drawer: Drawer(
          child: CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: <Widget> [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DrawerHeader(
                        child: Column(
                          children: [
                            /*
                        Image(
                          image: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!) ??,
                        ),
                        */
                            FirebaseAuth.instance.currentUser!.displayName != null
                                ? Text(FirebaseAuth.instance.currentUser!.displayName!)
                                : const Text('User'),
                          ],
                        ),
                      ),
                      const ListTile(
                        title: Text('Calendar'),
                      ),
                      ListTile(
                        title: const Text('Videos'),
                        onTap: () => Navigator.of(context).pushReplacementNamed(videos),
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      title: const Text('Settings'),
                      onTap: () => Navigator.of(context).pushReplacementNamed(userSettings),
                    ),
                  ),
                ),
              ]
          ),
        ),
        body: TableCalendar(

          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              // Call `setState()` when updating calendar format
              setState(() {
                _calendarFormat = format;
              });
            }
          },

          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },

        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {

            //Navigator.pushNamed(context, eventsPageRoute, arguments: args);
          },
          icon: const Icon(Icons.add),

          label: const Text('Add Event'),
          backgroundColor: Colors.blueGrey,
        ),
      );
    }
  }
