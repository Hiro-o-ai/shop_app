import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  // Providerを使用するので不要
  // const ProductsGrid({
  //   Key key,
  //   @required this.loadedProducts,
  // }) : super(key: key);

  // final List<Product> loadedProducts;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      // 各itemを作成するよ
      // 元々はproductsから一つ一つのデータを取り出してbuildしていたよ
      // providerを導入してchangenorifierproviderを各アイテムとして作成するよ、つまりこれ以降の子Widgetでproductsの内容を変更したら全てに反映されるよ
      // changenorifierproviderはpruducts[i]から作るよ
      // その子がproductItemだよ
      // productsはList<Product>つまり、providerがたくさん入ったリストだよ
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        // ProductItemにはproducts[i]の情報のみが提供されているよ
        create: (c) => products[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
