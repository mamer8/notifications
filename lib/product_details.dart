import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen
({super.key, required this.id});
 final String id;
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details screen'),
      ),
      body: Center(
        child: Text(
          'the product id is $id',
        ),
      ),
    );
  }
}