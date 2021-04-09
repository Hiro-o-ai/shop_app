import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
// import '../providers/cart.dart' show Cart;
// providers/cart.dartとclass名が被っているので、エラーとる。その解消としてas（下）かshow（上）を使う
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // .spaceBetweenなどをした際にwidget同士の感覚を最大にしたい場合に使用する
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      cart.clear();
                    },
                    child: Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              // importでas ciとしたのでci.CartItemとなっている
              itemBuilder: (ctx, i) => ci.CartItem(
                // cart.itemsはMapとして定義されているのでcart.items[i]ではできない
                // だから一度リスト化する必要がある
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
