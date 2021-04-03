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
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
