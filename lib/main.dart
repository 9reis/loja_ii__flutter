import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/pages/counter_page.dart';
import 'package:loja_ii__flutter/pages/product_detail_page.dart';
import 'package:loja_ii__flutter/pages/products_overview_page.dart';
import 'package:loja_ii__flutter/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        // AppRoutes.PRODUCT_DETAIL: (ctx) => CounterPage(),
      },
    );
  }
}
