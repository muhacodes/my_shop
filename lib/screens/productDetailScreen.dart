import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
class ProductDetailScreen extends StatelessWidget {
  // final String title;

  static const routeName = 'product/details';

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProducts = Provider.of<Products>(context).getProduct(id);
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProducts.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProducts.title),
              background: Hero(
                  tag: loadedProducts.id,
                  child: Image.network(loadedProducts.imageUrl, fit: BoxFit.cover,)),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10,),
              Card(
                color: Colors.white,
                elevation: 2,
                child: ListTile(
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loadedProducts.title),
                      Text(
                          loadedProducts.description.length > 50
                          ? loadedProducts.description.substring(0,45)
                          : loadedProducts.description
                      ),

                    ],
                  ),
                  trailing: Text("\$${loadedProducts.price}", style: const TextStyle(fontSize: 20),),
                ),
              ),
              const SizedBox(height: 900,),
            ]),
          ),
        ],
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Center(
        //       child: Container(
        //         height: screen.height * 0.3,
        //         // child: Hero(
        //         //   tag: loadedProducts.id,
        //         //     child: Image.network(loadedProducts.imageUrl))
        //       ),
        //     ),
        //     // const SizedBox(height: 10,),
        //     //  Card(
        //     //    color: Colors.white,
        //     //    elevation: 2,
        //     //   child: ListTile(
        //     //     leading: Column(
        //     //       crossAxisAlignment: CrossAxisAlignment.start,
        //     //       children: [
        //     //         Text(loadedProducts.title),
        //     //         Text(
        //     //             loadedProducts.description.length > 100 ?
        //     //             loadedProducts.description.substring(0,100):
        //     //             loadedProducts.description
        //     //         ),
        //     //
        //     //       ],
        //     //     ),
        //     //     trailing: Text("\$${loadedProducts.price}", style: const TextStyle(fontSize: 20),),
        //     //   ),
        //     // ),
        //
        //
        //
        //   ],
        //
        // ),
      ),
    );
  }
}
