import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loja_ii__flutter/models/product.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    // Sempre que perder o foco ou ganhar o foco
    // vai chamar o met
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  // Para dar um refresh na UI
  void updateImage() {
    setState(() {});
  }

  void _submitForm() {
    _formKey.currentState?.save();
    final newProduct = Product(
      id: Random().nextDouble().toString(),
      name: _formData['name'] as String,
      description: _formData['description'] as String,
      price: _formData['price'] as double,
      imageUrl: _formData['imageUrl'] as String,
    );
    print(newProduct.id);
    print(newProduct.name);
    print(newProduct.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                // Vai para o px input
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (name) => _formData['name'] = name ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (price) =>
                    _formData['price'] = double.parse(price ?? '0'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                // Vai para o px input
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Url da Imagem'),
                      focusNode: _imageUrlFocus,
                      keyboardType: TextInputType.url,
                      // Submete o form ao clicar no enter
                      textInputAction: TextInputAction.done,
                      // Para ter acesso ao valor do texto
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = imageUrl ?? '',
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 10, left: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informa a URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
