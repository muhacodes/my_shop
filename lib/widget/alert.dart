import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  const Alert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScaffoldMessenger(
      child: Text('something went wrong'),
    );
  }
}
