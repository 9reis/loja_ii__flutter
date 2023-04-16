import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/components/product_grid_item.dart';
import 'package:loja_ii__flutter/models/product.dart';
import 'package:loja_ii__flutter/models/product_list.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i], //[1]
        // Não é necessario passar o produto pelo construtor
        // Vai estar recebendo a partir do provider [1]
        child: ProductGridItem(),
      ),
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
    );
  }
}
