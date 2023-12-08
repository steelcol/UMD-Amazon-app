import 'package:flutter/material.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:beta_books/pages/error_page.dart';
import 'package:beta_books/pages/home_page.dart';
import 'package:beta_books/pages/videos_page.dart';
import 'package:beta_books/pages/calendar_page.dart';
import 'package:beta_books/pages/settings_page.dart';
import 'package:beta_books/pages/shopping_page.dart';
import 'package:beta_books/pages/details_page.dart';
import 'package:beta_books/pages/compare_page.dart';
import 'package:beta_books/args/book_args.dart';

class RouteNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home: 
        return MaterialPageRoute<HomePage>(
          builder: (context) =>
            const HomePage()
        ); 
      case videos: 
        return MaterialPageRoute<VideosPage>(
          builder: (context) =>
            const VideosPage()
        ); 
      case calendar: 
        return MaterialPageRoute<CalendarPage>(
          builder: (context) =>
            const CalendarPage()
        ); 
      case userSettings: 
        return MaterialPageRoute<SettingsPage>(
          builder: (context) =>
            const SettingsPage()
        ); 
      case shopping: return MaterialPageRoute<ShoppingPage>(
          builder: (context) =>
            const ShoppingPage()
        ); 
      case details:
        BookArgs args = settings.arguments as BookArgs;
        return MaterialPageRoute<DetailsPage>(
          builder: (context) =>
            DetailsPage(
              book: args.book
            )
          );
      case compare:
        BookArgs args = settings.arguments as BookArgs;
        return MaterialPageRoute<ComparePage>(
          builder: (context) =>
            ComparePage(
              book: args.book
            )
          );

      case signin:
        return MaterialPageRoute<SignInScreen>(
          builder: (context) =>
           SignInScreen(
              providers: [
                EmailAuthProvider(),
                GoogleProvider(
                  clientId: '285036461121-msmo1t9v0tphksthdp1fnr0berrm7i2p.apps.googleusercontent.com'
                ),
              ],
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacementNamed(home);
                  }
                }),
                AuthStateChangeAction<UserCreated>((context, state) {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                     final doc = FirebaseFirestore
                                  .instance
                                  .collection('Users')
                                  .doc(user.uid);
                     doc.set({
                       'uid': user.uid,
                       'email': user.email
                     });

                    if (user.providerData[0].providerId == 'google.com') {
                      if (context.mounted) {
                        Navigator.of(context).popUntil((route) => route.isFirst); 
                        Navigator.of(context).pushReplacementNamed(home);
                      }
                    }
                    else {
                      if (context.mounted) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.pushReplacementNamed(context, signin);
                      }
                    }
                  }
                })
              ]
            )
        );
      case profile:
        return MaterialPageRoute<ProfileScreen>(
          builder: (context) =>
            ProfileScreen(
              appBar: AppBar(
                title: const Text("BetaBooks"),
              ),
              providers: [
                EmailAuthProvider(),
                GoogleProvider(
                  clientId: '285036461121-msmo1t9v0tphksthdp1fnr0berrm7i2p.apps.googleusercontent.com'
                ),
              ],
              actions: [
                SignedOutAction((context) {
                  Navigator.pushReplacementNamed(context, signin);
                })
              ],
            )
        );
      default:
        return MaterialPageRoute<ErrorPage>(
          builder: (context) => const ErrorPage()
        );
    }
  }
}
