import 'package:flutter/material.dart';
import 'package:my_shop/provider/product.dart';
import 'package:my_shop/provider/products.dart';
import 'package:provider/provider.dart';

class AddProducts extends StatefulWidget {
  static const routeName  = 'add/products';

  const AddProducts({Key? key}) : super(key: key);

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _focus = FocusNode();
  final description_focus = FocusNode();

  final _imageUrlController = TextEditingController();
  final imageUrlFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var isInit = true;
  var loading = false;
  var  _initValues = {
    'id': '',
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var  _editedProduct = Product(
      id: null.toString(),
      title: '',
      description: '',
      price: 0,
      imageUrl: '',
  );

  @override
  void dispose() {
    _focus.dispose();
    imageUrlFocusNode.removeListener(updateImageUrl);
    description_focus.dispose();
    _imageUrlController.dispose();
    imageUrlFocusNode.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    if(isInit){

      final productId = ModalRoute.of(context)?.settings.arguments;
      if(productId != null){
        _editedProduct = Provider.of<Products>(context, listen: false).getProduct(productId);
        _initValues  = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price' : _editedProduct.price.toString(),
          'imageUrl' : _editedProduct.imageUrl
        };
        _imageUrlController.text = _editedProduct.imageUrl;

      }

    }

    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  void updateImageUrl(){
    if(!imageUrlFocusNode.hasFocus){
      final url = _imageUrlController.text;
      if(!url.startsWith('http') || !url.startsWith('https')){
        return;
      }
      setState(() {

      });
    }
  }
  void _saveForm() async {
    setState(() {
      loading = true;
    });
    var isValid = _form.currentState?.validate();
    if(isValid != null && !isValid){
      return;
    }
    _form.currentState!.save();
    if(_editedProduct.id.toString()  != "null"){
       await Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
    }else{
       await Provider.of<Products>(context, listen: false).addProducts(_editedProduct);
    }

    setState(() {
      loading = false;
    });
    Navigator.of(context).pop();
    // print('form is valid');
    // _form.currentState?.save();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),

      body: Form(
        key: _form,
        child: loading ? const Center(child: CircularProgressIndicator()) :SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title'
              ),
              initialValue: _initValues['title'],
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_){
                FocusScope.of(context).requestFocus(_focus);
              },
              onSaved: (value){
                _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value.toString(),
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite
                );
              },
              validator: (value){
                if(value.toString().isEmpty){
                  return "This Field cannot be empty!";
                }
              },
            ), const SizedBox(height: 10,),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text('Price')
              ),
              initialValue: _initValues['price'],
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _focus,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(description_focus);
                },
              onSaved: (value){
                _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value!),
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite
                );
              },
              validator: (value){
                // if(value!.isNotEmpty && double.tryParse(value) == null && double.parse(value) > 1){
                //   return "Please enter value greater than 1";
                // }
                if(value!.isEmpty){
                  return "Please Enter a Value";
                }
                if(double.tryParse(value) == null){
                  return "Please try a valid number";
                }
                if(double.parse(value) <= 0){
                  return "Please enter number greater than 0";
                }
                return null;
              },
            ),

            const SizedBox(height: 10,),

            TextFormField(
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
              decoration: const InputDecoration(
                  label: Text('Description')
              ),
              maxLines: 3,
              initialValue: _initValues['description'],
              keyboardType: TextInputType.multiline,
              focusNode: description_focus,
              onSaved: (value){
                _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value.toString(),
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite
                );
              },
              validator: (value){
                if(value!.isEmpty){
                  return "Please Enter value ";
                }
                if(value.length < 10){
                  return "Value should be longer than 10 characters";
                }
                return null;
              },
            ),
            const SizedBox(height: 10,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(top: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1
                  )
                ),
                child: _imageUrlController.text.isEmpty ? const Center(child: Text('enter a Url')) : FittedBox(
                  fit: BoxFit.contain,
                  child: Image.network(_imageUrlController.text),
                ),
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Image Url'),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                  focusNode: imageUrlFocusNode,
                  onFieldSubmitted: (_){
                    _saveForm();
                  },
                  onSaved: (value){
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: value!,
                        isFavorite: _editedProduct.isFavorite
                    );
                  },
                  validator: (value){
                    if(value!.isEmpty || (!value.startsWith('https') || !value.startsWith('http'))){
                      return 'Please provide correct Url';
                    }
                    return null;
                  },
                ),
              )
            ],)
          ]),
        ),
      ),
    );
  }
}
