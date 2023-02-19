import 'package:flutter/material.dart';
import './provider/auth.dart';
import 'package:my_shop/screens/ManageProducts.dart';
import 'package:my_shop/screens/addProductScreen.dart';
import 'screens/cart.dart';
import 'package:my_shop/screens/productDetailScreen.dart';
import 'package:provider/provider.dart';
import 'utils/routes.dart';
import 'screens/productScreen.dart';
import 'provider/products.dart';
import 'provider/cart.dart';
import './provider/orders.dart';
import './screens/ordersScreen.dart';
import './screens/auth_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, products) => Products(auth.token?? '', auth.userId?? '',  products?.items?? []),
          create: (_) => Products('', '',  []),
        ),

        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),

        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, orders) => Orders(auth.token?? '', auth.userId?? '', orders?.items?? []),
          create: (_) => Orders('', '', []),
        ),

      ],
      // value: Products(),
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductScreen()
              : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState ==
                ConnectionState.waiting
                ? const Center(child: Text('Logging in'))
                : AuthScreen(),
          ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            ManageProducts.routeName: (ctx) => ManageProducts(),
            AddProducts.routeName: (ctx) => const AddProducts(),
          },
        ),
      ),
    );
  }
}

//ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
//             CartScreen.routeName : (ctx) => CartScreen(),
//             OrdersScreen.routeName: (ctx) => OrdersScreen(),
//             ManageProducts.routeName: (ctx) => ManageProducts(),
//             AddProducts.routeName : (ctx) => const AddProducts(),
