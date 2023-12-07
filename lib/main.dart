import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'firebase_options.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:firebase_auth/firebase_auth.dart'hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:beta_books/routing/route_generator.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(
      clientId: '285036461121-msmo1t9v0tphksthdp1fnr0berrm7i2p.apps.googleusercontent.com'
    ),
  ]);

  runApp(const BetaBooks());
}

class BetaBooks extends StatelessWidget {
  const BetaBooks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BetaBooks",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      initialRoute: FirebaseAuth.instance.currentUser == null
        ? signin
        : home,
      onGenerateRoute: RouteNavigator.generateRoute,
    );
  }
}
