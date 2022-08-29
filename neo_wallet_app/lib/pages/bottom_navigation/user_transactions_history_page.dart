import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:neo_wallet/models/transactions_response.dart';
import 'package:neo_wallet/services/socket_service.dart';
import 'package:neo_wallet/services/transactions_services.dart';
import 'package:neo_wallet/widgets/widgets.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserTransactionsHistoryPage extends StatefulWidget {
  @override
  _UserTransactionsHistoryPageState createState() =>
      _UserTransactionsHistoryPageState();
}

class _UserTransactionsHistoryPageState
    extends State<UserTransactionsHistoryPage> with TickerProviderStateMixin {
  late SocketService socketService;
  late TransactionsServices _transactionsService;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<HistoryUsersTransactions> _transactions = [];

  @override
  void initState() {
    this._transactionsService = TransactionsServices();
/*     this.socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('transaction-real-time', listenTransaction); */
    this.loadHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transacciones de otras personas'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            /* Center(
                child: socketService.serverStatus == ServerStatus.Online
                    ? Text('Conectando')
                    : Text('Desconectando'),
              ), */
            Expanded(
              child: SmartRefresher(
                onRefresh: loadHistory,
                controller: _refreshController,
                child: FadeInDown(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: this._transactions.length,
                    itemBuilder: (_, i) => this._transactions[i],
                    /* reverse: true, */
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadHistory() async {
    List<UserTransaction> loadTransactions =
        await _transactionsService.getUsersHistoryTransactions();

    final history = loadTransactions.map((h) => HistoryUsersTransactions(
          userTransaction: h,
          animationController: AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 0),
          )..forward(),
        ));
    setState(() {
      this._transactions = [];
      this._transactions.insertAll(0, history);
    });

    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void listenTransaction(payload) {
    print('sockets ON $payload');
    final payloadAsObje = UserTransaction.fromJson(payload);

    final newHistoryUsew = new HistoryUsersTransactions(
      userTransaction: payloadAsObje,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 0),
      )..forward(),
    );

    this._transactions.insert(0, newHistoryUsew);
    setState(() {});
  }

  @override
  void dispose() {
    for (HistoryUsersTransactions message in _transactions) {
      message.animationController.dispose();
    }

    /*  this.socketService.socket.off('mensaje-personal'); */
    super.dispose();
  }
}
//TODO fix the sending error, with state loading  [x]


