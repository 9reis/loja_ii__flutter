import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loja_ii__flutter/exceptions/http_exception.dart';
import 'package:loja_ii__flutter/models/product.dart';
import 'package:loja_ii__flutter/models/product_list.dart';
import 'package:loja_ii__flutter/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Excluir Produto'),
                    content: Text('Tem certeza?'),
                    actions: [
                      TextButton(
                        child: Text('Não'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      TextButton(
                          child: Text('Sim'),
                          onPressed: () async {
                            try {
                              await Provider.of<ProductList>(
                                context,
                                listen: false,
                              ).removeProduct(product);
                              // Trata apenas HttpException
                            } on HttpException catch (error) {
                              msg.showSnackBar(
                                SnackBar(
                                  content: Text(error.toString()),
                                ),
                              );
                            }
                            Navigator.of(ctx).pop(true);
                          }),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
