import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/data/dummy_data.dart';
import 'package:loja_ii__flutter/models/product.dart';

class ProductsOverviewPages extends StatelessWidget {
  ProductsOverviewPages();

  final List<Product> loadedProducts = dummyProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: loadedProducts.length,
          itemBuilder: (ctx, i) => Text(loadedProducts[i].title),
          // Area dentro de algo que é scrollble/rolavel
          // Com a qtd de itens fixos no eixo cruzado
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            // DOis produtos por linha
            crossAxisCount: 2,
            // Relacao de altura e largura
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        ),
      ),
    );
  }
}
