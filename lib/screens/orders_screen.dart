import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// showは特定のクラスのみ使用
// asはそのクラスを別名で表示
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      // ListViewには.builderとchildrenの二つの方法がある
      body: ListView.builder(
        itemCount: orderData.orders.length,
        // (){}と() =>はかなり違う、下のコードでこの違いによりOrderItemが表示されなかった
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}
