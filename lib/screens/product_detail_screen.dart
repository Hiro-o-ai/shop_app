import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ()にすると必ずそこに定義した分の引数を求められるが、
  // ({})にした場合は@requierdがついていないものについては、引数を代入しなくても問題ない
  // ProductDetailScreen(this.title, this.price);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
