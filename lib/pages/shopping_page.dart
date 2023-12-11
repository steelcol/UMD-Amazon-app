import 'package:beta_books/controllers/shopping_controller.dart';
import 'package:beta_books/models/shopping_book_model.dart';
import 'package:beta_books/utilities/shopping_book_sort.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  ShoppingPage({Key? key}) : super(key: key);


  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

  const List<String> sortList = [
    '',
    'Alphabetical',
    'Price',
    'Rating',
    'Review Count'
  ];

class _ShoppingPageState extends State<ShoppingPage> {
  final ShoppingController _controller = ShoppingController();
  String dropdownValue = sortList.first;
  bool _loading = true;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      getShoppingCart();
  }

  void getShoppingCart() async {
    _controller.shoppingList = await _controller.getShoppingCart();
    _loading = false;
    setState(() {});
  }

  void _sort(List<ShoppingBook> bookList, String value) {
    if (bookList.isNotEmpty) {
      final sort = ShoppingBookSort();
      sort.quickSort(bookList, 0, bookList.length - 1, value);
      setState(() {});
    }
  }


  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaBooks"),
      ),
      body: _loading == true 
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: _buildSortBar(),
          ),
          Expanded(
            child: ListView.builder(
            shrinkWrap: true,
            itemCount: _controller.shoppingList.length,
            itemBuilder: (context, index) => _buildBookCard(index),
            ),
          ),
          ElevatedButton(
            onPressed: _controller.shoppingList.isNotEmpty
            ?  () async {
              await _controller.buyBooks();
              setState(() {});
            }
            :  null,
            child: const Text('Buy Books'),
          ),
        ],
      )
    );
  }

  Widget _buildSortBar() {
      return Padding(
        padding: const EdgeInsets.all(9.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColorLight,
              width: .75,
            ) 
          ),
          child: DropdownButtonHideUnderline( 
            child: DropdownButton<String>(
              value: dropdownValue,
              style: TextStyle(
                fontSize: 13, 
                color: Theme.of(context).primaryColorLight, 
                fontWeight: FontWeight.w300
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  _sort(_controller.shoppingList, value);
                });
              },
          
              /// INTERNAL MENU
              items: sortList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 13, color: Theme.of(context).primaryColorLight),
                  ),
                );
              }).toList(), 
            ),
          ),
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
            SizedBox(
              width: MediaQuery.of(context).size.width/1.4,
              child: Column(
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
