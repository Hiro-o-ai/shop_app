import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    // productItemはproductsのlength分widgetが作成されており、かくproductItemの上位にあるChangeNotifier<Product>は別物となっている
    // だからproductから引っ張ってこれるデータも異なる
    // comsumerをreturnの後に持ってきた場合は下のコードをコメントアウトできる
    final product = Provider.of<Product>(context);
    // consumerにdataのタイプを明示しないといけない、そして、それはプロバイダーでないといけない
    // こうすることで上位にプロバイダーwidgetを持つのと近い意味になる
    // consumerを使用するメリットはconsumerのbuilder:widgetのみがrebuild対象となるので、widgetの一部のみを対象にするなどができるようになる
    // return Consumer<Product>(
    // builder: (context, value, child) となっており,valueはProductのインスタンス(Provider.of<Product>(context);)となっている
    // childは => 以下のことを指す
    // builder: (context, product, child) =>
    // listen falseなのはこの画面ではItemをCartに加えるが、そのことによってこの画面をrebuildさせる必要がないため
    final cart = Provider.of<Cart>(context, listen: false);
    // 使い方：角を丸くするなどをさせたい場合にClipRRectでwrapする
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // これでfavoriteButtonのみがrebuidされる
          leading: Consumer<Product>(
            // おそらくConsumerのchild:のwidgetはrebuildされない
            builder: (context, product, child) => IconButton(
              // この中ではchildという単語の使用ができない
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                product.id,
                product.price,
                product.title,
              );
              // snackBarは現在のsnackbarがtimeoutするまでは次が表示されないので、その対策
              // Scaffold.of(context).hideCurrentSnackBar();
              // flutter2からは下記が推奨されている
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              // 同じwidgettree内(同じファイル)にScaffoldが2つあると機能しなくなるので注意
              // Scaffold.of(context).openDrawer();でproducts_overviewで使用しているwidgetを使うこともできる！！
              // Scaffold.of(context).showSnackBar(
              // flutter2からは下記が推奨されている
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                    // textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
