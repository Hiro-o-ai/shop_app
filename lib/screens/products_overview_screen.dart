import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

// import '../providers/products.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import './cart_screen.dart';

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
  var _isInit = true;

  // このwidgetが作成されたときのみ起動するので商品データをfirebaseから持ってくるのにぴったり
  @override
  void initState() {
    // contextはStateの中ならどこでも使えるよ
    // このままではエラーが発生するよ、contextのあたりが原因で
    // でもlisten falseにすることで回避できるよ
    // おそらくState classができる前にproviderのwidgetがinherited widgetとして動いてしまうことが原因？
    Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    // listen falseにしないときの回避策その１?→やっぱりできないwww
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  // listen falseにしないときの回避策その2
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     Provider.of<Products>(context).fetchAndSetProducts();
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

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
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              // builderのchildはConsumerのchild:に等しい
              // そしてchはrebuildされない
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
