import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loja_ii__flutter/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget(this.cartItem, {Key? key}) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Text(cartItem.name);
  }
}
