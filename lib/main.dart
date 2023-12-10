import 'package:beta_books/controllers/csv_controller.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:beta_books/routing/route_generator.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:beta_books/inherited/books_inherited.dart';
import 'package:provider/provider.dart';
import 'package:beta_books/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(
      clientId: '285036461121-msmo1t9v0tphksthdp1fnr0berrm7i2p.apps.googleusercontent.com',
    ),
  ]);

  // Lock orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Error occurred: ${snapshot.error}',
                ),
              ),
            ),
          );
        }
        final prefs = snapshot.data!;
        return ChangeNotifierProvider(
          create: (context) => AppThemeProvider(),
          lazy: false,
          builder: (context, _) => BetaBooks(prefs: prefs),
        );
      },
    ),
  );
}

class BetaBooks extends StatefulWidget {
  final SharedPreferences prefs;

  const BetaBooks({Key? key, required this.prefs}) : super(key: key);

  @override
  State<BetaBooks> createState() => _BetaBooksState();
}

class _BetaBooksState extends State<BetaBooks> {
  List<Book> books = [];
  CSVController controller = CSVController();

  @override
  void initState() {
    super.initState();
    initThemeProvider(context, widget.prefs);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(
                    '${snapshot.error} occurred',
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            books = snapshot.data as List<Book>;

            return BooksData(
              books: books,
              childWidget: MaterialApp(
                title: "BetaBooks",
                theme: ThemeData(
                  primarySwatch: Colors.deepPurple,
                ),
                themeMode: context.watch<AppThemeProvider>().isDarkMode
                    ? ThemeMode.dark
                    : ThemeMode.light,
                darkTheme: ThemeData(brightness: Brightness.dark),
                initialRoute: FirebaseAuth.instance.currentUser == null
                    ? signin
                    : home,
                onGenerateRoute: RouteNavigator.generateRoute,
              ),
            );
          }
        }
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      future: controller.loadCSV(),
    );
  }

  Future<void> initThemeProvider(BuildContext context, SharedPreferences prefs) async {
    await Provider.of<AppThemeProvider>(context, listen: false).init(prefs);
  }
}
