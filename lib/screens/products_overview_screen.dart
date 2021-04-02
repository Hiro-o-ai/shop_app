import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/products.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // boolは型に対する注釈、varは型推論で型が決まる
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          // ボタン付近にメニューを表示する
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                // if (selectedValue == FilterOptions.Favorites) {
                // productsContainer.showFavoritesOnly();
                // } else {
                // productsContainer.showAll();
                // }
                setState(
                  () {
                    if (selectedValue == FilterOptions.Favorites) {
                      _showOnlyFavorites = true;
                    } else {
                      _showOnlyFavorites = false;
                    }
                  },
                );
              },
              icon: Icon(
                // 三点リーダー的なメニューのやつ
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
