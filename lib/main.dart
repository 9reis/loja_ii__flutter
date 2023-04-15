import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/models/cart.dart';
import 'package:loja_ii__flutter/models/order_list.dart';
import 'package:loja_ii__flutter/models/product_list.dart';
import 'package:loja_ii__flutter/pages/cart_page.dart';
import 'package:loja_ii__flutter/pages/counter_page.dart';
import 'package:loja_ii__flutter/pages/product_detail_page.dart';
import 'package:loja_ii__flutter/pages/products_overview_page.dart';
import 'package:loja_ii__flutter/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewPages(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
          AppRoutes.CART: (ctx) => CartPage(),
        },
      ),
    );
  }
}
