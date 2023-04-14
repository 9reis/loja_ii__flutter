import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage();

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
    );
  }
}
