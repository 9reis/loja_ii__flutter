import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/components/product_grid.dart';

enum FilterOptions { Favotite, All }

class ProductsOverviewPages extends StatefulWidget {
  ProductsOverviewPages();

  @override
  State<ProductsOverviewPages> createState() => _ProductsOverviewPagesState();
}

class _ProductsOverviewPagesState extends State<ProductsOverviewPages> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
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
              setState(() {
                if (selectedValue == FilterOptions.Favotite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
        ],
      ),
      body: ProductGrid(_showFavoriteOnly),
    );
  }
}
