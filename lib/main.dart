import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // .valueは同じオブジェクトを再利用する場合(このアプリのproducts_grid)には適しているが、
    // main.dartには無駄な処理を含むので、create:(ctx) => Products()
    // createは新しいインスタンスを作成していることを認識すること
    return ChangeNotifierProvider.value(
      // create:(_)=>と等価の方法、ChangeNotifierProviderに.valueをつけることを忘れずに
      value: Products(),
      // このcreateにはctxがなくても問題はないので(_)でも構わない
      // create: (ctx) => Products(),
      child: MaterialApp(
        title: 'Myshop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
