import 'package:flutter/material.dart';
import 'package:my_shop/provider/product.dart';
import 'package:my_shop/screens/productDetailScreen.dart';
import '../utils/routes.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../provider/auth.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black38,
        title: Text(
          product.title, textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Primary'),
        ),
        leading: Consumer<Product>(
          builder: (context, product, child) => IconButton(
            icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border, color: Theme.of(context).accentColor),
            onPressed: () async{
              final statuscode = await product.toggleFavoriteStatus(auth.token?? '',auth.userId.toString());
              if(statuscode >= 400){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Something went wrong'),
                    duration: Duration(seconds: 1),
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.red,
                  )
                );
              }
            },
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: Theme.of(context).accentColor,
          ),
          onPressed: (){
            cart.addItem(product.id, product.price, product.title);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(milliseconds: 700),
                content: Text('Item added to cart'),
              )
            );

          },
        ),
      ),
      child: GestureDetector(
        onTap: (){
           Navigator.of(context).pushNamed(
             ProductDetailScreen.routeName,
             arguments: product.id
           );
        },
        child: Hero(
            tag: product.id,
            child: Image.network(product.imageUrl, fit: BoxFit.cover)),

      ),

    );
  }
}
