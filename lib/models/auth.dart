import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loja_ii__flutter/data/store.dart';
import 'package:loja_ii__flutter/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  static const _url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';

  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTImer;

  // Verifica se o user está autenticado
  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyBlaZOCjqCP2osqt8Q6rD0v08-sHAvGW1E';

    final res = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    final body = jsonDecode(res.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      // Pega o token
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      //Data de expiracao
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      // Salva os dados depois da auth bem sucedida
      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  // Tenta fazer auto login
  // Met utilizado para fazer o login.
  //Obtendo os dados
  Future<void> tryAutoLogin() async {
    //Se está autenticado
    if (isAuth) return;

    //Pega o userData, se tiver vazio, sai
    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    //Pega a data de expiração
    // Se tiver no passado, o token expirou
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    // Se passar das verificação
    // tenta restaurar os dados
    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    _clearLogoutTimer();
    //Remove os dados do usuário ao clicar em sair.
    Store.remove('userData').then((_) => notifyListeners());
  }

  void _clearLogoutTimer() {
    // Limpa o timer
    _logoutTImer?.cancel();
    _logoutTImer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    // Imprime o tempo que expira o token
    //print(timeToLogout);
    // Seta um timer para acionar o logout
    _logoutTImer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }
}
