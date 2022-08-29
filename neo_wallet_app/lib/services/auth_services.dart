import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neo_wallet/enviroments/variables_enviroments.dart'
    as Enviroments;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:neo_wallet/models/error_response.dart';

import 'package:neo_wallet/models/login_response.dart';
import 'package:neo_wallet/models/usuario.dart';
import 'package:neo_wallet/models/wallets_users_response.dart';
import 'package:neo_wallet/utils/utils.dart';

class AuthService with ChangeNotifier {
  //
  late Usuario _usuario;

  Usuario get usuario {
    this._usuario.name = toCapitalize(this._usuario.name);
    return this._usuario;
  }

  set usuario(Usuario value) => this._usuario = value;

  late List<UserWallet> _userWallets;

  set userWallets(List<UserWallet> value) {
    this._userWallets = value;
    notifyListeners();
  }

  List<UserWallet> get userWallets => this._userWallets;

  bool _authtecating = false;

  bool get autenticando => this._authtecating;

  set autenticando(bool valor) {
    this._authtecating = valor;
    notifyListeners();
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<String> getDeviceId() async {
    return await messaging.getToken() ?? '';
  }

  double balance = 0;

  double calculateBalance() {
    double totalBalance = 0;
    if (this.userWallets.length == 0) {
      return 0;
    }

    for (var item in this.userWallets) {
      totalBalance = totalBalance + item.balance;
    }

    this.totalBalance = totalBalance;
    return totalBalance;
  }

  double _totalBalance = 0;

  double get totalBalance => this._totalBalance;

  set totalBalance(double value) => this._totalBalance = value;

  final _storage = FlutterSecureStorage();

  // token static getters

  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token != null ? token : '';
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password, String deviceId) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};

    final resp = await http.post(
      Uri.parse('${Enviroments.serverHttpUrl}/auth/login'),
      body: jsonEncode(data),
      headers: {'Content-type': 'application/json'},
    );

    this.autenticando = false;

    if (resp.statusCode == 200) {
      saveUserinfo(resp.body);
      await this.saveDeviceId(deviceId);

      return true;
    } else {
      return false;
    }
  }

  Future register(String email, String password, String name) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password, 'name': name};

    final resp = await http.post(
      Uri.parse(
        '${Enviroments.serverHttpUrl}/auth/register',
      ),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(data),
    );

    this.autenticando = false;

    if (resp.statusCode == 200) {
      saveUserinfo(resp.body);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      /* return respBody['msg']; */
      if (respBody['msg'] != null) {
        return respBody['msg'];
      } else {
        final errors = errorResponseFromJson(resp.body).errors;

        final message =
            '${errors?.email?.msg != null ? errors?.email?.msg : ''} \n${errors!.name?.msg != null ? errors.name?.msg : ''} \n ${errors.password!.msg != null ? errors.password?.msg : ''}';
        this.autenticando = false;
        return message;
      }
    }
  }

  Future<bool> isLoggenIn() async {
    final token = await this._storage.read(key: 'token');
    final resp = await http.get(
      Uri.parse('${Enviroments.serverHttpUrl}/auth/renew'),
      headers: {
        'Content-type': 'application/json',
        'x-token': token != null ? token : '',
      },
    );

    if (resp.statusCode == 200) {
      saveUserinfo(resp.body);

      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future<bool> saveDeviceId(String tokenIdDevice) async {
    /* print(tokenIdDevice); */

    final data = {
      'deviceId': tokenIdDevice,
    };

    final resp = await http.post(
      Uri.parse('${Enviroments.serverHttpUrl}/auth/saveNewDevice'),
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
    );

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    final deviceId = await this.getDeviceId();
    final resp = await http.get(
      Uri.parse('${Enviroments.serverHttpUrl}/auth/logout/$deviceId'),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
    );
    await _storage.delete(key: 'token');
    
  }

  void saveUserinfo(String responsebody) async {
    final loginResponse = loginResponseFromJson(responsebody);
    this.usuario = loginResponse.usuario;
    this._userWallets = this.usuario.wallets;
    await this._saveToken(loginResponse.token);
  }
}
