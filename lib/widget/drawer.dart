import 'package:flutter/material.dart';
import 'package:my_shop/screens/ManageProducts.dart';
import '../screens/ordersScreen.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';

class AppDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Column(
        children: [
          AppBar(
            title: const Text('Settings'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            // onTap: () => Scaffold.of(context).closeDrawer(),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Manage Products'),
            // onTap: () => Scaffold.of(context).closeDrawer(),
            onTap: () => Navigator.of(context).pushReplacementNamed(ManageProducts.routeName),
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: (){
              // Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },

          ),
        ],
      ),
    );
  }
}
