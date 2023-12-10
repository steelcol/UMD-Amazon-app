import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}
class _ShoppingPageState extends State<ShoppingPage> {
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaBooks"),
      ),      
    );
  }
}
