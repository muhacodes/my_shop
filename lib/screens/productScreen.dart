import 'package:flutter/material.dart';
import 'package:my_shop/provider/cart.dart';
import 'package:my_shop/provider/products.dart';
import 'package:my_shop/screens/cart.dart';
import 'package:provider/provider.dart';
import '../widget/drawer.dart';
import '../widget/productGrid.dart';
import '../provider/products.dart';
import '../widget/badge.dart';

enum filterOptions  {
  all,favorite
}

class ProductScreen extends StatefulWidget {

  var showFavorite = false;
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  var isLoading = false;
  var empty = false;
  void fetch() async{
    setState(() {
      isLoading = true;
    });

    final products = Provider.of<Products>(context, listen: false);
    if(!products.fetched){
      await products.getProducts();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ukash Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (filterOptions value) {
              setState(() {
                if(value == filterOptions.favorite){
                  widget.showFavorite = true;
                }else{
                  widget.showFavorite = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(value: filterOptions.favorite,child: Text('Favorites'),),
              const PopupMenuItem(value: filterOptions.all,child: Text('All'),),

            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
                color: Colors.blue,
                value: cart.itemCount.toString(),
                child: const IconCart(),
              ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading? const Center(child: CircularProgressIndicator(),) : productGrid(widget.showFavorite),
    );
  }
}
class IconCart extends StatelessWidget {
  const IconCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_cart),
      onPressed: (){
        Navigator.of(context).pushNamed(CartScreen.routeName);
      },
    );
  }
}


