import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(1, 121, 109, 1),
                Color.fromRGBO(33, 160, 111, 0.9),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: Column(children: []),
        ),
      ],
    ));
  }
}
