import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:neo_wallet/enviroments/variables_enviroments.dart'
    as Enviroments;
import 'package:neo_wallet/models/send_amout_response.dart';
import 'package:neo_wallet/models/transactions_response.dart';

import 'auth_services.dart';

class TransactionsServices with ChangeNotifier {
  //

  final _transactionsStreamController =
      StreamController<List<UserTransaction>>.broadcast();

  Function(List<UserTransaction>) get transactionsSink =>
      _transactionsStreamController.sink.add;

  Stream<List<UserTransaction>> get transactionsStream =>
      _transactionsStreamController.stream;

  void disposeStream() {
    _transactionsStreamController.close();
  }

  bool _isSending = false;

  set isSending(bool valor) {
    this._isSending = valor;
    notifyListeners();
  }

  bool get isSending => this._isSending;

  getUserTransactionsBloc() async {
    _transactionsStreamController.sink.add(await this.getUserTransactions());
    /* transactionsSink(_transactionsByUser); */
  }

  Future<List<UserTransaction>> getUserTransactions() async {
    final resp = await http.get(
      Uri.parse('${Enviroments.serverHttpUrl}/transactions/gettransactions/'),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken()
      },
    );

    final transactionsResponse = transactionsResponseFromJson(resp.body);

    return transactionsResponse.userTransactions;
  }

  Future<bool> sendAmountToServer({
    required int amount,
    required String userOriginWallet,
    required String userTargetWallet,
    required String userOriginName,
  }) async {
    this.isSending = true;

    final data = {
      'amount': amount,
      'userOriginWallet': userOriginWallet,
      'userTargetWallet': userTargetWallet,
      'userOriginName': userOriginName,
    };
    final resp = await http.post(
      Uri.parse('${Enviroments.serverHttpUrl}/transactions/send/'),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
      body: jsonEncode(data),
    );

    this.isSending = false;

    if (resp.statusCode == 200) {
      final datax = sendAmoutResponseFromJson(resp.body);
      return datax.ok;
    } else {
      return false;
    }
  }

  Future<List<UserTransaction>> getUsersHistoryTransactions() async {
    final resp = await http.get(
      Uri.parse(
          '${Enviroments.serverHttpUrl}/transactions/transactionsHistory/'),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
    );

    final transactionsResponse = transactionsResponseFromJson(resp.body);

    return transactionsResponse.userTransactions;
  }

  Future<List<UserTransaction>> transactionByWallet(String walletId) async {
    final data = {'walletId': walletId};

    final resp = await http.post(
      Uri.parse(
        '${Enviroments.serverHttpUrl}/transactions/transactionByWallet',
      ),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
      body: jsonEncode(data),
    );

    return transactionsResponseFromJson(resp.body).userTransactions;
  }
}
