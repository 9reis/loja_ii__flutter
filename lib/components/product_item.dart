import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/models/product.dart';

import 'package:loja_ii__flutter/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,
        // Indica que está monitorando as modificações
        // FALSE == não deseja monitorar as modificações
        // Não vai refletir na UI as modificações
        // Utilizado em partes da UI que possuem dados imultaves(final)
        // Tudo que está fora do consumer não vai ser notificado
        listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // ignore: sort_child_properties_last
        child: GestureDetector(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black45,
          // Monitora um ponto especifico que haverá modificação
          leading: Consumer<Product>(
            // o terceiro param '_' é um child
            // Trecho da UI que nunca vai ser modificado
            // child: Column(children: [
            //   Text('Algo que nunca muda #1'),
            //   Text('Algo que nunca muda #2'),
            //   Text('Algo que nunca muda #3'),
            // ]),
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                product.toggleFavorite();
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
