import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/models/product.dart';
import 'package:loja_ii__flutter/models/product_list.dart';
import 'package:provider/provider.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      // Se o arg não for null
      // é a tela de edição
      if (arg != null) {
        final product = arg as Product;

        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
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

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidUrl && endWithFile;
  }

  void _submitForm() {
    final _isValid = _formKey.currentState?.validate() ?? false;

    if (!_isValid) {
      return;
    }

    _formKey.currentState?.save();
    // Fora do build, é necessario que o provider tenha o listen: false
    Provider.of<ProductList>(
      context,
      listen: false,
    ).saveProduct(_formData);
    // Vai para tela anterior após salvar o item
    Navigator.of(context).pop();
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
                // Carrega a tela de edição com o valor salvo
                initialValue: _formData['name']?.toString(),
                decoration: InputDecoration(labelText: 'Nome'),
                // Vai para o px input
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (_name) {
                  // Garante que a String está sempre presente
                  final name = _name ?? '';

                  if (name.trim().isEmpty) {
                    return 'O nome é obrigatório';
                  }

                  if (name.trim().length < 3) {
                    return 'O nome precisa no minimo de 3 letras';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price']?.toString(),
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (price) =>
                    _formData['price'] = double.parse(price ?? '0'),
                validator: (_price) {
                  final priceString = _price ?? '';
                  final price = double.tryParse(priceString) ?? -1;

                  if (price <= 0) {
                    return 'Informe um preço valido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['description']?.toString(),
                decoration: InputDecoration(labelText: 'Descrição'),
                // Vai para o px input
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
                validator: (_descricao) {
                  // Garante que a String está sempre presente
                  final descricao = _descricao ?? '';

                  if (descricao.trim().isEmpty) {
                    return 'A descricao é obrigatória';
                  }

                  if (descricao.trim().length < 10) {
                    return 'A descricao precisa no minimo de 10 letras';
                  }
                  return null;
                },
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
                      validator: (_imageUrl) {
                        final imageUrl = _imageUrl ?? '';

                        if (!isValidImageUrl(imageUrl)) {
                          return 'Informe uma Url valida!';
                        }
                        return null;
                      },
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
                        : Image.network(_imageUrlController.text),
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
