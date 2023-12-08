import 'package:beta_books/controllers/csv_controller.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:beta_books/routing/route_generator.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:beta_books/inherited/books_inherited.dart';

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

class BetaBooks extends StatefulWidget {
  const BetaBooks({Key? key}) : super(key: key);

  @override
  State<BetaBooks> createState() => _BetaBooksState();
}

class _BetaBooksState extends State<BetaBooks> {

  List<Book> books = [];
  CSVController controller = CSVController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {

        // Error 
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
              ),
            );
          }
          
          // Have data
          else if (snapshot.hasData) {
            books = snapshot.data as List<Book>;

            return BooksData(
              books: books,
              childWidget: MaterialApp(
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
              ),
            );
          }
        }
        
        // Loading
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        );
      },
      future: controller.loadCSV(),
    );  
  }
}
