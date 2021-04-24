import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  // formの内容を保存するためにしよう
  // <>にはformstateを入れる
  // formwidgetとの関わりを作れるようになる
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    // ()ないのfunctionを、_imageURLFocusNodeの動作に合わせて発火させる
    _imageURLFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    // initStateのものを取り除くやつ
    _imageURLFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    // これでsave()メソッドが起動しない
    if (isValid) {
      return;
    }
    _form.currentState.save();
    // チェック用
    // print(_editedProduct.title);
    // print(_editedProduct.price);
    // print(_editedProduct.description);
    // print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                // decorationのInputDecorationのプロパティにエラーメッセージのfontsizeなどを変えるものがある
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                // requestFocusで指定しているFocusNodeにキーボードの決定ボタンを押すと飛ぶようになる
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  // inputに問題がないとなるので、エラーが生じない
                  // return null;
                  // 下記の場合は文面がエラー文となり常にエラーとなる
                  // return 'This is wrong';
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null,
                      title: value,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                // TextFromFieldが持つFocusNodeを指定できる
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                // valueは常にstringなので注意
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: value,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
                focusNode: _descriptionFocusNode,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageURLController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageURLController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  // expandedはwidthに関わるエラーは改善できるが、heightは厳しい
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageURLController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      focusNode: _imageURLFocusNode,
                      // onFieldSubmittedはFunction(String)を必要としているが、_saveFormはそうではないので、onFieldSubmitted: _saveFormができない
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: null,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
