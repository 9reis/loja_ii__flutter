import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/models/auth.dart';
import 'package:loja_ii__flutter/models/cart.dart';
import 'package:loja_ii__flutter/models/order_list.dart';
import 'package:loja_ii__flutter/models/product_list.dart';
import 'package:loja_ii__flutter/pages/auth_or_home_page.dart';
import 'package:loja_ii__flutter/pages/auth_page.dart';
import 'package:loja_ii__flutter/pages/cart_page.dart';
import 'package:loja_ii__flutter/pages/counter_page.dart';
import 'package:loja_ii__flutter/pages/orders_page.dart';
import 'package:loja_ii__flutter/pages/product_detail_page.dart';
import 'package:loja_ii__flutter/pages/product_form_page.dart';
import 'package:loja_ii__flutter/pages/products_overview_page.dart';
import 'package:loja_ii__flutter/pages/products_page.dart';
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
        // COMUNICAÇAO ENTRE DOIS PROVIDERS
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        // UItilizado quando um proverder depende de outro
        // O provider no qual depende,
        // deve estar em 1º na lista de providers
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList('', []),
          // Para não perder os itens carregados caso o token modifique
          // Para que o acesso do usuario demore mais tempo
          // vesao anterior do ProviderList
          update: (ctx, auth, previous) {
            return ProductList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList('', []),
          update: (ctx, auth, previous) {
            return OrderList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
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
        // home: ProductsOverviewPages(),
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
          AppRoutes.CART: (ctx) => CartPage(),
          AppRoutes.ORDERS: (ctx) => OrdersPage(),
          AppRoutes.PRODUCTS: (ctx) => ProductsPage(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage(),
        },
      ),
    );
  }
}
