import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:neo_wallet/models/transactions_response.dart';
import 'package:neo_wallet/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:neo_wallet/services/transactions_services.dart';
import 'package:neo_wallet/widgets/widgets.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final transactionHistory = new TransactionsServices();

  @override
  Widget build(BuildContext context) {
    transactionHistory.getUserTransactionsBloc();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createWalletData(context),
          Container(
            margin: EdgeInsets.only(top: 15, left: 15, bottom: 15),
            child: Text(
              'Transacciones',
              style: TextStyle(color: Colors.white38, fontSize: 17),
            ),
          ),
          //
          Expanded(
            /*  */

            child: StreamBuilder(
              stream: transactionHistory.transactionsStream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return SmartRefresher(
                      onRefresh: _loadTransactions,
                      controller: _refreshController,
                      child: TransactionsInfo(
                        userTransaction: snapshot.data,
                      ));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createWalletData(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final authServices = Provider.of<AuthService>(context);

    final titleStyle = TextStyle(
        color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500);
    final subTitleStyle = TextStyle(color: Colors.white, fontSize: 16);

    return Container(
      padding: EdgeInsets.all(15),
      height: mediaQuery.height * 0.37,
      width: double.infinity,
      /* color: Colors.blue, */
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF06B1FF),
            Color(0xFF0076FE),
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text('Bolivianos', style: titleStyle),
                Text('${authServices.calculateBalance()}',
                    style: subTitleStyle),
              ],
            ),
            Column(
              children: [
                Text('0.00000000012 ETH', style: titleStyle),
                Text('${authServices.calculateBalance() / 6.96} USD',
                    style: subTitleStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonWithIcon(
                  label: 'Enviar',
                  icon: (Ionicons.paper_plane),
                  buttonBorderPrimary: false,
                  onPressed: () => {
                    /* Navigator.pushNamed(context, 'sendPage'); */
                    Navigator.pushNamed(context, 'userWalletSelect'),
                  },
                ),
                ButtonWithIcon(
                  label: 'Recibir',
                  icon: Ionicons.qr_code,
                  buttonBorderPrimary: false,
                  onPressed: () {
                    Navigator.pushNamed(context, 'newWallet',
                        arguments: 'wallet_page');
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _createInfoBloc(
      BuildContext context, UserTransaction userTransaction) {
    final authService = Provider.of<AuthService>(context);

    final color = Color(0xff7BC896);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Color(0xff212B37),
        border: Border.all(width: 0.5, color: Colors.black),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    userTransaction.destinyUser != authService.usuario.uid
                        ? Icons.arrow_circle_up
                        : Icons.arrow_circle_down,
                    size: 35,
                    color: color,
                  ),
                  SizedBox(width: 5),
                  Text(
                    userTransaction.destinyUser != authService.usuario.uid
                        ? 'Enviado'
                        : 'Recibido',
                    style: TextStyle(fontSize: 18, color: color),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    /* '01/05/2021, 14:33', */
                    '${userTransaction.createdAt.day}/${userTransaction.createdAt.month}/${userTransaction.createdAt.year}  ${userTransaction.createdAt.hour}:${userTransaction.createdAt.minute}',
                    style: TextStyle(fontSize: 13, color: Colors.white54),
                  ),
                  SizedBox(height: 7),
                  Text(
                    /* '0x1750bab89...4fd626984e0', */
                    '${userTransaction.originUser}',
                    style: TextStyle(fontSize: 13, color: Colors.white54),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          Divider(
            color: Colors.white38,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'transactionDetails');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // amount
                  '${userTransaction.amount} BOBS',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createTransaction(List<UserTransaction> userTransaction) {
    return ListView.builder(
      padding: EdgeInsets.all(15),
      scrollDirection: Axis.vertical,
      itemCount: userTransaction.length,
      itemBuilder: (BuildContext context, int i) =>
          _createInfoBloc(context, userTransaction[i]),
      /* children: [
                    /* _createInfoBloc(),
                    _createInfoBloc(),
                    _createInfoBloc(), */
                        
                    
                    
                  ], */
    );
  }

  void _loadTransactions() async {
    transactionHistory.getUserTransactions();

    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
