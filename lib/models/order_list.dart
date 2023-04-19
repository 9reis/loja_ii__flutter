// Gerencia todos os pedidos
// Gera um notificação sempre que houver mudança

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loja_ii__flutter/models/cart.dart';
import 'package:loja_ii__flutter/models/cart_item.dart';
import 'package:loja_ii__flutter/models/order.dart';
import 'package:loja_ii__flutter/utils/constants.dart';

class OrderList with ChangeNotifier {
  OrderList(this._token, this._items);

  final String _token;

  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> items = [];

    final res = await http.get(
      Uri.parse('${Constants.ORDER_BASE_URL}.json?auth=$_token'),
    );
    // Só é possivel pegar a resposta pois está em um met async

    Map<String, dynamic> data = jsonDecode(res.body);

    data.forEach((orderId, orderData) {
      items.add(
        Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              productId: item['productId'],
              name: item['name'],
              quantity: item['quantity'],
              price: item['price'],
            );
          }).toList(),
        ),
      );
    });
    _items = items.reversed.toList();
    
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final res = await http.post(
      // Recebe a coleção que deseja armazenar os dados
      Uri.parse('${Constants.ORDER_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'name': cartItem.name,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price
                  })
              .toList(),
        },
      ),
    );
    // Pega o id de cada item no banco
    final id = jsonDecode(res.body)['name'];

    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );
    notifyListeners();
  }
}
