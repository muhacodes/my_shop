import 'package:flutter/material.dart';
import '../provider/orders.dart' as orderModel;
import 'dart:math';

class OrderItem extends StatefulWidget {

  final orderModel.OrderItem order;

  OrderItem({
    required this.order,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: _expanded? min(widget.order.products.length * 20 + 150, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(widget.order.datetime.toString()),
              trailing: IconButton(
                icon: Icon(_expanded? Icons.expand_less: Icons.expand_more),
                onPressed: (){
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
              AnimatedContainer(
                padding: const EdgeInsets.all(10),
                height: _expanded ? min(widget.order.products.length * 20 + 20, 140) : 0,
                duration: const Duration(milliseconds: 200),
                child: ListView(children: widget.order.products.map((product) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text('${product.quantity} x \$${product.price}')
                  ],
                )).toList(),),
              )

          ],
        ),
      ),
    );
  }
}
