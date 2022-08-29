import 'package:flutter/material.dart';
import 'package:neo_wallet/enviroments/variables_enviroments.dart'
    as Enviroment;

import 'package:neo_wallet/services/auth_services.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  late IO.Socket _socket;

  IO.Socket get socket => _socket;
  Function get emit => this._socket.emit;

  ServerStatus get serverStatus => this._serverStatus;

  void connect() async {
    final token = await AuthService.getToken();
    print('Conectando');

    // Dart client

    this._socket = IO.io(
        Enviroment.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect() // disable auto-connection
            .enableForceNew()
            .setExtraHeaders({
              'foo': 'bar',
              'x-token': token,
            }) // optional
            .build());

    this._socket.on('connect', (_) {
      print('connected socket success');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      print('offline sockets');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  /*  void loadHistory() async {
    print('cargando historial');
    List<UserTransaction> loadTransactions =
        await _transactionsService.getUsersHistoryTransactions();

    _transactions = [];

    final history = loadTransactions.map((h) => HistoryUsersTransactions(
          userTransaction: h,
          animationController: AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 0),
          )..forward(),
        ));
    /* setState(() {
      this._transactions.insertAll(0, history);
    }); */
    this._transactions.insertAll(0, history);
    /* notifyListeners(); */
  }

  void listenTransaction(payload) {
    print('sockets ON $payload');
    final payloadAsObje = UserTransaction.fromJson(payload);

    final newHistoryUsew = new HistoryUsersTransactions(
      userTransaction: payloadAsObje, animationController: null,
    );

    this._transactions.insert(0, newHistoryUsew);
    notifyListeners();
  }

  void disconnect() {
    this._socket.disconnect();
  } */
}
