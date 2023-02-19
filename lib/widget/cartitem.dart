import 'package:flutter/material.dart';
import '../provider/cart.dart';
import 'package:provider/provider.dart';

class cartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;

  cartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    print(id);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10),
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child:  const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => cart.removeItem(id),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) =>  AlertDialog(
            title: const ListTile(
              leading: Icon(Icons.clear),
              title: Text('Are you Sure'),
            ),
            content: const Text('Do you want to remote this item from the Cart?'),
            actions: [
              FlatButton(
                  child: const Text('Cancel'),
                  onPressed: (){
                    Navigator.of(ctx).pop(false);
                  }
              ),

              FlatButton(
                child: const Text('Confirm'),
                onPressed: (){
                  Navigator.of(ctx).pop(true);
                }
              ),

            ],
          )
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            child: Text(
                "$price"
            ),
          ),
          trailing: Text(
            "${quantity} x",
          ),
          title: Text(
            title
          ),
          subtitle: Text(
            "total : ${price * quantity}"
          ),
        ),
      ),
    );
  }
}

