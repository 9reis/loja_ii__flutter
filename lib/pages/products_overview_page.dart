import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/components/product_grid.dart';

class ProductsOverviewPages extends StatelessWidget {
  ProductsOverviewPages();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        centerTitle: true,
      ),
      body: ProductGrid(),
    );
  }
}
