import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

// withとextendの大きな違いは自分が定義したものに持ってきたクラスのプロパティやメソッドを加える点
class Products with ChangeNotifier {
  // 直接アクセスさせない変数なので_を使用している→プライベートプロパティ
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((producItem) => producItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((producItem) => producItem.isFavorite).toList();
  }

  // データの型はreturnされるデータの型だからProductでOK
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // この方法によるお気に入りのみの表示法では新しいスクリーン(商品一覧したいなど)も全てお気に入りのみの表示となる
  // 全体で適用したい場合をのぞき、この方法は推奨されない
  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    // urlを実行してから変換するのでconstは使用できない
    final url =
        Uri.https('test-ed3c8-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        // insertメソッドでも大丈夫
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // asyncをつけると全てがfutureのreturnとなる→thenを使用しなくともよくなる　自動的に上から順に実行される
  Future<void> addProduct(Product product) async {
    final url =
        Uri.https('test-ed3c8-default-rtdb.firebaseio.com', '/products.json');
    // var response = await
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      // .catchError((error){})といったこともできる
      // これは一文のみにエラーが考えられる場合はtry..catchよりも有用である
      // .then((response) {
      // print(json.decode(response.body));
      // printの結果:{name: firebaseが生成したID}
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      // _items.insert(0, newProduct);  start of the list
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    // }).catchError((error) {
    // print(error);
    // throwしないとaddProductで.catcherrorが使えない
    // throw (error);
    // });
    // 下記のようにすると先にreturnが実行されるので、むり
    // return Future.value();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https(
          'test-ed3c8-default-rtdb.firebaseio.com', '/products/$id.json');
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    final url = Uri.https(
        'test-ed3c8-default-rtdb.firebaseio.com', '/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var exisitingProduct = _items[existingProductIndex];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    http.delete(url).then((response) {
      // もしdeleteを行った際にサーバー側の問題などでDBのデータが削除されなかった場合はstatusCodeで400などが
      // 返ってくるだけで、エラーにはならない。そのため下記のようにこちら側でエラーを発生させる
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete product.');
      }
      exisitingProduct = null;
    }).catchError((_) {
      _items.insert(existingProductIndex, exisitingProduct);
      notifyListeners();
    });
  }
}
