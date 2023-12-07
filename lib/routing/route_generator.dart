import 'package:flutter/material.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:beta_books/pages/error_page.dart';
import 'package:beta_books/pages/home_page.dart';

class RouteNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
      case home: 
        return MaterialPageRoute<HomePage>(
          builder: (context) =>
            HomePage()
        );
      default:
        return MaterialPageRoute<ErrorPage>(
          builder: (context) => const ErrorPage()
        );
    }
  }
}
