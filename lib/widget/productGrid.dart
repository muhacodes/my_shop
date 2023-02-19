import 'package:flutter/material.dart';
import 'package:my_shop/provider/products.dart';
import '../provider/product.dart';
import 'product_item.dart';
import '../provider/products.dart';
import 'package:provider/provider.dart';
class productGrid extends StatelessWidget {

  var show_favorite;
  productGrid(this.show_favorite);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = show_favorite? productData.favoriteItems : productData.items;

    return products.isEmpty? const Center(child: Text('There are no Products!'),) : GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        // create: (ctx) => products[index],
        value: products[index],
        child: ProductItem(

        ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
