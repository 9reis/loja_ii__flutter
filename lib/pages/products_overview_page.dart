import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/components/product_grid.dart';
import 'package:loja_ii__flutter/models/product_list.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favotite, All }

class ProductsOverviewPages extends StatelessWidget {
  ProductsOverviewPages();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Somente Favoritos"),
                value: FilterOptions.Favotite,
              ),
              PopupMenuItem(
                child: Text("Todos"),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favotite) {
                provider.showFavoriteOnly();
              } else {
                provider.showAll();
              }
            },
          ),
        ],
      ),
      body: ProductGrid(),
    );
  }
}
