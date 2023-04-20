// Define se vai para tela de autenticação
// Ou se vai para tela inicial da aplicação

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loja_ii__flutter/models/auth.dart';
import 'package:loja_ii__flutter/pages/auth_page.dart';
import 'package:loja_ii__flutter/pages/products_overview_page.dart';
import 'package:provider/provider.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Entrou no center');
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return auth.isAuth ? ProductsOverviewPages() : AuthPage();
        }
      },
    );
  }
}
