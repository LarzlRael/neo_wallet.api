import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:neo_wallet/enviroments/variables_enviroments.dart'
    as Enviroments;

import 'package:neo_wallet/models/wallets_users_response.dart';

import 'auth_services.dart';

class WalletServices {
  String _url = '${Enviroments.serverHttpUrl}/wallet';

  final _userWalletsController = StreamController<List<UserWallet>>.broadcast();

  Function(List<UserWallet>) get userWalletsSink =>
      _userWalletsController.sink.add;

  Stream<List<UserWallet>> get userWalletsStream =>
      _userWalletsController.stream;

  void disposeStream() {
    _userWalletsController.close();
  }

  Future<List<UserWallet>> getUsersWallets() async {
    final resp = await http.get(
      Uri.parse('$_url/walletbyuser'),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken()
      },
    );

    /* print(resp.body); */
    if (resp.statusCode == 200) {
      final transactionsResponse = userWalletsResponseFromJson(resp.body);

      return transactionsResponse.userWallets;
    }
    return [];
  }

  getUserWalletsBloc() async {
    _userWalletsController.sink.add(await this.getUsersWallets());
  }

  Future<bool> createNewWallet(String walletName) async {
    final data = {'walletName': walletName};

    final resp = await http.post(
      Uri.parse(
        '$_url/createwallet',
      ),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
      body: jsonEncode(data),
    );

    final respBody = jsonDecode(resp.body);

    this.getUserWalletsBloc();

    return respBody['ok'];
  }

  Future<bool> deleteWallet(String idWallet) async {
    final data = {'walletId': idWallet};

    final resp = await http.delete(
      Uri.parse(
        '$_url/deleteWallet',
      ),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
      body: jsonEncode(data),
    );

    final respBody = jsonDecode(resp.body);

    return respBody['ok'];
  }

  Future<bool> renameWallet(String idWallet, String newName) async {
    final data = {'walletId': idWallet, 'newName': newName};

    final resp = await http.put(
      Uri.parse(
        '$_url/renameWallet',
      ),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
      body: jsonEncode(data),
    );

    final respBody = jsonDecode(resp.body);
    return respBody['ok'];
  }
}
