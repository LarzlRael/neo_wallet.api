import 'package:flutter/material.dart';
import 'package:neo_wallet/pages/tabs/assets_tab_page.dart';
import 'package:neo_wallet/pages/tabs/transcations_tab_page.dart';
import 'package:neo_wallet/services/auth_services.dart';
import 'package:neo_wallet/services/transactions_services.dart';

import 'package:provider/provider.dart';

class ItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    final transactions = TransactionsServices();

    transactions.getUsersHistoryTransactions();

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(usuario.name),
          centerTitle: true,
          elevation: 5,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.grid_on_sharp)),
          ],
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.qr_code)),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: null,
                text: 'Your assets',
              ),
              Tab(
                icon: null,
                text: 'Transactions',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            AssetsTabPage(),
            TransaccionTabPage(),
          ],
        ),
      ),
    );
  }
}
