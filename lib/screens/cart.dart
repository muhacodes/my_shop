import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../widget/cartitem.dart';
import '../provider/orders.dart';
import 'package:provider/provider.dart';


class CartScreen extends StatefulWidget {

  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Your Cart'),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20,),
          Expanded(
            flex: 5,
            child: ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (ctx, index) => cartItem(
              id: cart.items.values.toList()[index].id,
              title: cart.items.values.toList()[index].title,
              price: cart.items.values.toList()[index].price,
              quantity: cart.items.values.toList()[index].quantity,
            ),
          ),
          ),

          const Spacer(),
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  const Text('Total', style: TextStyle(
                    fontSize: 20,

                  ),),
                  const SizedBox(width: 10,),
                  Chip(
                    label: Text(
                      "\$ ${cart.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Theme.of(context).canvasColor
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),

                ],
              ),
            ),
          ),
          OrderButton(cart: cart,),


        ],

      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton({Key? key, required this.cart}) : super(key: key);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
      ),

      onPressed: (widget.cart.totalAmount <= 0 || _isLoading) ? null :  () async{
        setState(() {
          _isLoading = true;
        });
        final code = await Provider.of<Orders>(context, listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
        if(code == 200){
          setState(() {
            _isLoading = false;
          });
          widget.cart.Clear();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Something went Wrong!'),
                backgroundColor: Colors.red,
                duration: Duration(milliseconds: 1500),
                padding: EdgeInsets.all(10),
              )
          );
        }
      },
      child: _isLoading? const CircularProgressIndicator(backgroundColor: Colors.yellowAccent,) : const Text('ORDER NOW', style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),),
    );
  }
}
