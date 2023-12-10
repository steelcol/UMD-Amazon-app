import 'package:beta_books/controllers/shopping_controller.dart';
import 'package:beta_books/models/shopping_book_model.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}
class _ShoppingPageState extends State<ShoppingPage> {
  final ShoppingController _controller = ShoppingController();

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaBooks"),
      ),
      body: FutureBuilder(
        future: _controller.getShoppingCart(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                ),
              );
            }
            else if (snapshot.hasData) {
              _controller.shoppingList = snapshot.data as List<ShoppingBook>;
              return Center(
                child: ListView.builder(
                  itemCount: _controller.shoppingList.length,
                  itemBuilder: (context, index) => _buildBookCard(index),
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }

  Widget _buildBookCard(int index) {

    ShoppingBook book = _controller.shoppingList[index];

    return SizedBox(
      height: book.title != null && book.title!.length > 50
      ? MediaQuery.of(context).size.height/6
      : MediaQuery.of(context).size.height/8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  child: Text(
                    book.title ?? 'Not provided',
                    style: const TextStyle(
                      fontSize: 13
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  child: Text(
                    book.isbn13 ?? 'Not provided',
                    style: const TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  child: Text(
                    book.price != null
                    ? '\$${book.price}'
                    : 'Not provided',
                    style: const TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                _controller.removeBookFromShoppingCart(index);
                setState(() {});
              },
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
