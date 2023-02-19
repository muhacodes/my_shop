import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orders.dart' show Orders;
import '../widget/drawer.dart';
import '../widget/orderItem.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var is_loading = false;
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('build for orderScreen');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders', style: TextStyle(fontSize: 22),),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).getOrders(),
        builder: (ctx, data){
          if(data.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }


          if(data.error == null){
            if(data.data != null){
              return Consumer<Orders>(
                builder: (ctx, data, child) => ListView.builder(
                  itemCount: data.items.length,
                  itemBuilder: (ctx, index) => OrderItem(order: data.items[index]),

                ),
              );
            }else{
              return const Center(child: Text('No Records found!'),);
            }

          }else{
            return const Center(child: Text('No Records found!'),);
          }
        },
      ),
    );
  }
}
//is_loading? const Center(child: CircularProgressIndicator(),) : ListView.builder(
//         itemCount: orders.items.length,
//         itemBuilder: (ctx, index) => OrderItem(order: orders.items[index]),