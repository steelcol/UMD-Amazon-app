import 'package:flutter/material.dart';
import 'package:beta_books/models/book_model.dart';
import 'package:beta_books/routing/routes.dart';
import 'package:beta_books/controllers/csv_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Book> books = [];
  CSVController controller = CSVController();


  @override
  void initState() {
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

            return Scaffold(
              appBar: AppBar(
                title: const Text("BetaBooks"),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, profile),
                    icon: const Icon(Icons.account_circle_sharp),
                  ),
                ],
              ),
              body: Center(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),  
                  itemCount: books.length,
                  itemBuilder: (context, index) => _buildBookCard(index),
                )
              ),
            );
          }
        }
        
        // Loading
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      future: controller.loadCSV(),
    );  
  }

  Widget _buildBookCard(int index) {  
    return SizedBox(
      height: books[index].title != null && books[index].title!.length > 50
      ? MediaQuery.of(context).size.height/6
      : MediaQuery.of(context).size.height/8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: Text(
                books[index].title ?? 'Not provided',
                style: const TextStyle(
                  fontSize: 13
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: Text(
                books[index].author ?? 'Not provided',
                style: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              child: Text(
                books[index].price ?? 'Not provided',
                style: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

