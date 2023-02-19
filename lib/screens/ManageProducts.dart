import 'package:flutter/material.dart';
import 'package:my_shop/screens/addProductScreen.dart';
import 'package:my_shop/widget/drawer.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class ManageProducts extends StatefulWidget {

  static const routeName = 'manage/products';

  @override
  State<ManageProducts> createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  fetchData(BuildContext context) async{
    // setState(() {
    //   isLoading = true;
    // });
    await Provider.of<Products>(context, listen: false).getProducts(true) ;
    // setState(() {
    //   isLoading = false;
    // });
  }
  var isLoading = false;
  @override
  void initState(){

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Products>(context);
    // var _isLoading = false;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Manage Products!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(AddProducts.routeName);
            },
          )
        ],
      ),

      body: FutureBuilder(
        future: fetchData(context),
        builder: (ctx, product) =>
        product.connectionState == ConnectionState.waiting? const Center(child: CircularProgressIndicator(color: Colors.green),) : RefreshIndicator(
          onRefresh: () => fetchData(context),
          color: Colors.green,
          child: Consumer<Products>(
            builder: (ctx, product, _) => Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: product.items.length,
                itemBuilder: (ctx, index) => Column(
                  children: [
                    ListTile(
                      title: Text(product.items[index].title),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(product.items[index].imageUrl),
                      ),
                      trailing: Container(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.indigo,),
                              onPressed: (){
                                Navigator.of(context).pushNamed(AddProducts.routeName,arguments: product.items[index].id);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed:  () async {
                                setState(() {
                                  // _isLoading = true;
                                });
                                bool confirm =  await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Are You Sure?'),
                                      content: const Text('Do you want to delete this item?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: (){
                                            Navigator.of(ctx).pop(true);
                                          },
                                          child: const Text('Confirm'),
                                        ),
                                        ElevatedButton(
                                          onPressed: (){
                                            Navigator.of(ctx).pop(false);
                                          },
                                          child: const Text('Cancel'),
                                        )
                                      ],
                                    )
                                );
                                if(confirm == true) {
                                  try{
                                    await Provider.of<Products>(context, listen: false).deleteProduct(product.items[index].id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Product Deleted Successfully !'),
                                          duration: Duration(seconds: 1),
                                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                          elevation: 1,

                                          backgroundColor: Colors.green,
                                        )
                                    );
                                  }catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Deleting Product Failed!'),
                                          duration: Duration(seconds: 1),
                                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                          elevation: 1,
                                          backgroundColor: Colors.red,
                                        )
                                    );
                                    // Scaffold.of(context).showSnackBar(const SnackBar(content: Text('Deleting Product Failed')));
                                  }
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          )
        ),
      )
    );
  }
}

