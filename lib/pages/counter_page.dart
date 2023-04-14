import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/models/product.dart';
import 'package:loja_ii__flutter/providers/counter.dart';

class CounterPage extends StatefulWidget {
  const CounterPage();

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    final provider = CounteProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo Contador'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(provider?.state.value.toString() ?? '0'),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Pega o estado compartilhado
              setState(() {
                provider?.state.inc();
              });
              print(provider?.state.value);
            },
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                provider?.state.dec();
              });
              print(CounteProvider.of(context)?.state.value);
            },
          ),
        ],
      ),
    );
  }
}
